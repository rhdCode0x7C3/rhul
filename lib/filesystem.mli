open Core
open Path

type error = Permissions of Path.t

val error_to_string : error -> string

val exists : t -> bool
(** Returns true if the path exists, otherwise returns false. *)

val is_readable : t -> bool
(** Returns true if the path is readable, otherwise returns false. *)

val is_writeable : t -> bool
(** Returns true if the path is writeable, otherwise returns false. *)

val mkdir_parent : t -> (unit, error) Result.t
(** Recursively makes parent directories to the input path. *)
