type handler = OpenRTB.request -> OpenRTB.response Lwt.t
  (* the type of an OpenRTB request handler, which takes a request as
     input, producing a response; (de)-serialization is taken care of by
     the SCGI container *)


val create : ?name:string -> int -> handler -> unit Lwt.t
  (* [create 8080 f] creates an SCGI server on port 8080 of localhost,
     whose request handler is [f]. *)
