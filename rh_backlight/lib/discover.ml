open Core

type error = Path of string

let ls basedir =
  let full_path basedir fn = basedir ^ fn in
  Sys_unix.ls_dir basedir |> List.map ~f:(full_path basedir)

let filter_errors l =
  let rec f_inner l acc =
    match l with
    | [] -> acc
    | Ok x :: t -> f_inner t (x :: acc)
    | _ :: t -> f_inner t acc
  in
  f_inner l []

let all_devices =
  List.map
    (List.merge (ls Device.backlight_path) (ls Device.leds_path)
       ~compare:String.compare)
    ~f:(fun path -> Device.read_path path)
  |> filter_errors
