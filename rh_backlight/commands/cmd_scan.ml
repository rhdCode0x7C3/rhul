open Cmdliner
open Term
open Backlight

let exits = Cmd.Exit.defaults

let handler = function
  | Ok _ ->
      print_endline "exit ok";
      Globals.exit_ok
  | Error e ->
      print_endline (Cache.error_to_string e);
      Globals.exit_err

let run () = Discover.scan () |> Discover.sexp_of_t |> Cache.write ~fn:"scan"

let cmd =
  let doc = "Scan for devices with brightness control" in
  let info = Cmd.info "scan" ~version:Globals.version ~doc ~exits in
  let term =
    let run = const run in
    let handler = const handler in
    let unit = const () in
    handler $ (run $ unit)
  in
  Cmd.make info term
