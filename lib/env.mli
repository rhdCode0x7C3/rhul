open Core

type t =
  | Val of string
  | Vals of string list
      (** Val: the raw value of an environment variable. Vals: The raw value,
          split on ':'. Useful for $PATH and other path lists. *)

type error = Bad_type

val error_to_string : error -> string

val get : string -> t option
(** Returns Some t if the environment variable is set. Otherwise returns None.*)

val value : t -> (string, error) Result.t
(** Gets the value from a t. Returns an error if the t contains Vals. *)

val values : t -> (string list, error) Result.t
(** Gets the values from a t. Returns an error if the t contains a Val. *)
