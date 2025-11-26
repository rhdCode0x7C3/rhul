open Core
type fragment = string
type t
val pp : Format.formatter -> t -> unit [@@ocaml.toplevel_printer]
val to_string : t -> string

type error = Validation of t
val error_to_string : error -> string

val of_string : string -> t
val equal : t -> t -> bool
val to_fragments : t -> fragment list
val is_absolute : t -> bool
val is_relative : t -> bool
val append : relative:t -> to_path:t -> (t, error) Result.t
val append_unsafe : t -> t -> t
val prepend : t -> to_path:t -> t

val parent : t -> t
