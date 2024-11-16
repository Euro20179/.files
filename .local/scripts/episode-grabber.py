#!/bin/python

#This script pulls the episode number from <filename>
    #(assuming the episode number is in the filename)
    #if the episode number is not in the filename this script will fail

#Arguments to this script must bee
# <filename from a directory> <path to that directory>
#the filename MUST NOT contain the directory that it resides in
from pathlib import Path
import sys
import re
import os

args = sys.argv[1:]

currentFile = args[0]
directory = args[1]

files = os.listdir(directory)

if len(files) == 0:
    exit(1)

#finds a number "that looks like an episode number"
#such a number is prefixed optionally with any of [\W_-. ], E, OVA, or \dx
#and the suffix MUST match [\W_-. ]
#this will match something like S03E10, or S1x30 or NAME 3.mkv, etc...
regex = re.compile(r"([\W_\-\. ]|E|OVA|\dx)?(\d+[\W_\-\. ])")
matches = regex.findall(currentFile)
realMatches = matches
currentFile = str(Path(directory) / Path(currentFile))
#then if that number appears in multiple files, it is not the episode number
for file in files:
    file = str(Path(directory) / Path(file))
    if file == currentFile: continue

    match: tuple[str]
    for match in matches:
        if "".join(match) in file:
            if match in realMatches:
                realMatches.remove(match)
    if len(realMatches) == 1:
        break

numMatch: str = realMatches[0]
_ = sys.stdout.write(numMatch[1][:-1])
