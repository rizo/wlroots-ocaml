open Wlroots
open! Tgl3


type sample_state = {
  display : Wl.Display.t;
  new_output : Wl.Listener.t;
  new_input : Wl.Listener.t;
  renderer : Renderer.t;
  allocator : Allocator.t;
  mutable last_frame : Mtime.t;
  color : float array; (* of size 3 *)
  mutable dec : int;
}

type output = {
  frame : Wl.Listener.t;
  destroy : Wl.Listener.t;
}

type keyboard = {
  device : Keyboard.t;
  key : Wl.Listener.t;
  destroy : Wl.Listener.t;
}

let fail msg () =
  print_endline msg; exit 1

let output_frame_notify ~sample _ output =
  let now = Mtime_clock.now () in
  let ms = Mtime.span sample.last_frame now |> Mtime.Span.to_ms in
  let inc = (sample.dec + 1) mod 3 in
  let dcol = ms /. 2000. in

  sample.color.(inc) <- sample.color.(inc) +. dcol;
  sample.color.(sample.dec) <- sample.color.(sample.dec) -. dcol;
  if sample.color.(sample.dec) < 0. then (
    sample.color.(inc) <- 1.;
    sample.color.(sample.dec) <- 0.;
    sample.dec <- inc
  );

  ignore (Output.attach_render output : bool);
  Gl.clear_color sample.color.(0) sample.color.(1) sample.color.(2) 1.;
  Gl.clear Gl.color_buffer_bit;
  ignore (Output.commit output : bool);
  sample.last_frame <- Mtime_clock.now ()

let output_remove_notify output_handles _ _output =
  print_endline "Output removed";
  Wl.Listener.detach output_handles.frame;
  Wl.Listener.detach output_handles.destroy

let new_output_notify ~sample _ output =
  prerr_endline "new_output_notify: init output render";
  let _ : bool = Output.init_render output sample.allocator sample.renderer in

  prerr_endline "new_output_notify: Creating frame and destroy listeners...";
  let o = { frame = Wl.Listener.create ();
            destroy = Wl.Listener.create (); } in
  prerr_endline "new_output_notify: Getting outupt modes...";
  begin match Output.modes output with
    | mode :: _ ->
      prerr_endline "new_output_notify: Setting output mode...";
      Output.set_mode output mode
    | [] -> ()
  end;
  prerr_endline "new_output_notify: Setting up output frame signal...";
  Wl.Signal.add (Output.signal_frame output) o.frame (output_frame_notify ~sample);

  prerr_endline "new_output_notify: Setting up output destroy signal...";
  Wl.Signal.add (Output.signal_destroy output) o.destroy
    (output_remove_notify o);

  prerr_endline "new_output_notify: Committing output...";
  ignore (Output.commit output : bool);
  ()

let keyboard_destroy_notify keyboard_handles _ _input =
  print_endline "keyboard removed";
  Wl.Listener.detach keyboard_handles.key;
  Wl.Listener.detach keyboard_handles.destroy

let keyboard_key_notify display keyboard _ event =
  let keycode = Keyboard.Event_key.keycode event + 8 in
  let syms = Xkbcommon.State.key_get_syms (Keyboard.xkb_state keyboard)
      keycode in
  if List.mem Xkbcommon.Keysyms._Escape syms then
    Wl.Display.terminate display;
  ()

let new_input_notify display _ (input: Input_device.t) =
  match Input_device.typ input with
  | Input_device.Keyboard keyboard ->
    let k = {
      device = keyboard;
      key = Wl.Listener.create ();
      destroy = Wl.Listener.create ();
    } in
    Wl.Signal.add (Input_device.signal_destroy input) k.destroy
      (keyboard_destroy_notify k);
    Wl.Signal.add (Keyboard.signal_key keyboard) k.key
      (keyboard_key_notify display keyboard);
    let rules = Xkbcommon.Rule_names.{
      rules = Sys.getenv_opt "XKB_DEFAULT_RULES";
      model = Sys.getenv_opt "XKB_DEFAULT_MODEL";
      layout = Sys.getenv_opt "XKB_DEFAULT_LAYOUT";
      variant = Sys.getenv_opt "XKB_DEFAULT_VARIANT";
      options = Sys.getenv_opt "XKB_DEFAULT_OPTIONS";
    } in
    Xkbcommon.Context.with_new (fun context ->
      Xkbcommon.Keymap.with_new_from_names context rules (fun keymap ->
        ignore (Keyboard.set_keymap keyboard keymap : bool)
      ) ~fail:(fail "Failed to create XKB keymap")
    ) ~fail:(fail "Failed to create XKB context")
  | _ ->
    ()

let () =
  Log.(init Debug);
  prerr_endline "Creating display...";
  let display = Wl.Display.create () in

  prerr_endline "Creating backend...";
  let backend = Backend.autocreate display in

  prerr_endline "Creating renderer...";
  let renderer = Renderer.autocreate backend in

  prerr_endline "Creating renderer...";
  let allocator = Allocator.autocreate backend renderer in

  let sample = {
    color = [|1.; 0.; 0.|];
    dec = 0;
    last_frame = Mtime_clock.now ();
    display;
    renderer;
    allocator;
    new_output = Wl.Listener.create ();
    new_input = Wl.Listener.create ();
  } in

  prerr_endline "Setting up new output signal...";
  Wl.Signal.add (Backend.signal_new_output backend) sample.new_output
    (new_output_notify ~sample);

  prerr_endline "Setting up new input signal...";
  Wl.Signal.add (Backend.signal_new_input backend) sample.new_input
    (new_input_notify display);

  if not (Backend.start backend) then (
    Backend.destroy backend;
    failwith "Unable to start backend";
  );

  prerr_endline "Running display...";
  Wl.Display.run display;

  prerr_endline "Destroying display...";
  Wl.Display.destroy display;
  ()
