Bsonl.ml
===

**Bsonl**: BSON document layer. This ocaml module let you write your **Bson** document in a much more expressive way.

It removes all the lack of writing BSON document by wrapping BSON types in OCaml polymorphic variant types.

There is also some helpers to create document easily.

###Syntax:

Here the normal usage of Bson module to create a basic document with only two fields (name and id).

```
let doc = Bson.empty in
let id_elt = Bson.create_int64 0 in
let name_elt = Bson.create_string "charly" in
let doc = Bson.add_element "id" id_elt doc in
let doc = Bson.add_element "name" name_elt doc in
...
```

Here the Bsonl version:

```
let doc =
  Bsonl.create_doc [
    ("id", `int64 0);
  	("name", `string "charly");
  ]
in
...
```

###Installation:

As usual:

```
make
make install
```

###TODO:
- opam packages
- add missing types
- add operators
- ...
