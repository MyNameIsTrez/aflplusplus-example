# aflplusplus-example

# Booting the C fuzzing Docker file

1. `cd c`
2. Run `docker build -t aflplusplus-example . && docker run --rm -it -v .:/src aflplusplus-example` to build and run docker with

# Booting the C++ fuzzing Docker file

1. `cd cpp`
2. Run `docker build -t aflplusplus-example fuzzing && docker run --rm -it -v .:/src aflplusplus-example` to build and run docker with

# Fuzzing

3. Run `setup.sh` to compile for afl-cmin + afl-tmin, generate tests, and compile for AFL
4. Run `coverage.sh` to fuzz while generating coverage
5. Run `minimize_crashes.sh` to minimize the crashes, which are then put in `/src/fuzzing/afl/minimized-crashes/`

The `Coverage Gutters` VS Code extension shows it inline, or you can view the coverage information in your browser by opening `afl/afl-output/master/cov/web/index.html`

Note that you'll want to run `coverage.sh` a few times, as the random search nature of afl++ can cause it to find something instantly that would've taken forever otherwise.

# Extra commands

## Fuzz without generating coverage
`fuzz.sh`

## Analyze crash 0 by checking what the program printed and what signal killed the program
`< /src/afl/minimized-crashes/0 afl-showmap -o /dev/null -- /src/example_ctmin`

## Analyze crash 0 by coloring its characters based on relevancy
This isn't working properly for some reason, and it's giving different results every time you run it:

`afl-analyze -i /src/afl/minimized-crashes/0 -- /src/example_ctmin`
