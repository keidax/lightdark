DARK_THEME  = "gruvbox-dark-hard"
LIGHT_THEME = "one-light"

enum Mode
  Dark
  Light

  def theme
    case self
    when .dark?  then DARK_THEME
    when .light? then LIGHT_THEME
    else              raise "unknown mode #{self}"
    end
  end
end
