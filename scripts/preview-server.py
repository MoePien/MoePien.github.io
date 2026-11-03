#!/usr/bin/env python3
import http.server
import socketserver
import sys


class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()


class PreviewServer(socketserver.TCPServer):
    allow_reuse_address = True


port = int(sys.argv[1]) if len(sys.argv) > 1 else 4000
with PreviewServer(("", port), NoCacheHandler) as server:
    server.serve_forever()
