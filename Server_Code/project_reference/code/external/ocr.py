#!/usr/bin/python

import os
import sys
import httplib

if len(sys.argv) == 3:
    sOptions = sys.argv[2];
else:
    sOptions = ''; 

# Opens a input file
fInput = open( sys.argv[1],"rb");
datafile = fInput.read();

# Posts the file to the server
conn = httplib.HTTPConnection('blackhole1.stanford.edu');
if sOptions == '':
    conn.request('POST','/ocr/recognize.php',datafile);
else:
    conn.request('POST','/ocr/recognize.php?OPT=%s'%sOptions,datafile);

# Gets the response and quits
response = conn.getresponse()
data = response.read()
aData = data.split('\n');
for sLine in aData:
    if len(sLine) > 1:
        print sLine;
conn.close()