require "./theme_setter"

class VimThemeSetter < ThemeSetter
  @file : File

  def initialize
    @file = File.open(Path["~/vim_pipe.txt"].expand, "w")
  end

  def set_theme(mode : Mode)
    @file.puts(mode.to_s.downcase)
    @file.puts("base16-#{mode.theme}")
    @file.flush
  end
end
