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
import getopt

args = sys.argv[1:]

printSeasonOnly = 0
printBoth = 0
opts = getopt.getopt(args, "sb")
opts, args = opts

for opt in opts:
    if opt[0] == "-s":
        printSeasonOnly = 1
    elif opt[0] == "-b":
        printBoth = 1
        printSeasonOnly = 0


currentFile = args[0]
directory = args[1]

if directory == "-/":
    files = input().split("\x00")
else:
    files = os.listdir(directory)

if len(files) == 0:
    exit(1)


#assume after a season number is a "." or "E" to indicate the episode
seasonRegex = re.compile(r"(S|Season ?)(\d+)(?:[E\.]|$)", re.IGNORECASE)

#finds a number "that looks like an episode number"
#such a number is prefixed optionally with any of [\W_-. ], E, OVA, or \dx
#and the suffix MUST match [\W_-. ]
#this will match something like S03E10, or S1x30 or NAME 3.mkv, etc...
#the extra garbage MUST be included to compare against other files
epRegex = re.compile(r"([\W_\-\. ]|E|OVA|\dx)?(\d+(?:\.\d+)?[\W_\-\. ]|$)", re.IGNORECASE)
epMatches = epRegex.findall(currentFile)

curSeason = seasonRegex.findall(currentFile)

if curSeason:
    curSeason = int(curSeason[0][1])
else:
    curSeason = -1

if printSeasonOnly:
    sys.stdout.write(str(curSeason))
    exit(0)

realMatches = epMatches
currentFile = str(Path(directory) / Path(currentFile))
#then if that number appears in multiple files, it is not the episode number
for file in files:
    file = str(Path(directory) / Path(file))
    if file == currentFile: continue

    fileSeason = seasonRegex.findall(file)
    fileSeason = int(fileSeason[0][1]) if fileSeason else -1

    if fileSeason != curSeason: continue

    match: tuple[str]
    for match in [*epMatches]:
        if "".join(match) in file:
            if match in realMatches:
                realMatches.remove(match)
    if len(realMatches) == 1:
        break

if len(realMatches) == 0:
    if printBoth:
        sys.stdout.write(f'{curSeason}:')
    else:
        sys.stdout.write("")

else:
    numMatch: str = realMatches[0]
    if len(args) > 2 and args[2] == "i":

        #only fractional eps should get converted to a float
        #otherwise we get .0 on integer eps
        ep = str((float if "." in numMatch[1][:-1] else int)(numMatch[1][:-1]))
    else:
        ep = numMatch[1][:-1]
    if printBoth:
        _ = sys.stdout.write(f"{curSeason}:{ep}")
    else:
        _ = sys.stdout.write(ep)
