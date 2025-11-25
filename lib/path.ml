(* Heavily inspired by YOcaml.Path *)

open Core

type fragment = string
type t = Relative of fragment list | Absolute of fragment list
type error = Validation of string

let is_valid t =
  let all_true l = List.fold l ~init:true ~f:(fun acc el -> acc && el) in
  let is_alphanumeric s = String.for_all s ~f:(fun c -> Char.is_alphanum c) in
  let check s =
    (not (String.is_substring s ~substring:"..")) && is_alphanumeric s
  in
  let l = String.split t ~on:'/' in
  if List.is_empty l then false
  else List.map l ~f:(fun s -> check s) |> all_true

let equal a b =
  let equal_fragment = String.equal in
  match (a, b) with
  | Absolute a, Absolute b | Relative a, Relative b ->
      List.equal equal_fragment a b
  | _ -> false

let get_fragments = function Absolute l -> l | Relative l -> l
let is_absolute = function Absolute _ -> true | _ -> false
let is_relative = function Relative _ -> true | _ -> false

let append (path : t) fragment =
  match path with
  | Absolute l -> Absolute (l @ [ fragment ])
  | Relative l -> Relative (l @ [ fragment ])

let of_string (s : string) =
  let is_abs s = match String.index s '/' with Some 0 -> true | _ -> false in
  let to_list s = String.split s ~on:'/' in
  if is_valid s then
    if is_abs s then Ok (Absolute (to_list s)) else Ok (Relative (to_list s))
  else Error (Validation s)

let pp ppf t =
  let sep = Filename.dir_sep in
  let concat fragments = String.concat fragments ~sep in
  match t with
  | Absolute l -> Format.fprintf ppf "%s" (concat l)
  | Relative l -> Format.fprintf ppf "%s" (concat l)

let to_string = Format.asprintf "%a" pp
