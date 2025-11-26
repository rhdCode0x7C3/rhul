open Core

type fragment = string
type t

val pp : Format.formatter -> t -> unit [@@ocaml.toplevel_printer]
val to_string : t -> string

type error = Validation of t

val error_to_string : error -> string

val of_string : string -> t
(** Returns a Path.t, constructed from a string. No validation is performed. If
    the string begins with "/" an absolute path is created, otherwise a relative
    path is created. *)

val equal : t -> t -> bool
(** Returns true if two paths are equal. *)

val to_fragments : t -> fragment list
(** Returns the list of fragments making up a path. In the case of an absolute
    path, the first fragment will be an empty string. *)

val is_absolute : t -> bool
(** Returns true if the supplied path is an absolute path. *)

val is_relative : t -> bool
(** Returns true if the supplied path is a relative path. *)

val append : relative:t -> to_path:t -> (t, error) Result.t
(** Appends relative to to_path. If relative is an absolute path, the function
    returns an error. *)

val append_unsafe : t -> t -> t
(** Appends the second path to the first, with no validation checks. *)

val prepend : t -> to_path:t -> t
(** Prepends the supplied path to to_path. An absolute prefix results in an
    absolute path output, and vice-versa. *)

val parent : t -> t
(** Returns the parent directory of the supplied path. If the supplied path is
    the filesystem root or the current working directory, the same path is
    returned.*)
