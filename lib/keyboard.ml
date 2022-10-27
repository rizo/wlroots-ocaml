open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Keyboard.t ptr
include Ptr

type key_state = Types.Key_state.t = Released | Pressed

module Event_key = struct
  type t = Types.Keyboard_key_event.t ptr
  include Ptr

  let time_msec = getfield Types.Keyboard_key_event.time_msec
  let keycode = getfield Types.Keyboard_key_event.keycode
  let update_state = getfield Types.Keyboard_key_event.update_state
  let state = getfield Types.Keyboard_key_event.state
end

let xkb_state = getfield Types.Keyboard.xkb_state

let signal_key (keyboard : t) : Event_key.t Wl.Signal.t = {
  c = keyboard |-> Types.Keyboard.events_key;
  typ = ptr Types.Keyboard_key_event.t;
}

let set_keymap = Bindings.wlr_keyboard_set_keymap
