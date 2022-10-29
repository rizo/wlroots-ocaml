open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_xdg_surface.t ptr
let t = ptr Types.Wlr_xdg_surface.t
include Ptr

type role = Types.Wlr_xdg_surface_role.t = None | Toplevel | Popup

let role = getfield Types.Wlr_xdg_surface.role

let toplevel = getfield Types.Wlr_xdg_surface.toplevel
let popup = getfield Types.Wlr_xdg_surface.popup

let from_surface (surface : Surface.t) : t option =
  (* This is not exactly a verbatim binding but it is safer *)
  (* Worth it? *)
  if Bindings.wlr_surface_is_xdg_surface surface
  then
    (* assert is called so this might blow up *)
    Some (Bindings.wlr_xdg_surface_from_wlr_surface surface)
  else None
