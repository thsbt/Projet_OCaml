open Game

(* Returns the best result the current player can reach. 
 * Returns None if the game is finished in the current state. *)
val best_move: state -> move option * result

(*
val best_move_with_depth: state*int -> move option * result*)
