open Core

type t = Device.t list [@@deriving sexp, show]

let scan () =
  let ls basedir =
    let full_path basedir fn = basedir ^ fn in
    Sys_unix.ls_dir basedir |> List.map ~f:(full_path basedir)
  in
  let filter_errors l =
    let rec f_inner l acc =
      match l with
      | [] -> acc
      | Ok x :: t -> f_inner t (x :: acc)
      | _ :: t -> f_inner t acc
    in
    f_inner l []
  in
  List.map
    (List.merge
       (ls Globals.backlight_path)
       (ls Globals.leds_path) ~compare:String.compare)
    ~f:(fun path -> Device.read_path path)
  |> filter_errors

let save l = l |> sexp_of_t |> Cache.write
