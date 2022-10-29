open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_xdg_shell.t ptr
let t = ptr Types.Wlr_xdg_shell.t
include Ptr

let create = Bindings.wlr_xdg_shell_create

let signal_new_surface (shell : t) : Xdg_surface.t Wl.Signal.t = {
  c = shell |-> Types.Wlr_xdg_shell.events_new_surface;
  typ = Xdg_surface.t;
}
