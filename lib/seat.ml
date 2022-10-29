open Ctypes
open Wlroots_common.Utils

module Bindings = Wlroots_ffi_f.Ffi.Make (Generated_ffi)
module Types = Wlroots_ffi_f.Ffi.Types

type t = Types.Wlr_seat.t ptr
include Ptr

module Pointer_request_set_cursor_event = struct
  type t = Types.Wlr_seat_pointer_request_set_cursor_event.t ptr
  let t = ptr Types.Wlr_seat_pointer_request_set_cursor_event.t
  include Ptr

  let seat_client (ev: t) =
    ev |->> Types.Wlr_seat_pointer_request_set_cursor_event.seat_client
  let surface ev =
    ev |->> Types.Wlr_seat_pointer_request_set_cursor_event.surface
  let hotspot_x ev =
    ev |->> Types.Wlr_seat_pointer_request_set_cursor_event.hotspot_x
  let hotspot_y ev =
    ev |->> Types.Wlr_seat_pointer_request_set_cursor_event.hotspot_y
end

module Request_set_selection_event = struct
  type t = Types.Wlr_seat_request_set_selection_event.t ptr
  let t = ptr Types.Wlr_seat_request_set_selection_event.t
  include Ptr
end

module Client = struct
  type t = Types.Wlr_seat_client.t ptr
  let t = ptr Types.Wlr_seat_client.t
  include Ptr
end

module Pointer_state = struct
  type t = Types.Wlr_seat_pointer_state.t ptr
  let t = ptr Types.Wlr_seat_pointer_state.t
  include Ptr

  let focused_client (st: t) =
    st |->> Types.Wlr_seat_pointer_state.focused_client
end

let pointer_state seat = seat |-> Types.Wlr_seat.pointer_state

let create = Bindings.wlr_seat_create

let signal_request_set_cursor (seat: t) : _ Wl.Signal.t = {
  c = seat |-> Types.Wlr_seat.events_request_set_cursor;
  typ = Pointer_request_set_cursor_event.t
}

let signal_request_set_selection (seat: t) : _ Wl.Signal.t = {
  c = seat |-> Types.Wlr_seat.events_request_set_selection;
  typ = Request_set_selection_event.t
}

let set_capabilities seat caps =
  Bindings.wlr_seat_set_capabilities
    seat (coerce Wl.Seat_capability.t uint64_t caps)
