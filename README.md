# PebbleX [![Build Status](https://travis-ci.org/HBehrens/pebblex.png)](https://travis-ci.org/HBehrens/pebblex)[![Gem Version](https://badge.fury.io/rb/pebblex.png)](http://badge.fury.io/rb/pebblex)

A small command line tool to use Xcode and [AppCode][AppCode] as development environment for the [Pebble smartwatch SDK](https://developer.getpebble.com/2/). It's based on the SDK's official `pebble` command that steadily evolves and might contain some of the functionality `pebblex` introduces by itself in the future. Ideally, there will be no need for `pebblex` at some point, anymore.

## Background

The [Pebble SDK](https://developer.getpebble.com/2/) comes with a powerful command line tool `pebble` to create, build and analyze pebble projects.
Unfortunately, there's no development environment for the created project structure.

With the help of `pebblex` you can take advantage of Xcode or [AppCode][AppCode] to develop your Pebble watch faces or apps directly from a convenient IDE.
The command line tool will create a `.xcodeproj` that contains the needed search paths, resources and .c files to start right away. Each time you build your watch app from the IDE, all warnings and errors of the underlying ´pebble build` command will be presented right in the editor.

With [AppCode][AppCode] you can even build, install the `.pbw` to your watch, and look at the live logs as a one-step action directly from your IDE!

## Installation

Install the Ruby Gem:

    sudo gem install pebblex

## Usage

After creating a new pebble project (as described in the [Pebble tutorial](https://developer.getpebble.com/2/getting-started/hello-world/))

    pebble new-project hello_world
    cd hello_world
    
you can easily create an Xcode project file 

    pebblex xcode
    open hello_world.xcodeproj

As part of the project file, `pebblex xcode` will create a target "Pebble" that builds your project right from the IDE. After each build, all warnings and errors will be propagated back right into your editor.

### Optional: AppCode

If you are using [AppCode][AppCode] you can go one step further: `pebblex` allows you to build, deploy and look at the logs directly from the IDE! Make these adjustments to the run configuration to do so:

![alt tag](https://raw.github.com/HBehrens/pebblex/master/images/AppCodeRunConfig.png)

## Contributing

1. Fork it ( https://github.com/HBehrens/pebblex/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make sure to test your changes (`rake spec`)
3. Build and try PebbleX locally (`rake build && rake install`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[AppCode]: http://www.jetbrains.com/objc/
