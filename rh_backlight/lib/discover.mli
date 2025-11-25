open Core

type t = Device.t list [@@deriving sexp, show]

val pp : Format.formatter -> t -> unit [@@ocaml.toplevel_printer]

val scan : unit -> Device.t list

val save : t -> (unit, Cache.error) Result.t
