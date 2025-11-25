type fragment = string
type t
type error = Validation of string

val of_string : string -> (t, error) Result.t
(** Converts a string into a Path.t, succeeding if the input string is a valid
    path. *)

val equal : t -> t -> bool
val get_fragments : t -> fragment list
val is_absolute : t -> bool
val is_relative : t -> bool
val append : t -> fragment -> t
val to_string : t -> string
