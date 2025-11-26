open Core
open Path

type error = Permissions of Path.t

val error_to_string : error -> string

val exists : t -> bool
val is_readable : t -> bool
val is_writeable : t -> bool
val mkdir_parent : t -> (unit, error) Result.t
