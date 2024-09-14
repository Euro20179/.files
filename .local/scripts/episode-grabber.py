#!/bin/python
import sys
import re
import os

args = sys.argv[1:]

currentFile = args[0]
directory = args[1]

files = os.listdir(directory)

if len(files) == 0:
    exit(1)

regex = re.compile(r"((:?[\W_\-\. ]|E|OVA)?\d+[\W_\-\. ])")
matches = regex.findall(currentFile)
realMatches = matches
for file in files:
    if file == currentFile: continue

    match: list[str]
    for match in matches:
        if match[0] in file:
            if match in realMatches:
                realMatches.remove(match)
    if len(realMatches) == 1:
        break

numMatch: str = realMatches[0][0]
_ = sys.stdout.write(str(numMatch[1:-1]))
