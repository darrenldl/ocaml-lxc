let int_to_bool x =
  x <> 0

let bool_to_unit_result x =
  if x then Ok () else Error ()
