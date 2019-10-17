type container

val new_container :
  ?config_path:string -> name:string -> (container, unit) result

val release : container -> (unit, unit) result
