This repository contains OCaml code to validate requests and responses
as specified by [OpenRTB](http://openrtb.info), in [Version 2.0](http://openrtb.googlecode.com/files/RTB%20Project%20v2.0%20for%20Public%20Comment.pdf)
of the specification.  The specification is formalized using
[ATD](https://github.com/mjambon/atd), in file
[openrtb.atd](https://github.com/EigenDog/openrtb/blob/master/openrtb.atd).
The tool [atdgen](https://github.com/MyLifeLabs/atdgen) generates
OCaml serializer and deserializers from this specification.  To
validate a request contained in file `request-file.js` :

    $ ./validate -request request-file.js

To validate a response in file `response-file.js` :

    $ ./validate -response response-file.js

Secondly, the repository contains all of the examples contained in
[Version
2.0](http://openrtb.googlecode.com/files/RTB%20Project%20v2.0%20for%20Public%20Comment.pdf)
document.  In several cases, the examples were modified to conform to
the specification, or vice-versa.  See details below.

Finally, the repository contains an
[SCGI](http://www.python.ca/scgi/protocol.txt) "bidder" server, in
which the details of request de-serialization and response
serlialization are abstracted away.  This server can be deployed
behind any web server which supports the
[SCGI](http://www.python.ca/scgi/protocol.txt) protocol,
e.g. [Apache](http://httpd.apache.org/docs/2.3/mod/mod_proxy_scgi.html)
or [Nginx](http://wiki.nginx.org/HttpScgiModule).  The file
[test_bidder.ml](http://github.com/EigenDog/openrtb/blob/master/test_bidder.ml)
implements a dummy bidder, which returns the same minimalistic
response, independent of the request.  Deploying it behind Nginx, on
uri /test-bidder/, on port 8080, and on the same host as the web
server, requires the following stanza in the Nginx's configuration
file:

    location /test-bidder/ {
        scgi_pass 127.0.0.1:8080;
        include scgi_params;
    }

To start the bidder:

    $ ./test_bidder -p 8080 &

To make a request, assuming you do so from the same host as the web server:

    $ curl --data-binary @simple-banner.js http://localhost/test-bidder/

Why is [EigenDog](https://www.eigendog.com) doing this?
-------------------------------------------------------

We want to learn more about the RTB ecosystem, of which scalable
predictive modeling is a significant component.

Dependencies
------------

To build openrtb, you'll need:

 * [omake](http://omake.metaprl.org)
 * [findlib](http://projects.camlcity.org/projects/findlib.html)
 * [ocaml-cgi](https://github.com/mwells/ocaml-cgi)
 * [atdgen](https://github.com/MyLifeLabs/atdgen)

Note that each of these may have additional dependencies, namely
[lwt](https://ocsigen.org/lwt) and [ATD](https://github.com/mjambon/atd)

Modifications to Specification and Examples
-------------------------------------------

We made the following changes to the draft specification:

 * removed the `keywords` field whenever it has a sibling field
   `content`, as the latter also contains the `keywords` field
 * replaced the `keyword` field with its plural form `keywords` ,
   and represented it by a list of strings rather than an
   optional, comma-separated string.
 * represented `privacypolicy` by a boolean, rather than an
   integer, following the video example.
 * represented `boxingallowed` by a boolean, rather than an
   integer, following the video example.
 * represented `protocol` by array of integers rather than a
   single integer, following the video example.

In addition, we made the following changes to the examples:

 * simple-banner.js: 
  - changed `at` to string
  - changed `id` to string

 * expandable-creative.js: 
  - changed `at` to string

 * video.js: 
  - changed `at` to string
  - in `companionad` , removed `banner` field label
  - changed `api` to array
  - changed `season` to string

 * response-win-vast-inline.js:
  - added `impid` field

