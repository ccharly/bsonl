(** This module is layer of [Bson] and [Mongo] libraries. It permits
    you to write your bson document in a much more expressive way.

    @author: Charly Chevalier <lisqlql>
    *)

(** A type which represents a BSON element. *)
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

(** [to_elt elt] ::
    Transform an [bson_element] into an [Bson.element] *)
val to_elt : bson_element -> Bson.element

(** [to_elts elts] ::
    Same as above, but instead of taking only one element, it takes a
    [bson_element] list. *)
val to_elts : bson_element list -> Bson.element list

(** [create_doc ?doc elts] ::
    Helper function to create a BSON document. If [?doc] is not used,
    an empty document [Bson.empty] will be used by default. *)
val create_doc : ?doc:Bson.t -> (string * bson_element) list -> Bson.t

(** [get_next_seq mongo collection] ::
    Helper function to simulate sequence (autoincrement) of an id. *)
val get_next_seq : Mongo.t -> string -> int
