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
    cmd.commands.add do |cmd|
      cmd.use = "serve"

      cmd.run do |_, arguments|
        serve(false)
      end
    end
  end
end

Commander.run(Lightdark::CLI, ARGV)
