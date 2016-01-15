(************************************************************
 *
 *                       IMITATOR
 * 
 * Laboratoire Spécification et Vérification (ENS Cachan & CNRS, France)
 * LIPN, Université Paris 13, Sorbonne Paris Cité (France)
 * 
 * Module description: Description of the symbolic states and of the reachability graph
 * 
 * File contributors : Étienne André
 * Created           : 2009/12/08
 * Last modified     : 2016/01/15
 *
 ************************************************************)


(************************************************************)
(* Modules *)
(************************************************************)
open Automaton
open AbstractModel


(************************************************************)
(** Reachable states *)
(************************************************************)
type state_index = int

(** State: location and constraint *)
(*** TODO: hide this definition, and use (at least) structure or functions ***)
type state = Location.global_location * LinearConstraint.px_linear_constraint

type abstract_state = Location.global_location_index * LinearConstraint.px_linear_constraint


(************************************************************)
(** Graph structure *)
(************************************************************)
type state_space


(************************************************************)
(** Graph creation *)
(************************************************************)

(** Create a fresh graph *)
val make : int -> state_space


(************************************************************)
(** Interrogation on a graph *)
(************************************************************)

(** Return the number of generated states (not necessarily present in the graph) *)
val get_nb_gen_states : state_space -> int

(** Return the number of states in a graph *)
val nb_states : state_space -> int

(** Return the number of transitions in a graph *)
val nb_transitions : state_space -> int

(** Return the global_location corresponding to a location_index *)
val get_location : state_space -> Location.global_location_index -> Location.global_location

(** Return the state of a state_index *)
val get_state : state_space -> state_index -> state

(** Return the index of the initial state, or raise Not_found if not defined *)
val get_initial_state_index : state_space -> state_index

(** Return the table of transitions *)
val get_transitions : state_space -> ((state_index * action_index), state_index) Hashtbl.t

(** Return the list of all state indexes *)
val all_state_indexes : state_space -> state_index list


(*** WARNING: big memory, here! Why not perform intersection on the fly? *)

(** Return the list of all constraints on the parameters associated to the states of a graph *)
val all_p_constraints : state_space -> LinearConstraint.p_linear_constraint list

(** Returns the intersection of all parameter constraints, thereby destroying all constraints *)
(* val compute_k0_destructive : abstract_model -> state_space -> LinearConstraint.linear_constraint *)

(** Check if two states are equal *)
val states_equal: state -> state -> bool

(** Check dynamically if two states are equal, i.e., if the first one + constraint equals second one + constraint *)
val states_equal_dyn: state -> state -> LinearConstraint.px_linear_constraint -> bool

(*(** Test if a state exists satisfying predicate s *)
val exists_state: (state -> bool) -> state_space -> bool

(** test if all states satisfy predicate s *)
val forall_state: (state -> bool) -> state_space -> bool*)

(** Find all "last" states on finite or infinite runs *)
val last_states: abstract_model -> state_space -> state_index list 

(** Check if bad states are reached *)
(* val is_bad: abstract_model -> state_space -> bool *)


(************************************************************)
(** Actions on a graph *)
(************************************************************)

(** Increment the number of generated states (even though not member of the graph) *)
val increment_nb_gen_states : state_space -> unit

(** Add a state to a graph: return (state_index, added), where state_index is the index of the state, and 'added' is false if the state was already in the graph, true otherwise *)
val add_state : state_space -> state -> (state_index * bool)

(**Add a state to a graph dynamically**)
(* val add_state_dyn : AbstractModel.abstract_model -> state_space -> state -> LinearConstraint.linear_constraint -> (state_index * bool) *)

(** Add a transition to the graph *)
val add_transition : state_space -> (state_index * action_index * state_index) -> unit

(** Add a p_inequality to all the states of the graph *)
(*** NOTE: it is assumed that the p_constraint does not render some states inconsistent! ***)
val add_p_constraint_to_states : state_space -> LinearConstraint.p_linear_constraint -> unit


(** Replace the constraint of a state in a graph by another one (the constraint is copied to avoid side-effects later) *)
(* val replace_constraint : state_space -> LinearConstraint.linear_constraint -> state_index -> unit *)

(** Merge two states by replacing the second one by the first one, in the whole graph structure (lists of states, and transitions) *)
(* val merge_2_states : state_space -> state_index -> state_index -> unit *)

(* Try to merge new states with existing ones. Returns updated list of new states (ULRICH) *)
val merge : state_space -> state_index list -> state_index list

(** Empties the hash table giving the set of states for a given location; optimization for the jobshop example, where one is not interested in comparing  a state of iteration n with states of iterations < n *)
val empty_states_for_comparison : state_space -> unit

(** Iterate over the reachable states (with possible side effects) *)
val iterate_on_states : (state_index -> abstract_state -> unit) -> state_space -> unit


(************************************************************)
(** Interrogation on one state *)
(************************************************************)

(*** NOTE: should NOT be defined in this module! But rather in some (yet to be created...) State.ml ***)

val match_unreachable_global_locations : unreachable_global_location list -> Location.global_location -> bool


(************************************************************)
(** Misc: tile natures *)
(************************************************************)
val string_of_tile_nature : AbstractModel.tile_nature -> string


(************************************************************)
(** Debug and performances *)
(************************************************************)
(** Get statistics on number of comparisons *)
val get_statistics : unit -> string

(** Get statistics on states *)
val get_statistics_states : state_space -> string
