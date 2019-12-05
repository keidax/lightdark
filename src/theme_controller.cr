require "./*"

class ThemeController
  @@setters : Array(ThemeSetter) = [] of ThemeSetter

  def self.register(setter)
    @@setters << setter
  end

  def self.set_theme(mode : Mode)
    @@setters.each &.set_theme(mode)
  end
end
