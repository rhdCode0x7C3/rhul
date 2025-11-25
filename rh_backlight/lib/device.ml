open Core

type dev_class = Backlight | Leds

type t = {
  name : string;
  dev_class : dev_class;
  brightness : int;
  max_brightness : int;
}

type field = Name | Brightness | Max_brightness
type error = Device of t | Path of string

let get_name device = device.name
let get_class device = device.dev_class
let get_brightness device = device.brightness
let get_max_brightness device = device.max_brightness
let backlight_path = Globals.backlight_path
let leds_path = Globals.leds_path

let make ~name ~dev_class ~brightness ~max_brightness =
  { name; dev_class; brightness; max_brightness }

let to_path device ~field =
  let dev_class_p =
    match device.dev_class with
    | Backlight -> backlight_path
    | Leds -> leds_path
  in
  match field with
  | Name -> dev_class_p ^ device.name
  | Brightness -> dev_class_p ^ device.name ^ "/brightness"
  | Max_brightness -> dev_class_p ^ device.name ^ "/max_brightness"

let is_valid device =
  let is_ok path ~condition =
    match Core_unix.access path condition with Ok () -> true | _ -> false
  in
  let condition field =
    match field with
    | Name | Max_brightness -> [ `Exists; `Read ]
    | Brightness -> [ `Exists; `Read; `Write ]
  in
  let name =
    device |> to_path ~field:Name |> is_ok ~condition:(condition Name)
  in
  let brightness =
    device |> to_path ~field:Brightness
    |> is_ok ~condition:(condition Brightness)
  in
  let max_brightness =
    device
    |> to_path ~field:Max_brightness
    |> is_ok ~condition:(condition Max_brightness)
  in
  name && brightness && max_brightness

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
  let device = make ~name ~dev_class ~brightness ~max_brightness in
  if is_valid device then Ok device else Error (Device device)

let read_device device =
  let path = to_path device ~field:Name in
  read_path path
