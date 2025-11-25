open Core

type dev_class = Backlight | Leds
type t
type error = Device of t | Path of string

val get_name : t -> string
val get_class : t -> dev_class
val get_brightness : t -> int
val get_max_brightness : t -> int
val read_path : string -> (t, error) Result.t
val read_device : t -> (t, error) Result.t
