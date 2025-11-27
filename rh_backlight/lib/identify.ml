open Core

let search terms l =
  let search term l =
    List.filter l ~f:(fun e -> String.is_substring e ~substring:term)
  in
  let rec inner terms l acc =
    match terms with [] -> acc | h :: t -> inner t l (search h l :: acc)
  in
  List.concat (inner terms l [])

let suggest () =
  let devices =
    match Cache.read ~fn:"scan" with
    | Ok l -> Discover.t_of_sexp l
    | Error _ -> Discover.scan ()
  in
  let terms = [ "acklight"; "acklight"; "kbd"; "keyboard" ] in
  let backlight =
    search terms (devices |> List.map ~f:(fun e -> Device.get_name e))
  in
  backlight
