open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_input_device.t ptr
include Ptr

let signal_destroy (input : t) : t Wl.Signal.t = {
  c = input |-> Types.Wlr_input_device.events_destroy;
  typ = ptr Types.Wlr_input_device.t;
}

type typ =
  | Keyboard of Keyboard.t
  | Pointer of Pointer.t
  | Touch of Touch.t
  | Tablet of Tablet_tool.t (* FIXME? *)
  | Tablet_pad of Tablet_pad.t

let typ (input: t): typ =
  let data = input |->> Types.Wlr_input_device.data in
  match input |->> Types.Wlr_input_device.typ with
  | Types.Wlr_input_device_type.Keyboard ->
    let keyboard = Bindings.wlr_keyboard_from_input_device input in
    Keyboard keyboard
  | Types.Wlr_input_device_type.Pointer ->
    let pointer = coerce (ptr void) (ptr Types.Wlr_pointer.t) data in
    Pointer pointer
  | Types.Wlr_input_device_type.Touch ->
    let touch = coerce (ptr void) (ptr Types.Wlr_touch.t) data in
    Touch touch
  | Types.Wlr_input_device_type.Tablet_tool ->
    let tablet = coerce (ptr void) (ptr Types.Wlr_tablet.t) data in
    Tablet tablet
  | Types.Wlr_input_device_type.Tablet_pad ->
    let tablet_pad = coerce (ptr void) (ptr Types.Wlr_tablet_pad.t) data in
    Tablet_pad tablet_pad

let vendor (input: t): int =
  input |->> Types.Wlr_input_device.vendor

let product (input: t): int =
  input |->> Types.Wlr_input_device.product

let name (input: t): string =
  input |->> Types.Wlr_input_device.name
