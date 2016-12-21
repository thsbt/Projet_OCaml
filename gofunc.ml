open Functory.Network
open Functory.Network.Same

let () = Functory.Control.set_debug true 

(*****************************************************)

let hostname = Unix.gethostname ()
let pid = Unix.getpid () 

(* The map function *)
let zemap n = Printf.sprintf "#%d (computed on %d)" n pid

let mymap n=Printf.printf "\n\n%d\n\n%!" n; [n];;
let amymap n=Printf.printf "\n\n%d\n\n%!" n; n;;
(* The fold function *)
let zefold acu zm = (Printf.sprintf "%s (concat on %d)" zm pid ) ^ "\n" ^ acu

let rec printliste= function 
      | [] -> Printf.printf "\n%!"
      | hd::tl -> Printf.printf " %d " hd; printliste tl

let rec myfold acc x = Printf.printf "===GO===\n%!" ;printliste (acc);match x with 
    | [] -> acc 
    | [res] -> res::acc 
    | hd::tl -> hd::myfold acc tl

let amyfold acc x =Printf.printf "%d\n%!" acc; acc+x

(* Build a test list. *)
let rec loop n acu = if n = 0 then acu else loop (n-1) (n :: acu)

(* This func
   tion main is launched by the _master_ only. *)
let main () =
  Printf.printf "Main\n%!" ;

  (* Declare machines as workers. 
   * You have to launch the current program (in worker mode) on these machines by yourself. *)
  declare_workers ~n:2 "localhost" ;

  let bigl = loop 100 [] in
    Printf.printf "List computed\n%!" ;

    (* Distributed computation 
       let result = map_fold_ac ~f:mymap ~fold:myfold 0 bigl in
    *)  

    let result = map_fold_ac ~f:mymap ~fold:myfold [10] [1;2;3;4;5] in
     (* Printf.printf "Computation done : result = \n%d\n%!" result ;
     *) printliste result;
      		Printf.printf "PID du master : %d\n%!" pid ; 
      ()


(*** Entry point of the program. ***)
let () =

  (* Sys.argv are the command-line arguments. *)
  match Sys.argv with

    (* If there is one argument equal to "master" *)
    | [| _ ; "master" |] -> 
        Printf.printf "I am the master.\n%!" ;
        main ()

    (* Otherwise, we are a worker. *)
    | _ -> 
        Printf.printf "I am a worker.\n%!" ;
        Functory.Network.Same.Worker.compute ()

