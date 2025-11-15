#!/usr/bin/env python3
import socket
import subprocess

sock_path = "/opt/mc-access/access.sock"

# Delete old socket if exists
import os
if os.path.exists(sock_path):
    os.remove(sock_path)

server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(sock_path)
server.listen(1)

print("Listener running...")

while True:
    conn, _ = server.accept()
    data = conn.recv(1024).decode().strip()

    if data == "toggle":
        subprocess.run(["systemctl", "restart", "your-service.service"])
    elif data == "start":
        subprocess.run(["systemctl", "start", "your-service.service"])
    elif data == "stop":
        subprocess.run(["systemctl", "stop", "your-service.service"])

    conn.send(b"ok")
    conn.close()
