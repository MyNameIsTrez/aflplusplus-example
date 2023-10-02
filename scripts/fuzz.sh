#!/bin/bash

# export AFL_AUTORESUME=1

afl-fuzz -i /src/afl/trimmed-scenes -o /src/afl/afl-output -M master -- /src/miniRT
