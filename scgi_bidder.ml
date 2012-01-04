open Scgi

type handler = OpenRTB.request -> OpenRTB.response Lwt.t

let scgi_handler f scgi_request =
  try_lwt
    (* get the body of the request *)
    lwt request_s = Lazy.force (scgi_request.Scgi_request.content) in

    (* de-serialize request *)
    let request = OpenRTB.request_of_string request_s in

    (* handle request *)
    lwt response = f request in

    (* serialize response *)
    let response_s = OpenRTB.string_of_response response in

    Lwt.return {
      Scgi_response.status = `Ok;
      headers = [];
      body = `String response_s
    }
  with exn ->
    let response_s = Printexc.to_string exn in

    Lwt.return {
      Scgi_response.status = `Bad_request;
      headers = [];
      body = `String response_s
    }      

let create ?(name="bidder") port handler =
  Scgi.handler name "127.0.0.1" port (scgi_handler handler);
  Lwt.return ()

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
