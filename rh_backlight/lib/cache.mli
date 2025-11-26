open Rhul
open Core

type error =
  | Defaults of Defaults.error
  | Path of Path.error
  | Filesystem of Filesystem.error
  | Ic of exn
  | Oc of exn

  val error_to_string : error -> string

val cache : unit -> (Path.t, error) Result.t
val read : unit -> (Sexp.t, error) Result.t
val write : Sexp.t -> (unit, error) Result.t
