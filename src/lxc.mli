type container

val new_container :
  name:string -> config_path:string -> (container, unit) result

val release : container -> (unit, unit) result
