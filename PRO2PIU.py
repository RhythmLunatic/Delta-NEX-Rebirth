#!/usr/bin/python3

import sys
import os
import math

silence = False

def print2(a):
	if not silence:
		print(a)

if len(sys.argv) < 2:
	print("Usage: " + sys.argv[0] + " <ssc location>")
	print("Optionally add --silent flag at the end to only output ffmpeg command")
else:
	if len(sys.argv) == 3:
		if sys.argv[2] == "--silent":
			silence = True
	print2(sys.argv[1])
	f = open(sys.argv[1], "r")
	lines = f.readlines()
	f.close()
	for i in range(len(lines)):
		if lines[i].startswith("#NOTES"):
			lv = int(lines[i+4].strip()[:-1])
			print(lines[i+1].strip() + " " +str(lv) + " -> " + str(math.floor(lv*1.5)))
		#else:
		#	print(lines[i])
	
	#print(msg)
	#
