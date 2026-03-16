# CS2 Retakes Installer

Simple installer for a Counter-Strike 2 retakes server using LinuxGSM, Metamod, and CounterStrikeSharp.

The script installs the server, dependencies, and plugins automatically.

## Install

Run the installer with:

```
git clone https://github.com/swastik-satpathy/cs2-retakes.git
cd cs2-retakes
chmod +x install.sh
./install.sh
```

## What it installs

* LinuxGSM
* Counter-Strike 2 server
* Metamod
* CounterStrikeSharp
* Plugins defined in `plugins.json`

## Plugins

Plugins are defined in `plugins.json`. Each plugin entry requires:
- `url`: Direct download link to the plugin zip file
- `enabled`: Boolean to enable/disable the plugin
- `copyPaths`: Array of copy operations to extract and place files

Example:

```json
{
  "retakes": {
    "url": "https://github.com/B3none/cs2-retakes/releases/download/3.0.3/RetakesPlugin-3.0.3.zip",
    "enabled": true,
    "copyPaths": [
      { "from": "plugins", "to": "addons/counterstrikesharp/plugins" },
      { "from": "shared", "to": "csgo/addons/counterstrikesharp/plugins/shared" }
    ]
  }
}
```

To manage plugins:
- Edit `plugins.json` to add, remove, or modify plugins
- Set `"enabled": true` or `"enabled": false` to control which plugins are installed
- Update `copyPaths` to specify where files should be extracted from the zip and placed in the server directory
- Rerun the installer to apply changes

## Server location

Server files are installed in:

```
/home/cs2server/serverfiles
```

## Managing the server

Switch to the server user:

```
su - cs2server
```

Start the server:

```
./cs2server start
```

Restart the server:

```
./cs2server restart
```

View console:

```
./cs2server console
```

## Notes

Running the installer again will repair an existing installation and skip components that are already installed.
