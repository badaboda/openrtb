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
