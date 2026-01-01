open Core
module D = Device

module Display : sig
  val to_string : D.t -> string
end = struct
  let name device =
    let s = D.get_name device in
    Printf.sprintf "Name:           %s" s

  let dev_class device =
    let string_of_class (dev_class : D.dev_class) =
      match dev_class with Backlight -> "Backlight" | Leds -> "LED"
    in
    Printf.sprintf "Class:          %s" (string_of_class (D.get_class device))

  let brightness device =
    let s = Int.to_string (D.get_brightness device) in
    Printf.sprintf "Brightness:     %s" s

  let max_brightness device =
    let s = Int.to_string (D.get_max_brightness device) in
    Printf.sprintf "Max Brightness: %s" s

  let to_string device =
    String.concat ~sep:"\n"
      [
        name device; dev_class device; brightness device; max_brightness device;
      ]
end

module Scan : sig
  val to_string : D.t list -> string
end = struct
  let header = "rh-backlight scan found the following devices:"
  let footer = "Footer placeholder text"

  let to_string (scan : D.t list) =
    Printf.sprintf "%s\n\n%s\n\n%s\n" header
      (String.concat (List.map scan ~f:Display.to_string) ~sep:"\n\n")
      footer
end
