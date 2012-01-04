open OpenRTB

let handler request = 
  (* get the request id (but do nothing with it) *)
  let request_id = request.req_id in
  ignore request_id;

  (* construct dummy response *)
  let seat_bid = {
    sb_bid = [ 
      { 
        bi_id = "1234567890"; 
        bi_impid = "1"; 
        bi_price = 9.43 ;
        bi_nurl = Some "http://adserver.com/WinNoticeUrlThatReturnsVAST";
        bi_adid = None;
        bi_adm = None;
        bi_adomain = [];
        bi_iurl = None;
        bi_cid = None;
        bi_crid = None;
        bi_attr = [];
        bi_ext = None;
      }
    ];
    sb_seat = None;
    sb_group = 0;
  } in

  let response = OpenRTB.create_response ~res_id:"1234" 
    ~res_seatbid:[seat_bid] () in

  Lwt.return response

open Printf

let _ =
  let port = ref 8080 in
  let usage = sprintf "%s [-p <port>]" Sys.argv.(0) in
  Arg.parse [
    "-p", Arg.Int (fun i -> port := i),
    sprintf "  <port>  start the scgi server on this port (default %d)" !port
  ] (fun _ -> ()) usage;

  lwt () = Scgi_bidder.create !port handler in 

  (* igore SIGPIPE's *)
  Sys.set_signal Sys.sigpipe Sys.Signal_ignore;

  (* Run forever in foreground. *)
  Lwt_main.run (fst (Lwt.wait ()))

