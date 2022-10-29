open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_pointer.t ptr
include Ptr

module Motion_event = struct
  type t = Types.Wlr_pointer_motion_event.t ptr
  let t = ptr Types.Wlr_pointer_motion_event.t
  include Ptr
end

module Motion_absolute_event = struct
  type t = Types.Wlr_pointer_motion_absolute_event.t ptr
  let t = ptr Types.Wlr_pointer_motion_absolute_event.t
  include Ptr
end

module Button_event = struct
  type t = Types.Wlr_pointer_button_event.t ptr
  let t = ptr Types.Wlr_pointer_button_event.t
  include Ptr
end

module Axis_event = struct
  type t = Types.Wlr_pointer_axis_event.t ptr
  let t = ptr Types.Wlr_pointer_axis_event.t
  include Ptr
end
