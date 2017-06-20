# Inform

The inform project is a simple C library to provide a suite of information theoretic measures. It has (at the moment) a three-teir structure:

1. **Distributions** represent heuristic (or possibly _a priori_) probability distributions, and form the basis for all of the core information computations.
2. **Entropy measures** are the basic information theoretic tools, and are defined on distributions.
3. **Time series measures** use distributions and entropy measures to provided such information theoretic constructs as _active information_ and _transfer entropy_.

## Building

To build the project, you will need to have [CMake](https://cmake.org) installed. For most systems you can use your package manager, e.g. `apt-get` or `pacman` on Linux or `homebrew`, `macports` or `fink` on OS X.

Once CMake is installed, build the library, run the tests and install!

    $ cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release
    $ make -C build all test
    $ sudo make -C build install

It is that simple!

## System Support

All three major operating systems are now supported. Inform has been tested on the following platforms:

- Debian 8 (gcc and clang)
- Mac OSX 10.11 (El Capitan)
- Windows 10 (MSVC 2015)

## Related Projects

Wrappers in the following languages are currently under active development:
- Python ([PyInform](https://github.com/elife-asu/pyinform))
- Julia ([Inform.jl](https://github.com/elife-asu/Inform.jl))
- Wolfram Language/Mathematica ([InformWolfram](https://github.com/dglmoore/InformWolfram))

Inform is still under heavy development. As such, the API and the feature set are rapidly changing. Below are a few alternative projects that are currently more mature, more stable and provide more features:
- [JIDT](https://github.com/jlizier/jidt)
- [DIT](https://github.com/dit/dit)


## Build Status
- Linux/OSX: [![Build Status](https://travis-ci.org/ELIFE-ASU/Inform.svg?branch=master)](https://travis-ci.org/ELIFE-ASU/Inform)
- Windows: [![Build Status](https://ci.appveyor.com/api/projects/status/7y015h6p7n0q7097/branch/master?svg=true)](https://ci.appveyor.com/project/dglmoore/inform-vx977)
- Code Coverage: **Coming Soon**
