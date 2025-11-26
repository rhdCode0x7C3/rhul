open Core

type t = Val of string | Vals of string list

type error = Bad_type
val error_to_string : error -> string

val get : string -> t option

val value : t -> (string, error) Result.t
val values : t -> (string list, error) Result.t
