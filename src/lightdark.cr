require "commander"

require "./lightdark/*"

def fatal!(error, status = 1)
  STDERR.puts error
  exit(status)
end

module Lightdark
  CLI = Commander::Command.new do |cmd|
    cmd.use = "lightdark"

    cmd.commands.add do |toggle|
      toggle.use = "toggle [light|dark]"
      toggle.short = "Toggle between light and dark mode"
      toggle.long = toggle.short

      toggle.run do |_, arguments|
        if arguments.none?
          Toggle.toggle
        elsif arguments.one?
          Toggle.toggle(arguments.first)
        else
          fatal! "Only one argument to `toggle` allowed!"
        end
      end
    end
    cmd.commands.add do |serve_cmd|
      serve_cmd.use = "serve"

      serve_cmd.flags.add do |flag|
        flag.name = "verbose"
        flag.short = "-v"
        flag.long = "--verbose"
        flag.description = "More verbose output"
        flag.default = false
      end

      serve_cmd.run do |options, _|
        serve(options.bool["verbose"])
      end
    end
  end
end

Commander.run(Lightdark::CLI, ARGV)
