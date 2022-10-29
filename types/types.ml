open Ctypes

module Make (S : Cstubs_structs.TYPE) = struct
  open S

  module Wl_list = struct
    type t = [`wl_list] structure
    let t : t typ = structure "wl_list"
    let prev = field t "prev" (ptr t)
    let next = field t "next" (ptr t)
    let () = seal t
  end

  module Wl_signal = struct
    type t = [`wl_signal] structure
    let t : t typ = structure "wl_signal"
    let listener_list = field t "listener_list" Wl_list.t
    let () = seal t
  end

  module Wl_listener = struct
    type t = [`wl_listener] structure
    let t : t typ = structure "wl_listener"

    type wl_notify_func_t = t ptr -> unit ptr -> unit
    let wl_notify_func_t : wl_notify_func_t typ =
      lift_typ (Foreign.funptr (ptr t @-> ptr void @-> returning void))

    let link = field t "link" Wl_list.t
    let notify = field t "notify" wl_notify_func_t
    let () = seal t
  end

  module Wl_resource = struct
    type t = [`wl_resource] structure
    let t : t typ = structure "wl_resource"
    let link = field t "link" Wl_list.t
    (* TODO *)
    let () = seal t
  end

  module Wl_output_transform = struct
    (* FIXME *)
    type t = int64
    let t : t typ = int64_t
  end

  module Wl_seat_capability = struct
    type t = Unsigned.uint64
    let t : t typ = uint64_t
    let _WL_SEAT_CAPABILITY_POINTER = constant "WL_SEAT_CAPABILITY_POINTER" uint64_t
    let _WL_SEAT_CAPABILITY_KEYBOARD = constant "WL_SEAT_CAPABILITY_KEYBOARD" uint64_t
    let _WL_SEAT_CAPABILITY_TOUCH = constant "WL_SEAT_CAPABILITY_TOUCH" uint64_t
  end

  module Wlr_allocator = struct
    type t = [`wlr_allocator] structure
    let t : t typ = structure "wlr_allocator"
  end

  module Wlr_renderer = struct
    type t = [`wlr_renderer] structure
    let t : t typ = structure "wlr_renderer"
  end

  module Wlr_surface_state = struct
    type t = [`wlr_surface_state] structure
    let t : t typ = structure "wlr_surface_state"
    let width = field t "width" int
    let height = field t "height" int
    let transform = field t "transform" Wl_output_transform.t
    (* TODO *)
    let () = seal t
  end

  module Wlr_texture = struct
    type t = [`wlr_texture] structure
    let t : t typ = structure "wlr_texture"
  end

  module Wlr_surface = struct
    type t = [`wlr_surface] structure
    let t : t typ = structure "wlr_surface"
    let current = field t "current" (ptr Wlr_surface_state.t)
    let pending = field t "pending" (ptr Wlr_surface_state.t)
    (* TODO *)
    let () = seal t
  end

  module Wlr_box = struct
    type t = [`wlr_box] structure
    let t : t typ = structure "wlr_box"
    let x = field t "x" int
    let y = field t "y" int
    let width = field t "width" int
    let height = field t "height" int
    let () = seal t
  end

  module Wlr_output_mode = struct
    type t = [`wlr_output_mode] structure
    let t : t typ = structure "wlr_output_mode"
    let width = field t "width" int32_t
    let height = field t "height" int32_t
    let refresh = field t "refresh" int32_t
    let preferred = field t "preferred" bool
    let link = field t "link" Wl_list.t
    let () = seal t
  end

  module Wlr_output = struct
    type t = [`wlr_output] structure
    let t : t typ = structure "wlr_output"

    let modes = field t "modes" Wl_list.t
    let current_mode = field t "current_mode" (ptr Wlr_output_mode.t)
    let events_destroy = field t "events.destroy" Wl_signal.t
    let events_frame = field t "events.frame" Wl_signal.t
    let transform_matrix = field t "transform_matrix" (array 16 float)

    (* TODO *)
    let () = seal t
  end

  module Wlr_output_layout = struct
    type t = [`wlr_output_layout] structure
    let t : t typ = structure "wlr_output_layout"
    let () = seal t
  end

  module Wlr_button_state = struct
    type t = Released | Pressed

    let _RELEASED = constant "WLR_BUTTON_RELEASED" int64_t
    let _PRESSED = constant "WLR_BUTTON_PRESSED" int64_t

    let t : t typ = enum "wlr_button_state" [
      Released, _RELEASED;
      Pressed, _PRESSED;
    ]
  end

  (* This is an array of unit32_t keycodes: uint32_t keycodes[] *)
  module Wlr_keycodes = struct
    type t = unit ptr
    let t : t typ = ptr void
  end

  module Wlr_key_state = struct
    type t = Released | Pressed

    let _RELEASED = constant "WL_KEYBOARD_KEY_STATE_RELEASED" int64_t
    let _PRESSED = constant "WL_KEYBOARD_KEY_STATE_PRESSED" int64_t

    let t : t typ = enum "wl_keyboard_key_state" [
      Released, _RELEASED;
      Pressed, _PRESSED;
    ]
  end

  module Wlr_keyboard_key_event = struct
    type t = [`wlr_keyboard_key_event] structure
    let t : t typ = structure "wlr_keyboard_key_event"
    let time_msec = field t "time_msec" uint32_t
    let keycode = field t "keycode" int
    let update_state = field t "update_state" bool
    let state = field t "state" Wlr_key_state.t
  end

  module Wlr_keyboard_modifier = struct
    type t = Unsigned.uint32
    let t : t typ = uint32_t

    let _WLR_MODIFIER_SHIFT = constant "WLR_MODIFIER_SHIFT" t
    let _WLR_MODIFIER_CAPS = constant "WLR_MODIFIER_CAPS" t
    let _WLR_MODIFIER_CTRL = constant "WLR_MODIFIER_CTRL" t
    let _WLR_MODIFIER_ALT = constant "WLR_MODIFIER_ALT" t
    let _WLR_MODIFIER_MOD2 = constant "WLR_MODIFIER_MOD2" t
    let _WLR_MODIFIER_MOD3 = constant "WLR_MODIFIER_MOD3" t
    let _WLR_MODIFIER_LOGO = constant "WLR_MODIFIER_LOGO" t
    let _WLR_MODIFIER_MOD5 = constant "WLR_MODIFIER_MOD5" t
  end

  module Wlr_keyboard_modifiers = struct
    type t = [`wlr_keyboard_modifier] structure
    let t : t typ = structure "wlr_keyboard_modifiers"
    let () = seal t
  end

  module Wlr_keyboard = struct
    type t = [`wlr_keyboard] structure
    let t : t typ = structure "wlr_keyboard"

    let xkb_state = field t "xkb_state" (lift_typ Xkbcommon.State.t)
    let modifiers = field t "modifiers" (ptr Wlr_keyboard_modifiers.t)
    let events_key = field t "events.key" Wl_signal.t
    let keycodes = field t "keycodes" Wlr_keycodes.t
    let num_keycodes = field t "num_keycodes" size_t
    let () = seal t
  end

  module Wlr_pointer = struct
    type t = [`wlr_pointer] structure
    let t : t typ = structure "wlr_pointer"

    let () = seal t
  end

  module Wlr_pointer_motion_event = struct
    type t = [`wlr_pointer_motion_event] structure
    let t : t typ = structure "wlr_pointer_motion_event"

    let () = seal t
  end

  module Wlr_pointer_motion_absolute_event = struct
    type t = [`wlr_pointer_motion_absolute_event] structure
    let t : t typ = structure "wlr_pointer_motion_absolute_event"

    let () = seal t
  end

  module Wlr_pointer_button_event = struct
    type t = [`wlr_pointer_button_event] structure
    let t : t typ = structure "wlr_pointer_button_event"

    let () = seal t
  end

  module Wlr_pointer_axis_event = struct
    type t = [`wlr_pointer_axis_event] structure
    let t : t typ = structure "wlr_pointer_axis_event"

    let () = seal t
  end

  module Wlr_touch = struct
    type t = [`wlr_touch] structure
    let t : t typ = structure "wlr_touch"

    let () = seal t
  end

  module Wlr_tablet_tool_type = struct
    type t =
      | Pen
      | Eraser
      | Brush
      | Pencil
      | Airbrush
      | Mouse
      | Lens
      | Totem

    let _PEN = constant "WLR_TABLET_TOOL_TYPE_PEN" int64_t
    let _ERASER = constant "WLR_TABLET_TOOL_TYPE_ERASER" int64_t
    let _BRUSH = constant "WLR_TABLET_TOOL_TYPE_BRUSH" int64_t
    let _PENCIL = constant "WLR_TABLET_TOOL_TYPE_PENCIL" int64_t
    let _AIRBRUSH = constant "WLR_TABLET_TOOL_TYPE_AIRBRUSH" int64_t
    let _MOUSE = constant "WLR_TABLET_TOOL_TYPE_MOUSE" int64_t
    let _LENS = constant "WLR_TABLET_TOOL_TYPE_LENS" int64_t
    let _TOTEM = constant "WLR_TABLET_TOOL_TYPE_TOTEM" int64_t

    let t : t typ = enum "wlr_tablet_tool_type" [
      Pen, _PEN;
      Eraser, _ERASER;
      Brush, _BRUSH;
      Pencil, _PENCIL;
      Airbrush, _AIRBRUSH;
      Mouse, _MOUSE;
      Lens, _LENS;
      Totem, _TOTEM;
    ]
end

  module Wlr_tablet = struct
    type t = [`wlr_tablet_tool] structure
    let t : t typ = structure "wlr_tablet"

    let () = seal t
  end

  module Wlr_tablet_pad = struct
    type t = [`wlr_tablet_pad] structure
    let t : t typ = structure "wlr_tablet_pad"

    let () = seal t
  end

  module Wlr_input_device_type = struct
    type t =
      | Keyboard
      | Pointer
      | Touch
      | Tablet_tool
      | Tablet_pad

    let _KEYBOARD = constant "WLR_INPUT_DEVICE_KEYBOARD" int64_t
    let _POINTER = constant "WLR_INPUT_DEVICE_POINTER" int64_t
    let _TOUCH = constant "WLR_INPUT_DEVICE_TOUCH" int64_t
    let _TABLET_TOOL = constant "WLR_INPUT_DEVICE_TABLET_TOOL" int64_t
    let _TABLET_PAD = constant "WLR_INPUT_DEVICE_TABLET_PAD" int64_t

    let t : t typ = enum "wlr_input_device_type" [
      Keyboard, _KEYBOARD;
      Pointer, _POINTER;
      Touch, _TOUCH;
      Tablet_tool, _TABLET_TOOL;
      Tablet_pad, _TABLET_PAD;
    ]
  end

  module Wlr_input_device = struct
    type t = [`wlr_output_device] structure
    let t : t typ = structure "wlr_input_device"

    let typ = field t "type" Wlr_input_device_type.t
    let vendor = field t "vendor" int
    let product = field t "product" int
    let name = field t "name" string

    (* let keyboard = field t "keyboard" (ptr Keyboard.t) *)
    (* let pointer = field t "pointer" (ptr Pointer.t) *)
    (* let touch = field t "touch" (ptr Touch.t) *)
    (* let tablet = field t "tablet" (ptr Tablet.t) *)
    (* let tablet_pad = field t "tablet_pad" (ptr Tablet_pad.t) *)

    let events_destroy = field t "events.destroy" Wl_signal.t
    let data = field t "data" (ptr void)

    (* TODO *)
    let () = seal t
  end

  module Wlr_backend = struct
    type t = [`wlr_backend] structure
    let t : t typ = structure "wlr_backend"
    let impl = field t "impl" (ptr void)
    let events_destroy = field t "events.destroy" Wl_signal.t
    let events_new_input = field t "events.new_input" Wl_signal.t
    let events_new_output = field t "events.new_output" Wl_signal.t
    let () = seal t

    type renderer_create_func_t =
      unit ptr -> int -> unit ptr -> unit ptr -> int -> Wlr_renderer.t ptr
    let renderer_create_func_t : renderer_create_func_t option typ =
      lift_typ
        (Foreign.funptr_opt
           (ptr void @-> int @-> ptr void @-> ptr void @-> int @->
            returning (ptr Wlr_renderer.t)))
  end

  module Wlr_data_device_manager = struct
    type t = [`wlr_data_device] structure
    let t : t typ = structure "wlr_data_device_manager"

    let () = seal t
  end

  module Wlr_compositor = struct
    type t = [`wlr_compositor] structure
    let t : t typ = structure "wlr_compositor"

    (* TODO *)
    let () = seal t
  end

  module Wlr_subcompositor = struct
    type t = [`wlr_subcompositor] structure
    let t : t typ = structure "wlr_subcompositor"

    (* TODO *)
    let () = seal t
  end

  (* include/wlr/types/wlr_data_device.h *)
  module Wlr_data_source = struct
    type t = [`wlr_data_source] structure
    let t : t typ = structure "wlr_data_source"
    let () = seal t
  end

  module Wlr_seat_client = struct
    type t = [`wlr_seat_client] structure
    let t : t typ = structure "wlr_seat_client"
    let () = seal t
  end

  module Wlr_seat_pointer_state = struct
    type t = [`wlr_seat_pointer_state] structure
    let t : t typ = structure "wlr_seat_pointer_state"
    let focused_client = field t "focused_client"
        (ptr Wlr_seat_client.t)
    let () = seal t
  end

  module Wlr_seat = struct
    type t = [`wlr_seat] structure
    let t : t typ = structure "wlr_seat"

    let events_request_set_cursor =
      field t "events.request_set_cursor" Wl_signal.t
    let events_request_set_selection =
      field t "events.request_set_selection" Wl_signal.t
    let pointer_state =
      field t "pointer_state" Wlr_seat_pointer_state.t
    let () = seal t
  end

  module Wlr_seat_pointer_request_set_cursor_event = struct
    type t = [`wlr_seat_pointer_request_set_cursor_event] structure
    let t : t typ = structure "wlr_seat_pointer_request_set_cursor_event"
    let seat_client = field t "seat_client" (ptr Wlr_seat_client.t)
    let surface = field t "surface" (ptr Wlr_surface.t)
    let hotspot_x = field t "hotspot_x" int
    let hotspot_y = field t "hotspot_y" int
    let () = seal t
  end

  module Wlr_seat_request_set_selection_event = struct
    type t = [`wlr_seat_request_set_selection_event] structure
    let t : t typ = structure "wlr_seat_request_set_selection_event"

    let source = field t "source" (ptr Wlr_data_source.t)
    let serial = field t "serial" uint32_t

    let () = seal t
  end

  (* include/wlr/types/wlr_xdg_shell.h *)
  module Wlr_xdg_surface_role = struct
    type t =
      | None
      | Toplevel
      | Popup

    let _WLR_XDG_SURFACE_ROLE_NONE = constant "WLR_XDG_SURFACE_ROLE_NONE" int64_t
    let _WLR_XDG_SURFACE_ROLE_TOPLEVEL = constant "WLR_XDG_SURFACE_ROLE_TOPLEVEL" int64_t
    let _WLR_XDG_SURFACE_ROLE_POPUP = constant "WLR_XDG_SURFACE_ROLE_POPUP" int64_t

    let t : t typ = enum "wlr_xdg_surface_role" [
      None, _WLR_XDG_SURFACE_ROLE_NONE;
      Toplevel, _WLR_XDG_SURFACE_ROLE_TOPLEVEL;
      Popup, _WLR_XDG_SURFACE_ROLE_POPUP;
    ]
  end


  (* include/wlr/types/wlr_xdg_shell.h *)
  module Wlr_xdg_toplevel_state = struct
    type t = [`wlr_xdg_toplevel_state] structure
    let t : t typ = structure "wlr_xdg_toplevel_state"

    let maximized = field t "maximized" bool
    let fullscreen = field t "fullscreen" bool
    let resizing = field t "resizing" bool
    let activated = field t "activated" bool

    (* enum wlr_edges *)
    let tiled = field t "tiled" uint32_t

    let width = field t "width" uint32_t
    let height = field t "height" uint32_t
    let max_width = field t "max_width" uint32_t
    let max_height = field t "max_height" uint32_t
    let () = seal t
  end

  (* include/wlr/types/wlr_xdg_shell.h *)
  module Wlr_xdg_toplevel_configure = struct
    type t = [`wlr_xdg_toplevel_configure] structure
    let t : t typ = structure "wlr_xdg_toplevel_configure"

    (* enum wlr_xdg_toplevel_configure_field *)
    let fields = field t "fields" uint32_t

    let maximized = field t "maximized" bool
    let fullscreen = field t "fullscreen" bool
    let resizing = field t "resizing" bool
    let activated = field t "activated" bool

    (* enum wlr_edges *)
    let tiled = field t "tiled" uint32_t

    let width = field t "width" uint32_t
    let height = field t "height" uint32_t

    let bounds_width = field t "bounds.width" uint32_t
    let bounds_height = field t "bounds.height" uint32_t

    (* enum wlr_xdg_toplevel_wm_capabilities *)
    let wm_capabilities = field t "wm_capabilities" uint32_t 

    let () = seal t
  end

  (* include/wlr/types/wlr_xdg_shell.h *)
  module Wlr_xdg_toplevel_requested = struct
    type t = [`wlr_xdg_toplevel_requested] structure
    let t : t typ = structure "wlr_xdg_toplevel_requested"

    let maximized = field t "maximized" bool
    let minimized = field t "minimized" bool
    let fullscreen = field t "fullscreen" bool

    let fullscreen_output = field t "fullscreen_output" Wlr_output.t
    let fullscreen_output_destroy = field t "fullscreen_output_destroy" Wl_listener.t
  end

  (* include/wlr/types/wlr_xdg_shell.h *)
  module Wlr_xdg_popup = struct
    type t = [`wlr_xdg_popup] structure
    let t : t typ = structure "wlr_xdg_popup"

    let parent = field t "parent" (ptr Wlr_surface.t)
    let seat = field t "seat" (ptr Wlr_seat.t)
    let committed = field t "committed" bool
  end

  (* include/wlr/types/wlr_xdg_shell.h *)
  module Wlr_xdg_toplevel = struct
    type t = [`wlr_xdg_toplevel] structure
    let t : t typ = structure "wlr_xdg_toplevel"

    let resource = field t "resource" (ptr Wl_resource.t)

    (* FIXME: Circular. *)
    (* let base = field t "base" (ptr Xdg_surface.t) *)

    let added = field t "added" bool

    let parent = field t "parent" (ptr t)
    let parent_unmap = field t "parent_unmap" Wl_listener.t

    let current = field t "current" Wlr_xdg_toplevel_state.t
    let pending = field t "pending" Wlr_xdg_toplevel_state.t


    let scheduled = field t "scheduled" Wlr_xdg_toplevel_configure.t

    let requested = field t "requested" Wlr_xdg_toplevel_requested.t

    let title = field t "title" string
    let app_id = field t "app_id" string

    let request_maximize = field t "events.request_maximize" Wl_signal.t
    let request_fullscreen = field t "events.request_fullscreen" Wl_signal.t

    let request_minimize = field t "events.request_minimize" Wl_signal.t
    let request_move = field t "events.request_move" Wl_signal.t
    let request_resize = field t "events.request_resize" Wl_signal.t
    let request_show_window_menu = field t "events.request_show_window_menu" Wl_signal.t
    let set_parent = field t "events.set_parent" Wl_signal.t
    let set_title = field t "events.set_title" Wl_signal.t
    let set_app_id = field t "events.set_app_id" Wl_signal.t

    let () = seal t
  end

  (* include/wlr/types/wlr_xdg_shell.h *)
  module Wlr_xdg_surface = struct
    type t = [`wlr_xdg_surface] structure
    let t : t typ = structure "wlr_xdg_surface"

    let resource = field t "resource" (ptr Wl_resource.t)
    let surface = field t "surface" (ptr Wlr_surface.t)
    let role = field t "role" Wlr_xdg_surface_role.t
    let toplevel = field t "toplevel" (ptr Wlr_xdg_toplevel.t)
    let popup = field t "popup" (ptr Wlr_xdg_popup.t)

    let events_destroy = field t "events.destroy" Wl_signal.t
    let events_ping_timeout = field t "events.ping_timeout" Wl_signal.t
    let events_new_popup = field t "events.new_popup" Wl_signal.t
    let events_map = field t "events.map" Wl_signal.t
    let events_unmap = field t "events.unmap" Wl_signal.t
    let events_configure = field t "events.configure" Wl_signal.t
    let events_ack_configure = field t "events.ack_configure" Wl_signal.t

    let () = seal t
  end

  (* include/wlr/types/wlr_xdg_shell.h *)
  module Wlr_xdg_shell = struct
    type t = [`wlr_xdg_shell] structure
    let t : t typ = structure "wlr_xdg_shell"

    let events_new_surface = field t "events.new_surface" Wl_signal.t
    let events_destroy = field t "events.destroy" Wl_signal.t
    let () = seal t
  end

  module Wlr_cursor = struct
    type t = [`wlr_cursor] structure
    let t : t typ = structure "wlr_cursor"

    let events_motion = field t "events.motion" Wl_signal.t
    let events_motion_absolute = field t "events.motion_absolute" Wl_signal.t
    let events_button = field t "events.button" Wl_signal.t
    let events_axis = field t "events.axis" Wl_signal.t
    let events_frame = field t "events.frame" Wl_signal.t
    let () = seal t
  end

  module Wlr_xcursor_manager = struct
    type t = [`wlr_xcursor_manager] structure
    let t : t typ = structure "wlr_xcursor_manager"
    let () = seal t
  end

  module Wlr_scene_node_type = struct
    type t =
      | Tree
      | Rect
      | Buffer

    let _WLR_SCENE_NODE_TREE = constant "WLR_SCENE_NODE_TREE" int64_t
    let _WLR_SCENE_NODE_RECT = constant "WLR_SCENE_NODE_RECT" int64_t
    let _WLR_SCENE_NODE_BUFFER = constant "WLR_SCENE_NODE_BUFFER" int64_t

    let t : t typ = enum "wlr_scene_node_type" [
      Tree, _WLR_SCENE_NODE_TREE;
      Rect, _WLR_SCENE_NODE_RECT;
      Buffer, _WLR_SCENE_NODE_BUFFER;
    ]
  end

  (* These are used as recursively dependent types below. *)
  type wlr_scene_node = [`wlr_scene_node] structure
  type wlr_scene_tree = [`wlr_scene_tree] structure

  let wlr_scene_node : wlr_scene_node typ = structure "wlr_scene_node"
  let wlr_scene_tree : wlr_scene_tree typ = structure "wlr_scene_tree"

  module Wlr_scene_node = struct
    type t = wlr_scene_node
    let t = wlr_scene_node

    let type_ = field t "type" Wlr_scene_node_type.t
    let parent = field t "parent" (ptr wlr_scene_tree)

    (* wlr_scene_tree.children *)
    let link = field t "link" Wl_list.t

    let enabled = field t "enabled" bool
    let x = field t "x" int
    let y = field t "y" int

    let events_destroy = field t "events.destroy" Wl_signal.t

    let data = field t "data" (ptr void)

    (* struct wlr_addon_set addons; *)

    let () = seal t
  end

  module Wlr_scene_tree = struct
    type t = wlr_scene_tree
    let t = wlr_scene_tree

    let node = field t "node" Wlr_scene_node.t

    (* wlr_scene_node.link *)
    let children = field t "children" Wl_list.t

    let () = seal t
  end

  module Wlr_scene = struct
    type t = [`wlr_scene] structure

    let t : t typ = structure "wlr_scene"
    let tree = field t "tree" Wlr_scene_tree.t
    let outputs = field t "outputs" Wl_list.t

    (* let presentation = field t "presentation" Presentation.t *)

    let () = seal t
  end

  module Wlr_log = struct
    type importance =
      | Silent
      | Error
      | Info
      | Debug

    let _WLR_SILENT = constant "WLR_SILENT" int64_t
    let _WLR_ERROR = constant "WLR_ERROR" int64_t
    let _WLR_INFO = constant "WLR_INFO" int64_t
    let _WLR_DEBUG = constant "WLR_DEBUG" int64_t
    let _WLR_LOG_IMPORTANCE_LAST = constant "WLR_LOG_IMPORTANCE_LAST" int64_t

    let importance : importance typ =
      enum "wlr_log_importance" [
        Silent, _WLR_SILENT;
        Error, _WLR_ERROR;
        Info, _WLR_INFO;
        Debug, _WLR_DEBUG;
      ]
  end
end
