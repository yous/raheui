# Raheui

[![Gem Version](https://badge.fury.io/rb/raheui.svg)](http://badge.fury.io/rb/raheui)
[![Build Status](https://travis-ci.org/yous/raheui.svg?branch=master)](https://travis-ci.org/yous/raheui)
[![Dependency Status](https://gemnasium.com/yous/raheui.svg)](https://gemnasium.com/yous/raheui)
[![Code Climate](https://codeclimate.com/github/yous/raheui/badges/gpa.svg)](https://codeclimate.com/github/yous/raheui)
[![Coverage Status](https://img.shields.io/coveralls/yous/raheui.svg)](https://coveralls.io/r/yous/raheui)
[![Inline docs](http://inch-ci.org/github/yous/raheui.svg?branch=master)](http://inch-ci.org/github/yous/raheui)
[![raheui API Documentation](https://www.omniref.com/ruby/gems/raheui.png)](https://www.omniref.com/ruby/gems/raheui)

[Aheui][] interpreter in Ruby.

[Aheui]: http://aheui.github.io

## Installation

``` sh
gem install raheui
```

## Usage

Pass `raheui` a file to execute:

``` sh
raheui helloworld.aheui
```

Alternatively you can run `raheui` with no arguments to pass aheui code through terminal input.

``` sh
raheui
```

For additional command-line options:

``` sh
raheui -h
```

Command flag    | Description
----------------|--------------------
`-h, --help`    | Print this message.
`-v, --version` | Print version.

## Commit message in Aheui

Why don't you just try:

``` sh
git log --format=%b -n 1 d176df4 | raheui
```

Also it works for every commit hash in `d176df4..5a6bfd0`:

``` sh
git log --format=%b -n 1 <commit> | raheui
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

Copyright (c) 2014-2015 ChaYoung You. See [LICENSE.txt](LICENSE.txt) for details.
