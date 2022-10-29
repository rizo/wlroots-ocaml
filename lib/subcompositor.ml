open Ctypes
open! Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Subcompositor.t ptr
include Ptr

let create display =
  Bindings.wlr_subcompositor_create display
