abstract class ThemeSetter
  abstract def set_theme(theme : String)
end

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

  def set_theme(theme : String)
    @zsh.input << "eval base16_#{theme}\n"
  end
end
