#!usr/bin/env python3
import socket
from multiprocessing import Process


# import re
# import os


class ServerSocket:

    def __init__(self):
        self.server_socket = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
        self.clients = []

    def bind(self, port):
        self.server_socket.bind(('', port))

    def start_server(self):
        self.server_socket.listen(128)
        while True:
            client_socket, address = self.server_socket.accept()
            print('*' * 15)
            print('客户端地址：', address)
            print('客户端：', client_socket)
            print('*' * 15)
            self.clients.append(client_socket)
            handle_process = Process(target = self.process_target, args = (client_socket,))
            handle_process.start()
            # client_socket.close()

    def process_target(self, client_socket):
        while self.handle_socket_message(self, client_socket):
            pass

    @staticmethod
    def handle_socket_message(self, client_socket):

        receive_data = client_socket.recv(1024)
        receive_msg = receive_data.decode('utf-8')
        if receive_msg == 'BSSocket.disconnect':
            client_socket.close()
            print('客户端断开连接')
            return False
        else:
            print('%s' % receive_msg)
            send_message = '我已收到消息，准备接受下一条消息'
            client_socket.send(send_message.encode('utf-8'))
            return True


def main():
    server_socket = ServerSocket()
    server_socket.bind(8000)
    server_socket.start_server()


if __name__ == '__main__':
    main()
