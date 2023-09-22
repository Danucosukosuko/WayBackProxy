import requests
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import threading
import subprocess
import os

PORT = 8080
RESTART_INTERVAL = 60

server_running = True

class ProxyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        client_url = self.path
        print("Solicitud del cliente:", client_url)
        
        wayback_url = "https://web.archive.org/web/20110101000000/" + client_url
        
        try:
            response = requests.get(wayback_url)
            
            if response.status_code == 200:
                content = response.text
                
                self.send_response(200)
                self.send_header('Content-Type', 'text/html; charset=utf-8')
                self.end_headers()
                
                self.wfile.write(content.encode('utf-8'))
            else:
                self.send_response(404)
                self.send_header('Content-Type', 'text/plain; charset=utf-8')
                self.end_headers()
                self.wfile.write('Página no encontrada en la Wayback Machine.'.encode('utf-8'))
        except requests.exceptions.RequestException as e:
            self.send_response(500)
            self.send_header('Content-Type', 'text/plain; charset=utf-8')
            self.end_headers()
            self.wfile.write(('Error de conexión con la Wayback Machine: ' + str(e)).encode('utf-8'))

def start_proxy_server():
    with HTTPServer(("", PORT), ProxyHandler) as httpd:
        print("Servidor proxy en el puerto", PORT)
        httpd.serve_forever()

def restart_proxy_server():
    global server_running
    server_running = False
    time.sleep(1)
    subprocess.Popen(["python", "proxy_server.py"])
    os._exit(0)

def restart_server_thread():
    while True:
        time.sleep(RESTART_INTERVAL)
        restart_proxy_server()

restart_thread = threading.Thread(target=restart_server_thread)
restart_thread.daemon = True
restart_thread.start()

start_proxy_server()
