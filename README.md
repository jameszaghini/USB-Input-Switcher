# USB Input Switcher
Switch Input Source on macOS based on connected USB device(s)

[![Maintainability](https://api.codeclimate.com/v1/badges/0e5adb784f659346fcba/maintainability)](https://codeclimate.com/github/jameszaghini/USB-Input-Switcher/maintainability)

# What does it do?

When using an external keyboard with a custom layout Colemak/Dvorak you want the Input Source set to US/Australian or whatever.

When unplugging the keyboard, you want it set back to Colemak/Dvorak for the laptop keyboard.

# Install

Download the latest release, edit the example config for your keyboards & inputs sources and then run:
```
chmod +x install.sh
./install.sh
```

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
