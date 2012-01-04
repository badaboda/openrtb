(* program to validate OpenRTB requests and responses:

   Any number of files may be given in the command line preceded by a
   flag indicating whether they represent a request or response
   message. Example:

   ./validate -request file1.js -request file2.js -response file3.js

*)

open Printf

let validate_file of_string file_name =
  Printf.printf "file %s ... %!" file_name;
  let s = Mikmatch.Text.file_contents file_name in
  try
    let req = of_string s in
    ignore req;
    print_endline "passed";
  with exn ->
    Printf.printf "%s\n%!" (Printexc.to_string exn)


let _ =
  let usage = sprintf "%s -request <request-fname-1> -request <request-fname-2> \
     -response <response-fname-1> ..." Sys.argv.(0) in

  let files = ref [] in

  Arg.parse [
    "-request", Arg.String (fun f -> files := (`Request f) :: !files),
    "  <request-file>  file containing a request";

    "-response", Arg.String (fun f -> files := (`Response f) :: !files),
    "  <response-file>  file containing a responses"
  ] (fun _ -> ()) usage;

  files := List.rev !files;

  List.iter (
    function
      | `Request file_name ->
          validate_file OpenRTB.request_of_string file_name
      | `Response file_name ->
          validate_file OpenRTB.response_of_string file_name
  ) !files

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
