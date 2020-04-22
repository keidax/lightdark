require "./theme_setter"

class TTYThemeSetter < ThemeSetter
  @zsh : Process
  @theme_data = Hash(Mode, String).new

  def initialize
    @zsh = Process.new("zsh", ["-s", "--no-interactive", "--no-login"],
      input: Process::Redirect::Pipe,
      output: Process::Redirect::Pipe,
      error: Process::Redirect::Inherit,
    )
    @zsh.input << %(eval "$($DOTDIR/base16/base16-shell/profile_helper.sh)"\n)

    sleep 0.5

    @zsh.output.read_timeout = 0.5
    mode_data = @zsh.output.read_all_available

    Mode.each do |mode|
      @zsh.input << "eval base16_#{mode.theme}\n"
      mode_data = @zsh.output.read_all_available
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

    @zsh.input << "eval base16_#{mode.theme}\n"
    bytes = @zsh.output.read_all_available.size
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

module IO::Evented
  # Requires read_timeout to be set
  def read_all_available : String
    slice = Bytes.new(512)

    String.build do |str|
      loop do
        read_bytes = self.read(slice)
        str.write slice[0, read_bytes]
      end
    rescue IO::TimeoutError
      # puts "rescued"
    end
  end
end
