open Core
open Result
open Result.Let_syntax

type error = Env of Env.error | Path of Path.error | Defaults of string

let error_to_string = function
  | Env e -> Env.error_to_string e
  | Path e -> Path.error_to_string e
  | Defaults s -> Printf.sprintf "Failed to set a default value for %s\n" s

let map_env_error = map_error ~f:(fun e -> Env e)
let map_path_error = map_error ~f:(fun e -> Path e)

let is_dev () =
  try
    match Env.get "RHUL_DEV" with
    | Some v -> (
        match Env.value v with Ok v -> v |> Bool.of_string | _ -> false)
    | _ -> false
  with _ -> false

let var_to_path s ~fallback =
  match Env.get s with
  | Some v ->
      let%bind value = Env.value v |> map_env_error in
      let path = Path.of_string value in
      Ok path
  | None -> fallback ()

(* Essential environment variables. The program should fail if these are not set. *)
let essential_var var_name =
  let fallback = fun () -> Error (Defaults var_name) in
  var_to_path var_name ~fallback

let home () = essential_var "HOME"
let runtime_dir () = essential_var "XDG_RUNTIME_DIR"

(* Environment variables with default values. *)
let default_path var_name ~append =
  let make_dev_path (p : (Path.t, error) Result.t) =
    let%bind path = p in
    let%bind prefix = runtime_dir () in
    if is_dev () then Ok (Path.prepend prefix ~to_path:path) else p
  in
  let fallback =
   fun () ->
    let%bind home = home () in
    let%bind p =
      Path.append ~relative:(Path.of_string append) ~to_path:home
      |> map_path_error
    in
    Ok p
  in
  var_to_path var_name ~fallback |> make_dev_path

let cache_dir () = default_path "XDG_CACHE_HOME" ~append:".cache"
let data_dir () = default_path "XDG_DATA_HOME" ~append:".local/share"
let state_dir () = default_path "XDG_STATE_HOME" ~append:".local/state"
let config_dir () = default_path "XDG_CONFIG_HOME" ~append:".config"
