open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_keyboard.t ptr
include Ptr

type key_state = Types.Wlr_key_state.t = Released | Pressed

module Event_key = struct
  type t = Types.Wlr_keyboard_key_event.t ptr
  include Ptr

  let time_msec = getfield Types.Wlr_keyboard_key_event.time_msec
  let keycode = getfield Types.Wlr_keyboard_key_event.keycode
  let update_state = getfield Types.Wlr_keyboard_key_event.update_state
  let state = getfield Types.Wlr_keyboard_key_event.state
end

let xkb_state = getfield Types.Wlr_keyboard.xkb_state

let signal_key (keyboard : t) : Event_key.t Wl.Signal.t = {
  c = keyboard |-> Types.Wlr_keyboard.events_key;
  typ = ptr Types.Wlr_keyboard_key_event.t;
}

let set_keymap = Bindings.wlr_keyboard_set_keymap
