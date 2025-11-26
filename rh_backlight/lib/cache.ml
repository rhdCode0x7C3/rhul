open Rhul
open Core
open Result
open Result.Let_syntax

type error =
  | Defaults of Defaults.error
  | Path of Path.error
  | Filesystem of Filesystem.error
  | Ic of exn
  | Oc of exn

let error_to_string = function
  | Defaults e -> Defaults.error_to_string e
  | Path e -> Path.error_to_string e
  | Filesystem e -> Filesystem.error_to_string e
  | Ic _ -> Printf.sprintf "Failed to open an input channel"
  | Oc _ -> Printf.sprintf "Failed to open an output channel"

let map_defaults_error = map_error ~f:(fun e -> Defaults e)
let map_fs_error = map_error ~f:(fun e -> Filesystem e)

let cache () =
  let append a ~suffix = Path.append_unsafe (Path.of_string suffix) a in
  let%bind cache_base = Defaults.cache_dir () |> map_defaults_error in
  Ok (cache_base |> append ~suffix:Globals.app_name |> append ~suffix:"cache")

let read () =
  let%bind cache = cache () in
  try Ok (In_channel.read_all (Path.to_string cache) |> Sexp.of_string)
  with exn -> Error (Ic exn)

let write (data : Sexp.t) =
  let open Path in
  let open Filesystem in
  let str = Sexp.to_string data in
  let try_write path data =
    try Ok (Out_channel.write_all (Path.to_string path) ~data)
    with exn -> Error (Oc exn)
  in
  let%bind cache = cache () in
  if exists (parent cache) then try_write cache str
  else
    let%bind _ = mkdir_parent cache |> map_fs_error in
    try_write cache str
