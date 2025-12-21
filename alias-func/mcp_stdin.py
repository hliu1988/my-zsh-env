import sys
import os

dest = sys.argv[1]
print ("copy files to "+dest)
for line in sys.stdin:
	print ("copying " + line.rstrip('\n') + " ...")
	os.system("cp -r " + line.rstrip('\n') + " " + dest)

