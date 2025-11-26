open Core
open Path

type error = Permissions of Path.t

let error_to_string = function
  | Permissions e -> Printf.sprintf "Permissions error:\n%s" (Path.to_string e)

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

let mkdir_parent t =
  try Ok (Core_unix.mkdir_p (t |> parent |> to_string))
  with _ -> Error (Permissions t)
