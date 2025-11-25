(* Heavily inspired by YOcaml.Path *)

open Core

type fragment = string
type t = Relative of fragment list | Absolute of fragment list

let equal a b =
  let equal_fragment = String.equal in
  match (a, b) with
  | Absolute a, Absolute b | Relative a, Relative b ->
      List.equal equal_fragment a b
  | _ -> false

let to_fragments = function Absolute l -> l | Relative l -> l
let is_absolute = function Absolute _ -> true | _ -> false
let is_relative = function Relative _ -> true | _ -> false

let append suffix ~to_path =
  let suffix = to_fragments suffix in
  match to_path with
  | Absolute l -> Absolute (l @ suffix)
  | Relative l -> Relative (l @ suffix)

let prepend prefix ~to_path =
  let px = to_fragments prefix in
  let sx = to_fragments to_path in
  if is_absolute prefix then Absolute (px @ sx) else Relative (px @ sx)

let of_string (s : string) =
  let is_abs s = match String.index s '/' with Some 0 -> true | _ -> false in
  let to_list s = String.split s ~on:'/' in
  if is_abs s then Absolute (to_list s) else Relative (to_list s)

let pp ppf t =
  let sep = Filename.dir_sep in
  let concat fragments = String.concat fragments ~sep in
  match t with
  | Absolute l -> Format.fprintf ppf "%s" (concat l)
  | Relative l -> Format.fprintf ppf "%s" (concat l)

let to_string = Format.asprintf "%a" pp

let exists t =
  match Core_unix.access (to_string t) [ `Exists ] with
  | Ok () -> true
  | _ -> false

let is_readable t =
  match Core_unix.access (to_string t) [ `Read ] with
  | Ok () -> true
  | _ -> false

let is_writeable t =
  match Core_unix.access (to_string t) [ `Write ] with
  | Ok () -> true
  | _ -> false
