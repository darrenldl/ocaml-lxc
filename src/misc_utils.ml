open Ctypes
module Bigstring = Core.Bigstring

let int_to_bool x = x <> 0

let int_to_unit_result_zero_is_ok x = if x = 0 then Ok () else Error ()

let bool_to_unit_result_true_is_ok x = if x then Ok () else Error ()

let bool_to_int x = if x then 1 else 0

let want_to_bool (x : [`Yes | `No]) =
  match x with `Yes -> true | `No -> false

let lor_flags (f : 'a -> int) (l : 'a list) : int =
  List.fold_left (fun acc x -> f x lor acc) 0 l

  let free_ptr (typ : 'a ptr typ) ret_ptr =
    let ret_ptr = coerce typ (ptr char) ret_ptr in
    Stubs.Fun_stubs.free ret_ptr

  let free_char_ptr ret_ptr = free_ptr (ptr char) ret_ptr

  let strlen ptr =
    let len = Stubs.Fun_stubs.strlen ptr in
    Signed.Long.to_int len

  let elements_from_null_term_ptr (ptr : 'a ptr) : 'a list =
    let rec aux acc ptr =
      if is_null ptr then List.rev acc else aux (!@ptr :: acc) (ptr +@ 1)
    in
    aux [] ptr

  let string_from_string_ptr ?(free = false) (ptr : char ptr) =
    let length = strlen ptr in
    let ret = string_from_ptr ptr ~length in
    if free then free_char_ptr ptr;
    ret

  let string_from_carray (arr : char CArray.t) =
    string_from_string_ptr (CArray.start arr)

  let bigstring_from_string_ptr ptr : Bigstring.t =
    let length = strlen ptr in
    bigarray_of_ptr array1 length Bigarray.Char ptr

  let string_list_from_string_ptr_arr_ptr ?(free = false)
      ?(free_each_ptr_in_arr = false) ~(count : int) (p : char ptr ptr ptr) =
    assert (count >= 0);
    let ret =
      CArray.from_ptr p count |> CArray.to_list
      |> List.map (fun ptr ->
          string_from_string_ptr ~free:free_each_ptr_in_arr !@ptr)
    in
    if free then free_ptr (ptr (ptr (ptr char))) p;
    ret

  let string_list_from_string_ptr_null_term_arr_ptr ?(free = false)
      ?(free_each_ptr_in_arr = false) (p : char ptr ptr ptr) =
    let ret =
      elements_from_null_term_ptr p
      |> List.map (fun p ->
          string_from_string_ptr ~free:free_each_ptr_in_arr !@p)
    in
    if free then free_ptr (ptr (ptr (ptr char))) p;
    ret

  let string_list_from_string_null_term_arr_ptr ?(free = false)
      ?(free_each_ptr_in_arr = false) (p : char ptr ptr) =
    let ret =
      elements_from_null_term_ptr p
      |> List.map (fun p ->
          string_from_string_ptr ~free:free_each_ptr_in_arr p)
    in
    if free then free_ptr (ptr (ptr char)) p;
    ret

  let make_null_ptr (typ : 'a ptr typ) : 'a ptr = coerce (ptr void) typ null

  let allocate_ptr_init_to_null (typ : 'a ptr typ) : 'a ptr ptr =
    allocate typ (make_null_ptr typ)

  let string_carray_from_string_list l =
    l
    |> List.map (fun s -> s |> CArray.of_string |> CArray.start)
    |> CArray.of_list (ptr char)

  let string_arr_ptr_from_string_list l =
    l |> string_carray_from_string_list |> CArray.start

  let string_carray_from_string_arr arr =
    string_carray_from_string_list (Array.to_list arr)

  let string_arr_ptr_from_string_arr arr =
    string_arr_ptr_from_string_list (Array.to_list arr)

  let string_ptr_from_string s = s |> CArray.of_string |> CArray.start
