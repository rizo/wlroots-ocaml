module Wl =Wlroots.Wl
module Wlr = Wlroots

type cursor_mode =
  | Cursor_passthrough
  | Cursor_move
	| Cursor_resize

type tinywl_output = {
	(* struct wl_list link; *)
	(* struct tinywl_server *server; *)
	(* struct wlr_output *wlr_output; *)
  wlr_output : Wlr.Output.t;
	(* struct wl_listener frame; *)
  frame : Wl.Listener.t;
	(* struct wl_listener destroy; *)
  destroy : Wl.Listener.t;
}

type tinywl_view = {
	(* struct wl_list link; *)
	(* struct tinywl_server *server; *)
	(* struct wlr_xdg_toplevel *xdg_toplevel; *)
  xdg_toplevel : Wlr.Xdg_toplevel.t;
	(* struct wlr_scene_tree *scene_tree; *)
  scene_tree : Wlr.Scene.Tree.t;
	(* struct wl_listener map; *)
  map : Wl.Listener.t;
	(* struct wl_listener unmap; *)
  unmap : Wl.Listener.t;
	(* struct wl_listener destroy; *)
  destroy : Wl.Listener.t;
	(* struct wl_listener request_move; *)
  request_move : Wl.Listener.t;
	(* struct wl_listener request_resize; *)
  request_resize : Wl.Listener.t;
	(* struct wl_listener request_maximize; *)
  request_maximize : Wl.Listener.t;
	(* struct wl_listener request_fullscreen; *)
  request_fullscreen : Wl.Listener.t;
	(* int x, y; *)
  x : int;
  y : int;
}

type tinywl_server = {
	(* struct wl_display *wl_display; *)
  wl_display : Wl.Display.t;
	(* struct wlr_backend *backend; *)
  backend : Wlr.Backend.t;
	(* struct wlr_renderer *renderer; *)
  renderer : Wlr.Renderer.t;
	(* struct wlr_allocator *allocator; *)
  allocator : Wlr.Allocator.t;
	(* struct wlr_scene *scene; *)
  scene : Wlr.Scene.t;

	(* struct wlr_xdg_shell *xdg_shell; *)
  xdg_shell : Wlr.Xdg_shell.t;
	(* struct wl_listener new_xdg_surface; *)
  new_xdg_surface : Wl.Listener.t;
	(* struct wl_list views; *)
  mutable views : tinywl_view list;

	(* struct wlr_cursor *cursor; *)
  cursor : Wlr.Cursor.t;
	(* struct wlr_xcursor_manager *cursor_mgr; *)
  cursor_mgr : Wlr.Xcursor_manager.t;
	(* struct wl_listener cursor_motion; *)
  cursor_motion : Wl.Listener.t;
	(* struct wl_listener cursor_motion_absolute; *)
  cursor_motion_absolute : Wl.Listener.t;
	(* struct wl_listener cursor_button; *)
  cursor_button : Wl.Listener.t;
	(* struct wl_listener cursor_axis; *)
  cursor_axis : Wl.Listener.t;
	(* struct wl_listener cursor_frame; *)
  cursor_frame : Wl.Listener.t;

	(* struct wlr_seat *seat; *)
  seat : Wlr.Seat.t;
	(* struct wl_listener new_input; *)
  new_input : Wl.Listener.t;
	(* struct wl_listener request_cursor; *)
  request_cursor : Wl.Listener.t;
	(* struct wl_listener request_set_selection; *)
  request_set_selection : Wl.Listener.t;
	(* struct wl_list keyboards; *)
  mutable keyboards : Wlr.Keyboard.t list;
	(* enum tinywl_cursor_mode cursor_mode; *)
  cursor_mode : cursor_mode;
	(* struct tinywl_view *grabbed_view; *)
  grabbed_view : tinywl_view option;
	(* double grab_x, grab_y; *)
  grab_x : float;
  grab_y : float;
	(* struct wlr_box grab_geobox; *)
	(* uint32_t resize_edges; *)
  resize_edges : int;

	(* struct wlr_output_layout *output_layout; *)
  output_layout : Wlr.Output_layout.t;
	(* struct wl_list outputs; *)
  mutable outputs : tinywl_output list;
	(* struct wl_listener new_output; *)
  new_output : Wl.Listener.t;
}

type tinywl_keyboard = {
	(* struct wl_list link; *)
	(* struct tinywl_server *server; *)
	(* struct wlr_keyboard *wlr_keyboard; *)
  wlr_keyboard : Wlr.Keyboard.t;

	(* struct wl_listener modifiers; *)
  modifiers : Wl.Listener.t;
	(* struct wl_listener key; *)
  key : Wl.Listener.t;
	(* struct wl_listener destroy; *)
  destroy : Wl.Listener.t;
}

let output_frame ~server:_ _ _ =
  failwith "todo"

let output_destroy ~server:_ _ _ =
  failwith "todo"

(* This event is raised by the backend when a new output (aka a display or
   monitor) becomes available. *)
let server_new_output ~server _ wlr_output =
	(* Configures the output created by the backend to use our allocator
	   and our renderer. Must be done once, before commiting the output *)
  ignore (Wlr.Output.init_render wlr_output server.allocator server.renderer : bool);

	(* Some backends don't have modes. DRM+KMS does, and we need to set a mode
	   before we can use the output. The mode is a tuple of (width, height,
	   refresh rate), and each monitor supports only a specific set of modes. We
	   just pick the monitor's preferred mode, a more sophisticated compositor
	   would let the user configure it. *)
  let output_is_ok = 
    match Wlr.Output.preferred_mode wlr_output with
    | Some mode ->
      Wlr.Output.set_mode wlr_output mode;
      Wlr.Output.enable wlr_output true;
      Wlr.Output.commit wlr_output
    | None -> true
  in
  if output_is_ok then (
    let output = {
      wlr_output;
      frame = Wl.Listener.create ();
      destroy = Wl.Listener.create ();
    } in
    (* Sets up a listener for the frame notify event. *)
    Wl.Signal.add (Wlr.Output.signal_frame wlr_output) output.frame (output_frame ~server);
    Wl.Signal.add (Wlr.Output.signal_destroy wlr_output) output.destroy (output_destroy ~server);

    server.outputs <- output :: server.outputs;

    (* Adds this to the output layout. The add_auto function arranges outputs
       from left-to-right in the order they appear. A more sophisticated
       compositor would let the user configure the arrangement of outputs in the
       layout.
      
       The output layout utility automatically adds a wl_output global to the
       display, which Wayland clients can see to find out information about the
       output (such as DPI, scale factor, manufacturer, etc). *)
    Wlr.Output_layout.add_auto server.output_layout wlr_output
  )

(* This event is raised when wlr_xdg_shell receives a new xdg surface from a
   client, either a toplevel (application window) or popup. *)
let server_new_xdg_surface ~server _ xdg_surface =
	(* We must add xdg popups to the scene graph so they get rendered. The
	 * wlroots scene graph provides a helper for this, but to use it we must
	 * provide the proper parent scene node of the xdg popup. To enable this,
	 * we always set the user data field of xdg_surfaces to the corresponding
	 * scene node. *)
  
  let () =
    match Wlr.Xdg_surface.role xdg_surface with
    | Popup ->
      let surface = Wlr.Xdg_popup.parent (Wlr.Xdg_surface.popup xdg_surface) in
      let parent = Wlr.Xdg_surface.from_surface surface in
      ()
    | _ -> ()
  in
	(* if (xdg_surface->role == WLR_XDG_SURFACE_ROLE_POPUP) { *)
	(* 	struct wlr_xdg_surface *parent = wlr_xdg_surface_from_wlr_surface( *)
	(* 		xdg_surface->popup->parent); *)
	(* 	struct wlr_scene_tree *parent_tree = parent->data; *)
	(* 	xdg_surface->data = wlr_scene_xdg_surface_create( *)
	(* 		parent_tree, xdg_surface); *)
	(* 	return; *)
	(* } *)
	(* assert(xdg_surface->role == WLR_XDG_SURFACE_ROLE_TOPLEVEL); *)
  ()

let server_cursor_motion ~server:_ _ _ =
  failwith "todo"

let server_cursor_motion_absolute ~server:_ _ _ =
  failwith "todo"

let server_cursor_button ~server:_ _ _ =
  failwith "todo"

let server_cursor_axis ~server:_ _ _ =
  failwith "todo"

let server_cursor_frame ~server:_ _ _ =
  failwith "todo"

let server_new_keyboard ~server:_ (_keyboard: Wlr.Keyboard.t) =
  failwith "todo"

let server_new_pointer ~server:_ (_pointer: Wlr.Input_device.t) =
  failwith "todo"
(*   Wlr.Cursor.attach_input_device st.cursor pointer *)

let server_new_input ~server:_ _ (_device: Wlr.Input_device.t) =
  failwith "todo"
(*   begin match Wlr.Input_device.typ device with *)
(*   | Wlr.Input_device.Keyboard keyboard -> *)
(*     server_new_keyboard st keyboard *)
(*   | Wlr.Input_device.Pointer _ -> *)
(*     server_new_pointer st device *)
(*   | _ -> *)
(*     () *)
(*   end; *)
(*   let caps = *)
(*     Wl.Seat_capability.Pointer :: *)
(*     (match st.keyboards with *)
(*      | [] -> [] *)
(*      | _ -> [Wl.Seat_capability.Keyboard]) *)
(*   in *)
(*   Wlr.Seat.set_capabilities st.seat caps *)

let seat_request_cursor ~server:_ _ (_ev: Wlr.Seat.Pointer_request_set_cursor_event.t) =
  failwith "todo"
  (* let module E = Wlr.Seat.Pointer_request_set_cursor_event in *)
  (* let focused_client = *)
  (*   st.seat |> Wlr.Seat.pointer_state |> Wlr.Seat.Pointer_state.focused_client in *)
  (**)
  (* if Wlr.Seat.Client.equal focused_client (E.seat_client ev) then ( *)
  (*   Wlr.Cursor.set_surface st.cursor (E.surface ev) (E.hotspot_x ev) (E.hotspot_y ev) *)
  (* ) *)

let seat_request_set_selection ~server:_ _ (_ev: Wlr.Seat.Request_set_selection_event.t) =
  failwith "todo"


let () =
  Wlr.Log.(init Debug);
  let startup_cmd =
    match Array.to_list Sys.argv |> List.tl with
    | ["-s"; cmd] -> Some cmd
    | [] -> None
    | _ ->
      Printf.printf "Usage: %s [-s startup command]\n" Sys.argv.(0);
      exit 0
  in

	(* The Wayland display is managed by libwayland. It handles accepting
	   clients from the Unix socket, manging Wayland globals, and so on. *)
  let wl_display = Wl.Display.create () in

	(* The backend is a wlroots feature which abstracts the underlying input and
	   output hardware. The autocreate option will choose the most suitable
	   backend based on the current environment, such as opening an X11 window
	   if an X11 server is running. *)
  let backend = Wlr.Backend.autocreate wl_display in

	(* Autocreates a renderer, either Pixman, GLES2 or Vulkan for us. The user
	   can also specify a renderer using the WLR_RENDERER env var.
	   The renderer is responsible for defining the various pixel formats it
	   supports for shared memory, this configures that for clients. *)
  let renderer = Wlr.Renderer.autocreate backend in

  assert (Wlr.Renderer.init_wl_display renderer wl_display);

	(* Autocreates an allocator for us.
	   The allocator is the bridge between the renderer and the backend. It
	   handles the buffer creation, allowing wlroots to render onto the
	   screen *)
  let allocator = Wlr.Allocator.autocreate backend renderer in

	(* This creates some hands-off wlroots interfaces. The compositor is
	   necessary for clients to allocate surfaces, the subcompositor allows to
	   assign the role of subsurfaces to surfaces and the data device manager
	   handles the clipboard. Each of these wlroots interfaces has room for you
	   to dig your fingers in and play with their behavior if you want. Note that
	   the clients cannot set the selection directly without compositor approval,
	   see the handling of the request_set_selection event below.*)
  let _compositor = Wlr.Compositor.create wl_display renderer in
  let _subcompositor = Wlr.Subcompositor.create wl_display in
  let _data_manager = Wlr.Data_device.Manager.create wl_display in

	(* Creates an output layout, which a wlroots utility for working with an
	   arrangement of screens in a physical layout. *)
  let output_layout = Wlr.Output_layout.create () in

	(* Create a scene graph. This is a wlroots abstraction that handles all
	   rendering and damage tracking. All the compositor author needs to do
	   is add things that should be rendered to the scene graph at the proper
	   positions and then call wlr_scene_output_commit() to render a frame if
	   necessary. *)
  let scene = Wlr.Scene.create () in
  ignore (Wlr.Scene.attach_output_layout scene output_layout : bool);

	(* Set up xdg-shell version 3. The xdg-shell is a Wayland protocol which is
	 * used for application windows. For more detail on shells, refer to my
	 * article:
	 *
	 * https://drewdevault.com/2018/07/29/Wayland-shells.html *)
  let xdg_shell = Wlr.Xdg_shell.create wl_display 3 in

	(* Creates a cursor, which is a wlroots utility for tracking the cursor
	   image shown on screen. *)
  let cursor = Wlr.Cursor.create() in
  Wlr.Cursor.attach_output_layout cursor output_layout;

	(* Creates an xcursor manager, another wlroots utility which loads up
	   Xcursor themes to source cursor images from and makes sure that cursor
	   images are available at all scale factors on the screen (necessary for
	   HiDPI support). We add a cursor theme at scale factor 1 to begin with. *)
  let cursor_mgr = Wlr.Xcursor_manager.create None 24 in
  ignore (Wlr.Xcursor_manager.load cursor_mgr 1.0 : int);

  (* Initialize the server state. *)
  let server = {
    wl_display;
    backend;
    renderer;
    allocator;
    output_layout;
    new_output = Wl.Listener.create ();
    scene;
    xdg_shell;
    new_xdg_surface = Wl.Listener.create ();
    cursor;
    cursor_mgr;
    cursor_mode = Cursor_passthrough;
    cursor_motion = Wl.Listener.create ();
    cursor_motion_absolute = Wl.Listener.create ();
    cursor_button = Wl.Listener.create ();
    cursor_axis = Wl.Listener.create ();
    cursor_frame = Wl.Listener.create ();
    new_input = Wl.Listener.create ();
    seat = Wlr.Seat.create wl_display "seat0";
    request_cursor = Wl.Listener.create ();
    request_set_selection = Wl.Listener.create ();

    outputs = [];
    views = [];
    keyboards = [];

    grabbed_view = None;
    grab_x = 0.0;
    grab_y = 0.0;
    resize_edges = 0;
  } in

	(* Configure a listener to be notified when new outputs are available on the
	   backend. *)
  Wl.Signal.add (Wlr.Backend.signal_new_output backend) server.new_output (server_new_output ~server);

  Wl.Signal.add (Wlr.Xdg_shell.signal_new_surface xdg_shell) server.new_xdg_surface
    (server_new_xdg_surface ~server);

	(* wlr_cursor *only* displays an image on screen. It does not move around
	   when the pointer moves. However, we can attach input devices to it, and
	   it will generate aggregate events for all of them. In these events, we
	   can choose how we want to process them, forwarding them to clients and
	   moving the cursor around. More detail on this process is described in my
	   input handling blog post:
	  
	   https://drewdevault.com/2018/07/17/Input-handling-in-wlroots.html
	  
	   And more comments are sprinkled throughout the notify functions above. *)
  Wl.Signal.add (Wlr.Cursor.signal_motion cursor) server.cursor_motion (server_cursor_motion ~server);
  Wl.Signal.add (Wlr.Cursor.signal_motion_absolute cursor) server.cursor_motion_absolute
    (server_cursor_motion_absolute ~server);
  Wl.Signal.add (Wlr.Cursor.signal_button cursor) server.cursor_button (server_cursor_button ~server);
  Wl.Signal.add (Wlr.Cursor.signal_axis cursor) server.cursor_axis (server_cursor_axis ~server);
  Wl.Signal.add (Wlr.Cursor.signal_frame cursor) server.cursor_frame (server_cursor_frame ~server);

	(* Configures a seat, which is a single "seat" at which a user sits and
	 * operates the computer. This conceptually includes up to one keyboard,
	 * pointer, touch, and drawing tablet device. We also rig up a listener to
	 * let us know when new input devices are available on the backend. *)
  Wl.Signal.add (Wlr.Backend.signal_new_input backend) server.new_input (server_new_input ~server);
  Wl.Signal.add (Wlr.Seat.signal_request_set_cursor server.seat) server.request_cursor
    (seat_request_cursor ~server);
  Wl.Signal.add (Wlr.Seat.signal_request_set_selection server.seat) server.request_set_selection
    (seat_request_set_selection ~server);

	(* Add a Unix socket to the Wayland display. *)
  let socket = match Wl.Display.add_socket_auto wl_display with
    | None ->
      Wlr.Backend.destroy backend;
      exit 1
    | Some socket -> socket
  in

	(* Start the backend. This will enumerate outputs and inputs, become the DRM
	   master, etc *)
  if not (Wlr.Backend.start backend) then (
    Wlr.Backend.destroy backend;
    Wl.Display.destroy wl_display;
    exit 1
  );

	(* Set the WAYLAND_DISPLAY environment variable to our socket and run the
	   startup command if requested. *)
  Unix.putenv "WAYLAND_DISPLAY" socket;
  begin match startup_cmd with
    | Some cmd ->
      if Unix.fork () = 0 then Unix.execv "/bin/sh" [|"/bin/sh"; "-c"; cmd|]
    | None -> ()
  end;

	(* Run the Wayland event loop. This does not return until you exit the
	   compositor. Starting the backend rigged up all of the necessary event
	   loop configuration to listen to libinput events, DRM events, generate
	   frame events at the refresh rate, and so on. *)
  Printf.printf "Running wayland compositor on WAYLAND_DISPLAY=%s" socket;
  Wl.Display.run wl_display;

	(* Once wl_display_run returns, we shut down the server. *)
  Wl.Display.destroy_clients wl_display;
  Wl.Display.destroy wl_display;

  exit 0
