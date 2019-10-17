type container

val new_container :
  name:string -> lxcpath:string option -> (container, unit) result

val release : container -> (unit, unit) result
