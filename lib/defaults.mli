type error = Env of Env.error | Path of Path.error | Defaults of string

val error_to_string : error -> string
val home : unit -> (Path.t, error) Result.t
val runtime_dir : unit -> (Path.t, error) Result.t
val cache_dir : unit -> (Path.t, error) Result.t
val data_dir : unit -> (Path.t, error) Result.t
val state_dir : unit -> (Path.t, error) Result.t
val config_dir : unit -> (Path.t, error) Result.t
val essential_var : string -> (Path.t, error) Result.t
