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

let create_doc ?doc elts =
  let doc = match doc with
    | None -> Bson.empty
    | Some doc -> doc
  in
  List.fold_left
    (fun doc (name,elt) ->
      Bson.add_element name (to_elt elt) doc)
    (doc) (elts)
