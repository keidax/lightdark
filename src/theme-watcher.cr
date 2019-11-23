require "hoop"
require "./ns_extensions"

DARK_THEME = "gruvbox-dark-hard"
LIGHT_THEME = "one-light"


class ShellWriter
  @zsh : Process

  def initialize
    pipe_file = File.open(Path["~/color_pipe.txt"].expand, "wb")
    @zsh = Process.new("zsh", ["-s"],
                       input: Process::Redirect::Pipe,
                       output: pipe_file,
                       error: Process::Redirect::Inherit,
                      )
    @zsh.input << %(eval "$($DOTDIR/base16/base16-shell/profile_helper.sh)"\n)
  end

  def write_theme(theme : String)
    @zsh.input << "eval base16_#{theme}\n"
  end
end

class ThemeHandler < NSObject
  @writer = ShellWriter.new

  export_class
  action "theme_changed", "notice", "themeChanged:" do
    # notification = NSNotification.new(notice)

    case current_theme
    when /light/i
      # 🌝 🌞 🌕 🌙 🌜
      puts("🌕 #{LIGHT_THEME}")
      @writer.write_theme(LIGHT_THEME)
    when /dark/i
      # 🌚 🌑
      puts("🌑 #{DARK_THEME}")
      @writer.write_theme(DARK_THEME)
    else
      puts("💀 #{current_theme}")
    end
  end

  def current_theme : String
    NSUserDefaults.standard_user_defaults.string_for_key("AppleInterfaceStyle").with_default("Light")
  end
end

handler = ThemeHandler.new.to_objc
dnc = NSDistributedNotificationCenter.default_center
dnc.add_observer(handler, "themeChanged:", "AppleInterfaceThemeChangedNotification", nil)

puts "running"
NSApp.run
puts "done"
