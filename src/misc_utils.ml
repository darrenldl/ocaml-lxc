let int_to_bool x = x <> 0

let int_to_unit_result_zero_is_ok x = if x = 0 then Ok () else Error ()

let bool_to_unit_result_true_is_ok x = if x then Ok () else Error ()

let bool_to_int x = if x then 1 else 0

let want_to_bool (x : [`Yes | `No]) =
  match x with `Yes -> true | `No -> false

let lor_flags (f : 'a -> int) (l : 'a list) : int =
  List.fold_left (fun acc x -> f x lor acc) 0 l
