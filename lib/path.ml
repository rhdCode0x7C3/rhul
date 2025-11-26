(* Heavily inspired by YOcaml.Path *)

open Core

type fragment = string
type t = Relative of fragment list | Absolute of fragment list
type error = Validation of t

let pp ppf (t : t) =
  let sep = Filename.dir_sep in
  let concat fragments = String.concat fragments ~sep in
  match t with
  | Absolute l -> Format.fprintf ppf "%s" (concat l)
  | Relative l -> Format.fprintf ppf "%s" (concat l)

let to_string = Format.asprintf "%a" pp

let error_to_string = function
  | Validation t ->
      Printf.sprintf "Path validation failed on %s\n" (to_string t)

let equal a b =
  match (a, b) with
  | Absolute a, Absolute b | Relative a, Relative b ->
      List.equal String.equal a b
  | _ -> false

let to_fragments = function Absolute l -> l | Relative l -> l
let is_absolute = function Absolute _ -> true | _ -> false
let is_relative = function Relative _ -> true | _ -> false

let remove_inner_empty l =
  let rec inner acc l =
    match l with
    | [] -> acc
    | h :: t ->
        if String.is_empty h then
          match acc with [] -> inner (h :: acc) t | _ -> inner acc t
        else inner (h :: acc) t
  in
  List.rev (inner [] l)

let append ~relative ~to_path =
  match relative with
  | Absolute _ -> Error (Validation relative)
  | Relative _ -> (
      let suffix = to_fragments relative in
      match to_path with
      | Absolute l -> Ok (Absolute (l @ suffix))
      | Relative l -> Ok (Relative (l @ suffix)))

let append_unsafe to_path suffix =
  let px = to_fragments suffix in
  let sx = to_fragments to_path in
  if is_absolute to_path then Absolute (px @ sx |> remove_inner_empty)
  else Relative (px @ sx |> remove_inner_empty)

let prepend prefix ~to_path =
  let px = to_fragments prefix in
  let sx = to_fragments to_path in
  if is_absolute prefix then Absolute (px @ sx |> remove_inner_empty)
  else Relative (px @ sx |> remove_inner_empty)

let of_string (s : string) =
  let is_abs s = match String.index s '/' with Some 0 -> true | _ -> false in
  let to_list s = String.split s ~on:'/' in
  if is_abs s then Absolute (to_list s |> remove_inner_empty)
  else Relative (to_list s |> remove_inner_empty)

let parent t =
  let rec inner acc fragments =
    match fragments with
    | [] -> acc
    | _ :: [] -> acc
    | h :: t -> inner (h :: acc) t
  in
  let parent = List.rev (inner [] (to_fragments t)) in
  match t with Absolute _ -> Absolute parent | Relative _ -> Relative parent
