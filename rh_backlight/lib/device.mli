open Core

type dev_class = Backlight | Leds [@@deriving show]
type t [@@deriving show]
type error = Device of t | Path of string

(* Printers *)
val pp : Format.formatter -> t -> unit [@@ocaml.toplevel_printer]

(* Serialization *)
val t_of_sexp : Sexp.t -> t
val sexp_of_t : t -> Sexp.t

val get_name : t -> string
val get_class : t -> dev_class
val get_brightness : t -> int
val get_max_brightness : t -> int
val read_path : string -> (t, error) Result.t
val read_device : t -> (t, error) Result.t
