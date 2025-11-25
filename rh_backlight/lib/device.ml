open Core

type dev_class = Backlight | Leds

type t = {
  name : string;
  dev_class : dev_class;
  brightness : int;
  max_brightness : int;
}

type error = Device of t | Path of string

let make ~name ~dev_class ~brightness ~max_brightness =
  { name; dev_class; brightness; max_brightness }

let backlight_path = "/sys/class/backlight/"
let leds_path = "/sys/class/leds/"

let to_path device =
  let p =
    match device.dev_class with
    | Backlight -> backlight_path ^ device.name
    | Leds -> leds_path ^ device.name
  in
  match Core_unix.access p [ `Exists ] with
  | Ok () -> Ok p
  | _ -> Error (Device device)

let read_path path =
  let open Result in
  let open Result.Let_syntax in
  let to_int s = s |> String.strip |> Int.of_string in
  let%bind name =
    match String.rsplit2 path ~on:'/' with
    | Some (_, b) -> Ok b
    | None -> Error (Path path)
  in
  let dev_class =
    if String.is_substring path ~substring:backlight_path then Backlight
    else Leds
  in
  let brightness = In_channel.read_all (path ^ "/brightness") |> to_int in
  let max_brightness =
    In_channel.read_all (path ^ "/max_brightness") |> to_int
  in
  Ok (make ~name ~dev_class ~brightness ~max_brightness)

let read_device device =
  let open Result in
  let open Result.Let_syntax in
  let%bind path = to_path device in
  read_path path
