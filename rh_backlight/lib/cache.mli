open Rhul
open Core

type error = Defaults of Defaults.error | Ic of exn | Oc of exn

val cache : unit -> (Path.t, error) Result.t
val read : unit -> (Sexp.t, error) Result.t
val write : Sexp.t -> (unit, error) Result.t
