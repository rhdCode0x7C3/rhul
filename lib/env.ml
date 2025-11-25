open Core

type value = Val of string | Vals of string list
type t = { key : string; value : value option }

let make_value s =
  let l = String.split s ~on:':' in
  if List.length l = 1 then Val s else Vals l

let get key =
  match Sys_unix.unsafe_getenv key with
  | Some v ->
      let v = make_value v in
      { key; value = Some v }
  | None -> { key; value = None }

let is_dev () =
  let kv = get "RHUL_DEV" in
  match kv.value with Some (Val "true") -> true | _ -> false
