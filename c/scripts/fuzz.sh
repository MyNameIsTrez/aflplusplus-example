#!/bin/bash

# export AFL_AUTORESUME=1

# -D enables fuzzing strategies "bit flips", "byte flips", "arithmetics", "known ints", "dictionary", "eff"; you may want to omit this optional flag
# According to the --help page: "-D: enable deterministic fuzzing (once per queue entry)", which is strange, since it doesn't mention the enabled fuzzing strategies
afl-fuzz -D -i /src/afl/trimmed-tests -o /src/afl/afl-output -M master -- /src/example_afl
