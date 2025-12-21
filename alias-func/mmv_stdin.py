import sys
import os

dest = sys.argv[1]
print ("move files to "+dest)
for line in sys.stdin:
	print ("moving " + line.rstrip('\n') + " ...")
	os.system("mv " + line.rstrip('\n') + " " + dest)

