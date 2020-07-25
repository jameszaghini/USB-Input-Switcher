# USB Input Switcher
Switch Input Source on macOS based on connected USB device(s)

[![Maintainability](https://api.codeclimate.com/v1/badges/0e5adb784f659346fcba/maintainability)](https://codeclimate.com/github/jameszaghini/USB-Input-Switcher/maintainability)

# What does it do?

When using an external keyboard with a custom layout Colemak/Dvorak you want the Input Source set to US/Australian or whatever.

When unplugging the keyboard, you want it set back to Colemak/Dvorak for the laptop keyboard.

# Install

Run this with your keyboard plugged in to get it's name
`ioreg -p IOUSB -w0 | sed 's/[^o]*o //; s/@.*$//' | grep -v '^Root.*'`

Download the latest release, edit `example.config.yaml` and add your keyboard's name & add input sources and then run:

```
chmod +x install.sh
./install.sh
```

USBInputSwitcher will run at launch.

If you edit the config file at `~/.usbinputswitcher/config.yaml`, it will require a restart to take effect

## Config file

`disconnected` is the _Input Source_ selected when the external keyboard is disconnected
`connected` is a list of USB keyboards with the _Input Source_ to activate when the keyboard is connected 

```yaml
inputSourceNames:
  disconnected: "Colemak"
  connected: "Australian"
usbDeviceNames:
- "Preonic"
- "Planck"
```
