#!/usr/bin/env python3
import socket
print('connect')
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('127.0.0.1', 8081))

print('wait')
buffer = s.recv(11)

print('received')
print(buffer)

print('send')
s.send(b'\xff\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00')

from time import sleep

for turn in range(5):
	print('wait for turn', turn)
	buffer = s.recv(11)
	print(buffer)
	playground = bytearray(buffer[2:])

	for k, v in enumerate(playground):
		if v == 0:
			playground[k] = 2
			break

	print('send my turn')
	sleep(2)
	s.send(bytearray([255, 1])+playground)



print('done')

