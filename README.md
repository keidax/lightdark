# lightdark

Switch between macOS Light and Dark mode in iTerm!

![Demo](demo.gif)

While `lightdark` is running, switching the system appearance will change the theme in all open terminals.

Requirements:
- iTerm2
- [Base16 Shell](https://github.com/chriskempson/base16-shell)

Inspiration: https://github.com/sindresorhus/swift-snippets/tree/master/DarkMode.playground

Works well with [Shifty](https://github.com/thompsonate/Shifty)

## Installation

lightdark requires crystal: `brew install crystal`

Then, clone this repository:

```bash
git clone https://github.com/keidax/lightdark.git
cd lightdark
```

Build the project:

``` bash
shards build --release
```

And optionally, install the binary somewhere on your PATH:

``` bash
sudo cp ./bin/lightdark /usr/local/bin/lightdark
```

If you want lightdark to automatically start when you log in, create a plist file like this at `~/Library/LaunchAgents/com.github.keidax.lightdark.plist`:

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>EnvironmentVariables</key>
        <dict>
                <key>BASE16_SHELL</key>
                <string>~/.config/base16-shell</string>
        </dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>com.github.keidax.lightdark</string>
        <key>ProgramArguments</key>
        <array>
                <string>/usr/local/bin/lightdark</string>
                <string>serve</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
</dict>
</plist>
```

## Usage

Use `lightdark serve` to run the lightdark daemon.

To configure the themes, use environment variables:

| Variable | Default |
|----------|---------|
| LIGHTDARK_DARK_THEME | gruvbox-dark-hard |
| LIGHTDARK_LIGHT_THEME | one-light |

`lightdark toggle` can be used to switch the system appearance from any terminal, as an alternative to System Preferences.

Use `mesg n` if you want to stop receiving theme changes in a particular terminal.
Use `mesg y` to resume.

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/keidax/lightdark/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Gabriel Holodak](https://github.com/keidax) - creator and maintainer
