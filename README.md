# PebbleX

A small command line tool to add functionality the `pebble` command is missing right now.
Ideally, there will be no need for `pebblex` in the future, anymore.

## Background

The [Pebble SDK](https://developer.getpebble.com/2/) comes with a powerful command line tool `pebble` to create, build and analyze pebble projects.
Unfortunately, there's no development environment for the created project structure.

With the help of `pebblex` you can take advantage of Xcode or AppCode to develop your Pebble watch faces or apps directly from a convenient IDE.
The command line tool will create a `.xcodeproj` that contains the needed search paths, resources and .c files to start right away.
In future versions, it will also add a build target to build and install your `.pbw` files as a one-step action.

## Installation

Install the Ruby Gem:

    sudo gem install pebblex

## Usage

Go to your pebble project's directly and run

    pebblex xcode

To create a project file that can be opened by Xcode or AppCode to ease your development.

## Contributing

1. Fork it ( https://github.com/HBehrens/pebblex/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Build and test PebbleX locally (`gem build pebblex.gemspec && gem install pebblex-<version>.gem`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
