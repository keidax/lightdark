require "./theme_setter"

class ShellThemeSetter < ThemeSetter
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

  def set_theme(mode : Mode)
    @zsh.input << "eval base16_#{mode.theme}\n"
  end
end
