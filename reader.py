# !/usr/bin/env python3
# приемник
import sys
import serial

try:
    device = "/dev/ttyS2"
    port = serial.Serial(device)
    port.baudrate = 19200
    port.parity = "N"
    port.stopbits = 1
    port.timeout = 0.2
    port.xonxoff = False
    port.rtscts = False
    port.dsrdtr = False
except serial.SerialException as err:
    print("\tУстройство не доступно")
    raise err

print(port)
i = 0
while True:
    try:
        input_bytes = port.read()
        for byte in input_bytes:
            if i % 16 == 0:
                print('', flush=True)
            elif i % 4 == 0:
                print(' ', end='', flush=True)
            byte_string = format(byte, 'x')
            if len(byte_string) == 1:
                print("0", end='')
            print(byte_string, end=' ', flush=True)
            i += 1
    except KeyboardInterrupt:
        break

port.close()

