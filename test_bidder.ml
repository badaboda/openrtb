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


(*
Copyright (c) 2012, EigenDog, Inc.  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:
      
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the
   distribution.

3. Neither the name of EigenDog nor the names of contributors may be used
   to endorse or promote products derived from this software without
   specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*)

