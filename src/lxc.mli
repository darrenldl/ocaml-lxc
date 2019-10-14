type t

val new_container : name:string -> config_path:string -> (t, unit) result

val release : t -> (unit, unit) result
