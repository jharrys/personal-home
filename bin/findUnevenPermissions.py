#!/usr/bin/python
import os

for root, dirs, files in os.walk('/'):
	testFiles = []
	for name in files:
		fullName = os.path.join(root, name)
		testFiles.append(fullName)

	for name in dirs:
		fullName = os.path.join(root, name)
		testFiles.append(fullName)

	for name in testFiles:
		fileMode = os.lstat(name).st_mode
		usrMode = (fileMode / 8**2) % 8
		grpMode = (fileMode / 8) % 8
		othMode = fileMode % 8

	if othMode > grpMode or othMode > usrMode or grpMode > usrMode:
		print "Mode=%d%d%d %s" % (usrMode, grpMode, othMode, name)
