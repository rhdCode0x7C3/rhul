type error = Env of Env.error | Path of Path.error | Defaults of string

val error_to_string : error -> string
val home : unit -> (Path.t, error) Result.t
(** Returns the path to the user's home folder. If this is not set, the program should crash. *)

val runtime_dir : unit -> (Path.t, error) Result.t
(** Returns the path of $XDG_RUNTIME_DIR. If this is not set, the program should crash. *)

val cache_dir : unit -> (Path.t, error) Result.t
(** Returns the path of $XDG_CACHE_HOME. If this is not set in the environment, a default value of $HOME/.cache is used. *)

val data_dir : unit -> (Path.t, error) Result.t
(** Returns the path of $XDG_DATA_HOME. If this is not set in the environment, a default value of $HOME/.local/share is used. *)

val state_dir : unit -> (Path.t, error) Result.t
(** Returns the path of $XDG_STATE_HOME. If this is not set in the environment, a default value of $HOME/.local/state is used. *)

val config_dir : unit -> (Path.t, error) Result.t
(** Returns the path of $XDG_CONFIG_HOME. If this is not set in the environment, a default value of $HOME/.config is used. *)
