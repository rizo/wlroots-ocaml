open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = { x : int; y : int; width : int; height : int }
include Poly

let of_c (c_box : Types.Wlr_box.t ptr) =
  { x = c_box |->> Types.Wlr_box.x;
    y = c_box |->> Types.Wlr_box.y;
    width = c_box |->> Types.Wlr_box.width;
    height = c_box |->> Types.Wlr_box.height; }

let to_c { x; y; width; height } : Types.Wlr_box.t ptr =
  let c_box = make Types.Wlr_box.t in
  setf c_box Types.Wlr_box.x x;
  setf c_box Types.Wlr_box.y y;
  setf c_box Types.Wlr_box.width width;
  setf c_box Types.Wlr_box.height height;
  addr c_box
