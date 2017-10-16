open Core.Std
open Printf

let configure ?config_file ~debug ~verbose () =
  Config.debug_mode := debug;
  Config.verbose_mode := verbose;
  Option.iter config_file ~f:(fun file -> Config.config_file := file);
  ()

let basic_spec () =
  Command.Spec.(
    empty
    +> flag "-d" no_arg ~doc:" debug output"
    +> flag "-v" no_arg ~doc:" print verbose message"
  )

let subcmd_new =
  Command.basic
    ~summary:"create a new project"
    Command.Spec.(
      (basic_spec ())
      +> anon ("name" %: string)
    )
    (fun debug verbose name () ->
       configure ~debug ~verbose ();
       Main_new.run ~name)

let subcmd_build =
  Command.basic
    ~summary:"compile source files to Go source files"
    Command.Spec.(
      (basic_spec ())
      +> flag "-config" (required string) ~doc:"config file (default: Yscafile)"
    )
    (fun debug verbose config_file () ->
       configure ~debug ~verbose ~config_file ();
       ())

let subcmd_clean =
  Command.basic
    ~summary:"remove built files"
    (basic_spec ())
    (fun debug verbose () ->
       configure ~debug ~verbose ();
    )

let main =
  Command.group
    ~summary:"Esca build tool"
    [("new", subcmd_new);
     ("build", subcmd_build);
     ("clean", subcmd_clean)]

let () =
  Command.run
    ~version:""
    ~build_info:(sprintf "Ysca %s" Config.version)
    main
