type bson_element = [
  | `float of float
  | `string of string
  | `doc of Bson.t
  | `elt_list of bson_element list
  | `binary of string
  | `object_id of string
  | `bool of bool
  | `utc of int64
  | `null
  | `regex of string * string
  | `js of string
  | `int of int
  | `int32 of int32
  | `int64 of int64
  | `minkey
  | `maxkey
]

let rec to_elt =
  let open Bson in function
  | `float f -> create_double f
  | `string s -> create_string s
  | `doc d -> create_doc_element d
  | `elt_list (l : bson_element list) -> create_list (List.map to_elt l)
  | `binary b -> create_user_binary b
  | `object_id id -> create_objectId id
  | `bool b -> create_boolean b
  | `utc u -> create_utc u
  | `null -> create_null ()
  | `regex (sa,sb) -> create_regex sa sb
  | `int i -> create_int32 (Int32.of_int i)
  | `js js -> create_jscode js
  | `int32 i -> create_int32 i
  | `int64 i -> create_int64 i
  | `minkey -> create_minkey ()
  | `maxkey -> create_maxkey ()

let to_elts = List.map to_elt

let add_to_doc ~doc elts =
  List.fold_left
    (fun doc (name,elt) ->
      Bson.add_element name (to_elt elt) doc)
    (doc) (elts)

let create_doc ?doc elts =
  let doc = match doc with
    | None -> Bson.empty
    | Some doc -> doc
  in
  add_to_doc ~doc elts

let get_next_seq seq id =
  let default = 1 in
  let to_i32 = Int32.of_int in
  let of_i32 = Int32.to_int in
  let match_ = create_doc [
      ("_id", `string id);
  ] in
  let docs = MongoReply.get_document_list (Mongo.find_q seq match_) in
  if List.length docs = 0 then begin
    Mongo.insert seq [create_doc ~doc:match_ [
        ("seq", `int32 (to_i32 default));
      ]
    ];
    default
  end else begin
    let doc = List.nth docs 0 in
    let doc' = create_doc [
        ("$inc", `doc (create_doc [
            ("seq", `int32 (to_i32 1));
        ]))
    ] in
    Mongo.update_one seq (match_, doc');
    (of_i32 (Bson.get_int32 (Bson.get_element "seq" doc))) + 1
  end
