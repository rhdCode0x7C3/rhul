open Rhul
open Core
open Result
open Result.Let_syntax

type error = Defaults of Defaults.error | Ic of exn | Oc of exn

let cache () =
  let%bind cache_dir =
    let%bind cache_base =
      Defaults.cache_dir () |> map_error ~f:(fun e -> Defaults e)
    in
    Ok (Path.append (Path.of_string Globals.app_name) ~to_path:cache_base)
  in
  Ok (Path.append (Path.of_string "cache") ~to_path:cache_dir)

let read () =
  let%bind cache = cache () in
  try Ok (In_channel.read_all (Path.to_string cache) |> Sexp.of_string)
  with exn -> Error (Ic exn)

let write (data : Sexp.t) =
  let str = Sexp.to_string data in
  let%bind cache = cache () in
  if not (Path.exists cache) then Path.create cache;
  try Ok (Out_channel.write_all (Path.to_string cache) ~data:str)
  with exn -> Error (Oc exn)
