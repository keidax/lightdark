module Lightdark::Toggle
  def self.toggle
    set_dark_mode("not dark mode")
  end

  def self.toggle(string)
    case string
    when /light/i
      set_dark_mode("false")
    when /dark/i
      set_dark_mode("true")
    else
      fatal! "Argument to `toggle` should be 'light' or 'dark'!"
    end
  end

  private def self.set_dark_mode(mode)
    script = %(tell application "System Events" to tell appearance preferences to set dark mode to #{mode})

    proc = Process.run("osascript", ["-e", script])
    unless proc.success?
      fatal! "osascript failed with exit code #{proc.exit_code}"
    end
  end
end
