type value = Val of string | Vals of string list
type t = { key : string; value : value option }

val get : string -> t
val is_dev : unit -> bool
