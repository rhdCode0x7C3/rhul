open Core

type t = Val of string | Vals of string list
type error = Bad_type

let make s =
  let l = String.split s ~on:':' in
  if List.length l = 1 then Val s else Vals l

let get key =
  match Sys_unix.unsafe_getenv key with Some v -> Some (make v) | None -> None

let value = function Val s -> Ok s | _ -> Error Bad_type
let values = function Vals l -> Ok l | _ -> Error Bad_type
