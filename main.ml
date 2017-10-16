open Core.Std
open Printf

let configure ~debug ~verbose =
  Config.debug_mode := debug;
  Config.verbose_mode := verbose

let basic_spec () =
  Command.Spec.(
    empty
    +> flag "-d" no_arg ~doc:" debug output"
    +> flag "-v" no_arg ~doc:" print verbose message"
  )

let subcmd_new =
  Command.basic
    ~summary:"create a new project"
    (basic_spec ())
    (fun debug verbose () ->
       configure ~debug ~verbose;
    )

let subcmd_clean =
  Command.basic
    ~summary:"remove built files"
    (basic_spec ())
    (fun debug verbose () ->
       configure ~debug ~verbose;
    )

let main =
  Command.group
    ~summary:"Esca build tool"
    [("new", subcmd_new);
     ("clean", subcmd_clean)]

let () =
  Command.run
    ~version:""
    ~build_info:(sprintf "Ysca %s" Config.version)
    main
