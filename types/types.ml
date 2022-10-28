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
    type t = [`wl_signal] Ctypes.structure
    let t : t typ = structure "wl_signal"
    let listener_list = field t "listener_list" Wl_list.t
    let () = seal t
  end

  module Wl_listener = struct
    type t = [`wl_listener] Ctypes.structure
    let t : t typ = structure "wl_listener"

    type wl_notify_func_t = t ptr -> unit ptr -> unit
    let wl_notify_func_t : wl_notify_func_t typ =
      lift_typ (Foreign.funptr (ptr t @-> ptr void @-> returning void))

    let link = field t "link" Wl_list.t
    let notify = field t "notify" wl_notify_func_t
    let () = seal t
  end

  module Wl_resource = struct
    type t = [`wl_resource] Ctypes.structure
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

  module Allocator = struct
    type t = [`allocator] Ctypes.structure
    let t : t typ = structure "wlr_allocator"
  end

  module Renderer = struct
    type t = [`renderer] Ctypes.structure
    let t : t typ = structure "wlr_renderer"
  end

  module Surface_state = struct
    type t = [`surface_state] Ctypes.structure
    let t : t typ = structure "wlr_surface_state"
    let width = field t "width" int
    let height = field t "height" int
    let transform = field t "transform" Wl_output_transform.t
    (* TODO *)
    let () = seal t
  end

  module Texture = struct
    type t = [`texture] Ctypes.structure
    let t : t typ = structure "wlr_texture"
  end

  module Surface = struct
    type t = [`surface] Ctypes.structure
    let t : t typ = structure "wlr_surface"
    let current = field t "current" (ptr Surface_state.t)
    let pending = field t "pending" (ptr Surface_state.t)
    (* TODO *)
    let () = seal t
  end

  module Box = struct
    type t = [`box] Ctypes.structure
    let t : t typ = structure "wlr_box"
    let x = field t "x" int
    let y = field t "y" int
    let width = field t "width" int
    let height = field t "height" int
    let () = seal t
  end

  module Output_mode = struct
    type t = [`output_mode] Ctypes.structure
    let t : t typ = structure "wlr_output_mode"
    let width = field t "width" int32_t
    let height = field t "height" int32_t
    let refresh = field t "refresh" int32_t
    let preferred = field t "preferred" bool
    let link = field t "link" Wl_list.t
    let () = seal t
  end

  module Output = struct
    type t = [`output] Ctypes.structure
    let t : t typ = structure "wlr_output"

    let modes = field t "modes" Wl_list.t
    let current_mode = field t "current_mode" (ptr Output_mode.t)
    let events_destroy = field t "events.destroy" Wl_signal.t
    let events_frame = field t "events.frame" Wl_signal.t
    let transform_matrix = field t "transform_matrix" (array 16 float)

    (* TODO *)
    let () = seal t
  end

  module Output_layout = struct
    type t = [`output_layout] Ctypes.structure
    let t : t typ = structure "wlr_output_layout"
    let () = seal t
  end

  module Button_state = struct
    type t = Released | Pressed

    let _RELEASED = constant "WLR_BUTTON_RELEASED" int64_t
    let _PRESSED = constant "WLR_BUTTON_PRESSED" int64_t

    let t : t typ = enum "wlr_button_state" [
      Released, _RELEASED;
      Pressed, _PRESSED;
    ]
  end

  (* This is an array of unit32_t keycodes: uint32_t keycodes[] *)
  module Keycodes = struct
    type t = unit ptr
    let t : t typ = ptr void
  end

  module Key_state = struct
    type t = Released | Pressed

    let _RELEASED = constant "WL_KEYBOARD_KEY_STATE_RELEASED" int64_t
    let _PRESSED = constant "WL_KEYBOARD_KEY_STATE_PRESSED" int64_t

    let t : t typ = enum "wl_keyboard_key_state" [
      Released, _RELEASED;
      Pressed, _PRESSED;
    ]
  end

  module Keyboard_key_event = struct
    type t = [`keyboard_key_event] Ctypes.structure
    let t : t typ = structure "wlr_keyboard_key_event"
    let time_msec = field t "time_msec" uint32_t
    let keycode = field t "keycode" int
    let update_state = field t "update_state" bool
    let state = field t "state" Key_state.t
  end

  module Keyboard_modifier = struct
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

  module Keyboard_modifiers = struct
    type t = [`keyboard_modifier] Ctypes.structure
    let t : t typ = structure "wlr_keyboard_modifiers"
    let () = seal t
  end

  module Keyboard = struct
    type t = [`keyboard] Ctypes.structure
    let t : t typ = structure "wlr_keyboard"

    let xkb_state = field t "xkb_state" (lift_typ Xkbcommon.State.t)
    let modifiers = field t "modifiers" (ptr Keyboard_modifiers.t)
    let events_key = field t "events.key" Wl_signal.t
    let keycodes = field t "keycodes" Keycodes.t
    let num_keycodes = field t "num_keycodes" size_t
    let () = seal t
  end

  module Pointer = struct
    type t = [`pointer] Ctypes.structure
    let t : t typ = structure "wlr_pointer"

    let () = seal t
  end

  module Pointer_motion_event = struct
    type t = [`pointer_motion_event] Ctypes.structure
    let t : t typ = structure "wlr_pointer_motion_event"

    let () = seal t
  end

  module Pointer_motion_absolute_event = struct
    type t = [`pointer_motion_absolute_event] Ctypes.structure
    let t : t typ = structure "wlr_pointer_motion_absolute_event"

    let () = seal t
  end

  module Pointer_button_event = struct
    type t = [`pointer_button_event] Ctypes.structure
    let t : t typ = structure "wlr_pointer_button_event"

    let () = seal t
  end

  module Pointer_axis_event = struct
    type t = [`pointer_axis_event] Ctypes.structure
    let t : t typ = structure "wlr_pointer_axis_event"

    let () = seal t
  end

  module Touch = struct
    type t = [`touch] Ctypes.structure
    let t : t typ = structure "wlr_touch"

    let () = seal t
  end

module Tablet_tool_type = struct
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

  module Tablet = struct
    type t = [`tablet_tool] Ctypes.structure
    let t : t typ = structure "wlr_tablet"

    let () = seal t
  end

  module Tablet_pad = struct
    type t = [`tablet_pad] Ctypes.structure
    let t : t typ = structure "wlr_tablet_pad"

    let () = seal t
  end

  module Input_device = struct
    type t = [`output_device] Ctypes.structure
    let t : t typ = structure "wlr_input_device"

    module Type = struct
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

    let typ = field t "type" Type.t
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

  module Backend = struct
    type t = [`backend] Ctypes.structure
    let t : t typ = structure "wlr_backend"
    let impl = field t "impl" (ptr void)
    let events_destroy = field t "events.destroy" Wl_signal.t
    let events_new_input = field t "events.new_input" Wl_signal.t
    let events_new_output = field t "events.new_output" Wl_signal.t
    let () = seal t

    type renderer_create_func_t =
      unit ptr -> int -> unit ptr -> unit ptr -> int -> Renderer.t ptr
    let renderer_create_func_t : renderer_create_func_t option typ =
      lift_typ
        (Foreign.funptr_opt
           (ptr void @-> int @-> ptr void @-> ptr void @-> int @->
            returning (ptr Renderer.t)))
  end

  module Data_device_manager = struct
    type t = [`data_device] Ctypes.structure
    let t : t typ = structure "wlr_data_device_manager"

    let () = seal t
  end

  module Compositor = struct
    type t = [`compositor] Ctypes.structure
    let t : t typ = structure "wlr_compositor"

    (* TODO *)
    let () = seal t
  end

  module Xdg_surface = struct
    type t = [`xdg_surface] Ctypes.structure
    let t : t typ = structure "wlr_xdg_surface"

    let () = seal t
  end

  (* include/wlr/types/wlr_xdg_shell.h *)
  module Xdg_toplevel_state = struct
    type t = [`xdg_toplevel_state] Ctypes.structure
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
  module Xdg_toplevel_configure = struct
    type t = [`xdg_toplevel_configure] Ctypes.structure
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
  module Xdg_toplevel_requested = struct
    type t = [`xdg_toplevel_requested] Ctypes.structure
    let t : t typ = structure "wlr_xdg_toplevel_requested"

    let maximized = field t "maximized" bool
    let minimized = field t "minimized" bool
    let fullscreen = field t "fullscreen" bool

    let fullscreen_output = field t "fullscreen_output" Output.t
    let fullscreen_output_destroy = field t "fullscreen_output_destroy" Wl_listener.t
  end

  (* include/wlr/types/wlr_xdg_shell.h *)
  module Xdg_toplevel = struct
    type t = [`xdg_toplevel] Ctypes.structure
    let t : t typ = structure "wlr_xdg_toplevel"

    let resource = field t "resource" (ptr Wl_resource.t)
    let base = field t "base" (ptr Xdg_surface.t)
    let added = field t "added" bool

    let parent = field t "parent" (ptr t)
    let parent_unmap = field t "parent_unmap" Wl_listener.t

    let current = field t "current" Xdg_toplevel_state.t
    let pending = field t "pending" Xdg_toplevel_state.t


    let scheduled = field t "scheduled" Xdg_toplevel_configure.t

    let requested = field t "requested" Xdg_toplevel_requested.t

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

  module Xdg_shell = struct
    type t = [`xdg_shell] Ctypes.structure
    let t : t typ = structure "wlr_xdg_shell"

    let events_new_surface = field t "events.new_surface" Wl_signal.t
    let events_destroy = field t "events.destroy" Wl_signal.t
    let () = seal t
  end

  module Cursor = struct
    type t = [`cursor] Ctypes.structure
    let t : t typ = structure "wlr_cursor"

    let events_motion = field t "events.motion" Wl_signal.t
    let events_motion_absolute = field t "events.motion_absolute" Wl_signal.t
    let events_button = field t "events.button" Wl_signal.t
    let events_axis = field t "events.axis" Wl_signal.t
    let events_frame = field t "events.frame" Wl_signal.t
    let () = seal t
  end

  module Xcursor_manager = struct
    type t = [`xcursor_manager] Ctypes.structure
    let t : t typ = structure "wlr_xcursor_manager"
    let () = seal t
  end

  module Seat_client = struct
    type t = [`seat_client] Ctypes.structure
    let t : t typ = structure "wlr_seat_client"
    let () = seal t
  end

  module Seat_pointer_state = struct
    type t = [`seat_pointer_state] Ctypes.structure
    let t : t typ = structure "wlr_seat_pointer_state"
    let focused_client = field t "focused_client"
        (ptr Seat_client.t)
    let () = seal t
  end

  module Seat = struct
    type t = [`seat] Ctypes.structure
    let t : t typ = structure "wlr_seat"

    let events_request_set_cursor =
      field t "events.request_set_cursor" Wl_signal.t
    let pointer_state =
      field t "pointer_state" Seat_pointer_state.t
    let () = seal t
  end

  module Seat_pointer_request_set_cursor_event = struct
    type t = [`seat_pointer_request_set_cursor_event] Ctypes.structure
    let t : t typ = structure "wlr_seat_pointer_request_set_cursor_event"
    let seat_client = field t "seat_client" (ptr Seat_client.t)
    let surface = field t "surface" (ptr Surface.t)
    let hotspot_x = field t "hotspot_x" int
    let hotspot_y = field t "hotspot_y" int
    let () = seal t
  end


  module Scene = struct
    module Node_type = struct
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
    type node = [`scene_node] Ctypes.structure
    type tree = [`scene_tree] Ctypes.structure
    let node : node typ = structure "wlr_scene_node"
    let tree : tree typ = structure "wlr_scene_tree"

    module Node = struct
      type t = node
      let t = node

      let type_ = field t "type" Node_type.t
      let parent = field t "parent" (ptr tree)

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

    module Tree = struct
      type t = tree
      let t = tree

      let node = field t "node" Node.t

      (* wlr_scene_node.link *)
      let children = field t "children" Wl_list.t

      let () = seal t
    end


    type t = [`scene] Ctypes.structure

    let t : t typ = structure "wlr_scene"
    let tree = field t "tree" Tree.t
    let outputs = field t "outputs" Wl_list.t

    (* let presentation = field t "presentation" Presentation.t *)

    let () = seal t
  end

  module Log = struct
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
