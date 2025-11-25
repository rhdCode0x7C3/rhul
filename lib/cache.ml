let cache_dir () =
  match Env.get "XDG_CACHE_HOME" with
  | Some s -> (
      match s with
      | Val v -> Path.of_string v
      | Vals v -> Path.of_string (List.hd v))
  | None -> failwith "no"
