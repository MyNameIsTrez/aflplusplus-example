#!/bin/bash

export AFL_LLVM_LAF_ALL=1

# These are mutually exclusive
# export AFL_HARDEN=1
# TODO: Right now this prints "ld.lld: error: cannot open /usr/lib/llvm-14/lib/clang/14.0.6/lib/linux/libclang_rt.asan_static-x86_64.a: No such file or directory"
# TODO: Might not work well with parallelization "you should only run one afl-fuzz instance per sanitizer type."
# https://github.com/AFLplusplus/AFLplusplus/blob/stable/docs/fuzzing_in_depth.md#c-selecting-sanitizers
export AFL_USE_ASAN=1
export AFL_USE_UBSAN=1

# TODO: Not sure if the DEBUG=1 is necessary for afl
make -C /src DEBUG=1 CTMIN=1 #SAN=1

mkdir -p /src/afl

mkdir -p /src/afl/minimized-tests
rm -rf /src/afl/minimized-tests/*
afl-cmin -i /src/tests -o /src/afl/minimized-tests -- /src/example_ctmin

mkdir -p /src/afl/trimmed-tests
rm -rf /src/afl/trimmed-tests/*
for file in /src/afl/minimized-tests/**; do
afl-tmin -i "$file" -o /src/afl/trimmed-tests/$(basename $file) -- /src/example_ctmin
done

# TODO: Not sure if the DEBUG=1 is necessary for afl
make -C /src DEBUG=1 AFL=1 #SAN=1
