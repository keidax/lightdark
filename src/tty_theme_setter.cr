require "./theme_setter"

# TODO: consider tmux as well
class TTYThemeSetter < ThemeSetter
  @zsh : Process
  @theme_data = Hash(Mode, String).new

  def initialize
    # Set up necessary environment variables.
    base16_shell = ENV["BASE16_SHELL"]? || "~/.config/base16-shell"
    base16_shell_path = Path[base16_shell].expand(home: true)
    unless File.directory?(base16_shell_path)
      raise "Could not find base16-shell files! Please set the BASE16_SHELL environment variable."
    end

    # Provide a fake value if started outside of iTerm.
    # Necessary so the base16-shell scripts use the right escape sequences.
    iterm_session_id = ENV["ITERM_SESSION_ID"]? || "w0t0p0"

    # Start a ZSH coprocess to load escape sequences.
    @zsh = Process.new("zsh", ["-s", "--no-interactive", "--no-login"],
      input: Process::Redirect::Pipe,
      output: Process::Redirect::Pipe,
      error: Process::Redirect::Inherit,
      env: {
        "BASE16_SHELL"     => base16_shell_path.to_s,
        "ITERM_SESSION_ID" => iterm_session_id,
      }
    )
    @zsh.input << %(eval "$($BASE16_SHELL/profile_helper.sh)"\necho\n)

    # Loading the profile helper will output colors, but we don't know which
    # ones, so just throw them away.
    @zsh.output.read_line

    # We want to make sure that the active mode is evaluated _last_.
    # Otherwise, when starting a new terminal, the colors might be wrong.
    modes = case Mode.current
            when .dark?
              [Mode::Light, Mode::Dark]
            else
              [Mode::Dark, Mode::Light]
            end

    modes.each do |mode|
      @zsh.input << "eval base16_#{mode.theme}\necho\n"
      mode_data = @zsh.output.read_line
      @theme_data[mode] = mode_data
    end
  end

  def set_theme(mode : Mode)
    active_ttys.each do |tty_path|
      spawn do
        File.open(tty_path, mode: "wb") do |file|
          file << @theme_data[mode]
          file.flush
        end
      end
    end
    Fiber.yield

    # Make sure the theme is set for new terminals
    @zsh.input << "eval base16_#{mode.theme}\necho\n"
    @zsh.output.read_line
  end

  private def active_ttys : Enumerable(Path)
    ttys = `who -T`.each_line.compact_map do |line|
      md = line.match(/.* (?<writable>[-+]) (?<tty>[a-z0-9]+)/).not_nil!
      next unless md["writable"] == "+"
      md["tty"]
    end

    ttys.map do |tty|
      Path["/dev/#{tty}"]
    end.select do |path|
      File.writable?(path)
    end.to_a
  end
end
