# Compiling from source

The project requires [Nix](https://nixos.org/) for deterministic, reproducible builds.  You must install nix in order to build from source.

## Entering the nix development environment

Use the following command to enter a nix development environment which will provided the required dependencies:
```
nix develop
```

## Build the project using nix

Use the following command to build the project (builds orc-gui, orc-cli and encode-orc):

```
nix build
```

## Running the GUI application

Use the following command to run the orc-gui application:

```
nix run .#orc-gui
```