type container

val new_container :
  name:string -> config_path:string option -> (container, unit) result

val release : container -> (unit, unit) result
