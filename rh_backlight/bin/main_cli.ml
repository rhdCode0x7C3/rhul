open Cmdliner
open Commands

let cmd =
  let default =
    Term.(ret (const (`Help (`Auto, None))))
    (* show help *)
  in
  Cmd.group (Cmd.info "backlight_cli") ~default @@ [ Cmd_scan.cmd ]

let main () = Cmd.eval' cmd
let () = if !Sys.interactive then () else exit (main ())
