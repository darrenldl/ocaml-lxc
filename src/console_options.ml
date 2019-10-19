type t =
  { tty_num : int
  ; stdin_fd : int
  ; stdout_fd : int
  ; stderr_fd : int
  ; escape_char : char }

let default =
  {tty_num = -1; stdin_fd = 0; stdout_fd = 1; stderr_fd = 2; escape_char = 'a'}
