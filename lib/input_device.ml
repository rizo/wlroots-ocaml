open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Input_device.t ptr
include Ptr

let signal_destroy (input : t) : t Wl.Signal.t = {
  c = input |-> Types.Input_device.events_destroy;
  typ = ptr Types.Input_device.t;
}

type typ =
  | Keyboard of Keyboard.t
  | Pointer of Pointer.t
  | Touch of Touch.t
  | Tablet of Tablet_tool.t (* FIXME? *)
  | Tablet_pad of Tablet_pad.t

let typ (input: t): typ =
  let data = input |->> Types.Input_device.data in
  match input |->> Types.Input_device.typ with
  | Types.Input_device.Type.Keyboard ->
    let keyboard = coerce (ptr void) (ptr Types.Keyboard.t) data in
    Keyboard keyboard
  | Types.Input_device.Type.Pointer ->
    let pointer = coerce (ptr void) (ptr Types.Pointer.t) data in
    Pointer pointer
  | Types.Input_device.Type.Touch ->
    let touch = coerce (ptr void) (ptr Types.Touch.t) data in
    Touch touch
  | Types.Input_device.Type.Tablet_tool ->
    let tablet = coerce (ptr void) (ptr Types.Tablet.t) data in
    Tablet tablet
  | Types.Input_device.Type.Tablet_pad ->
    let tablet_pad = coerce (ptr void) (ptr Types.Tablet_pad.t) data in
    Tablet_pad tablet_pad

let vendor (input: t): int =
  input |->> Types.Input_device.vendor

let product (input: t): int =
  input |->> Types.Input_device.product

let name (input: t): string =
  input |->> Types.Input_device.name
