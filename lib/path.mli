type fragment = string
type t

val of_string : string -> t
(** Converts a string into a Path.t, succeeding if the input string is a valid
    path. *)

val equal : t -> t -> bool
val to_fragments : t -> fragment list
val is_absolute : t -> bool
val is_relative : t -> bool
val append : t -> to_path:t -> t
val prepend : t -> to_path:t -> t
val to_string : t -> string
val exists : t -> bool
val is_readable : t -> bool
val is_writeable : t -> bool

