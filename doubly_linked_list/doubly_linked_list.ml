(* Doubly Linked List — OCaml implementation
   Complexity: insert/delete O(1), iter/fold O(n), length O(n)
   Tricky part: mutable option-based prev/next pointers require careful
   pattern matching; no sentinel nodes — we use option types idiomatically.
   Improvement: could track length with a mutable counter for O(1) length. *)

type 'a node = {
  value : 'a;
  mutable prev : 'a node option;
  mutable next : 'a node option;
}

type 'a t = {
  mutable head : 'a node option;
  mutable tail : 'a node option;
}

let create () : 'a t = { head = None; tail = None }

let is_empty (dll : 'a t) : bool = dll.head = None

let push_front (dll : 'a t) (value : 'a) : 'a node =
  let node = { value; prev = None; next = dll.head } in
  (match dll.head with
   | Some old_head -> old_head.prev <- Some node
   | None -> dll.tail <- Some node);
  dll.head <- Some node;
  node

let push_back (dll : 'a t) (value : 'a) : 'a node =
  let node = { value; prev = dll.tail; next = None } in
  (match dll.tail with
   | Some old_tail -> old_tail.next <- Some node
   | None -> dll.head <- Some node);
  dll.tail <- Some node;
  node

let remove (dll : 'a t) (node : 'a node) : 'a =
  (match node.prev with
   | Some p -> p.next <- node.next
   | None -> dll.head <- node.next);
  (match node.next with
   | Some n -> n.prev <- node.prev
   | None -> dll.tail <- node.prev);
  node.prev <- None;
  node.next <- None;
  node.value

let peek_front (dll : 'a t) : 'a option =
  Option.map (fun n -> n.value) dll.head

let peek_back (dll : 'a t) : 'a option =
  Option.map (fun n -> n.value) dll.tail

let pop_front (dll : 'a t) : 'a option =
  Option.map (fun node -> remove dll node) dll.head

let pop_back (dll : 'a t) : 'a option =
  Option.map (fun node -> remove dll node) dll.tail

(* Fold left-to-right (head to tail) *)
let fold_left (f : 'acc -> 'a -> 'acc) (init : 'acc) (dll : 'a t) : 'acc =
  let rec go acc = function
    | None -> acc
    | Some node -> go (f acc node.value) node.next
  in
  go init dll.head

(* Fold right-to-left (tail to head) *)
let fold_right (f : 'a -> 'acc -> 'acc) (dll : 'a t) (init : 'acc) : 'acc =
  let rec go acc = function
    | None -> acc
    | Some node -> go (f node.value acc) node.prev
  in
  go init dll.tail

let iter (f : 'a -> unit) (dll : 'a t) : unit =
  fold_left (fun () x -> f x) () dll

let to_list (dll : 'a t) : 'a list =
  fold_right (fun x acc -> x :: acc) dll []

let to_list_rev (dll : 'a t) : 'a list =
  fold_left (fun acc x -> x :: acc) [] dll

let length (dll : 'a t) : int =
  fold_left (fun n _ -> n + 1) 0 dll

let reverse (dll : 'a t) : unit =
  let rec go = function
    | None -> ()
    | Some node ->
      let tmp = node.next in
      node.next <- node.prev;
      node.prev <- tmp;
      go tmp
  in
  go dll.head;
  let tmp = dll.head in
  dll.head <- dll.tail;
  dll.tail <- tmp

(* Move an existing node to the front — useful for LRU caches *)
let move_to_front (dll : 'a t) (node : 'a node) : unit =
  ignore (remove dll node);
  node.next <- dll.head;
  node.prev <- None;
  (match dll.head with
   | Some old_head -> old_head.prev <- Some node
   | None -> dll.tail <- Some node);
  dll.head <- Some node

let pp (pp_elt : Format.formatter -> 'a -> unit) (fmt : Format.formatter) (dll : 'a t) : unit =
  Format.fprintf fmt "[";
  let first = ref true in
  iter (fun x ->
    if !first then first := false
    else Format.fprintf fmt "; ";
    pp_elt fmt x
  ) dll;
  Format.fprintf fmt "]"

(* ── Demo ── *)
let () =
  let dll = create () in
  let _ = push_front dll 1 in
  let _ = push_front dll 2 in
  let _ = push_back dll 3 in

  Printf.printf "Forward:  ";
  Format.printf "%a\n" (pp Format.pp_print_int) dll;
  (* expect [2; 1; 3] *)

  Printf.printf "Backward: [%s]\n"
    (String.concat "; " (List.map string_of_int (to_list_rev dll)));
  (* expect [3; 1; 2] *)

  reverse dll;
  Printf.printf "Reversed: ";
  Format.printf "%a\n" (pp Format.pp_print_int) dll;
  (* expect [3; 1; 2] *)

  let n99 = push_front dll 99 in
  let n100 = push_back dll 100 in
  Printf.printf "Added:    ";
  Format.printf "%a\n" (pp Format.pp_print_int) dll;
  (* expect [99; 3; 1; 2; 100] *)

  ignore (remove dll n99);
  ignore (remove dll n100);
  Printf.printf "Removed:  ";
  Format.printf "%a\n" (pp Format.pp_print_int) dll;
  (* expect [3; 1; 2] *)

  (* move_to_front demo *)
  let node_middle = Option.get (Option.bind dll.head (fun n -> n.next)) in
  move_to_front dll node_middle;
  Printf.printf "Move mid: ";
  Format.printf "%a\n" (pp Format.pp_print_int) dll;
  (* expect [1; 3; 2] *)

  (* pop demo *)
  Printf.printf "Pop front: %d\n" (Option.get (pop_front dll));
  Printf.printf "Pop back:  %d\n" (Option.get (pop_back dll));
  Printf.printf "Remaining: ";
  Format.printf "%a\n" (pp Format.pp_print_int) dll;
  Printf.printf "Length: %d\n" (length dll)
