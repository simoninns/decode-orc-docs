# Installation Guide

This guide covers how to install **Decode Orc** on Windows, macOS, and Linux systems.

## Windows Installation

### Download

1. Go to the [latest release page](https://github.com/simoninns/decode-orc/releases/latest)
2. Download the file named `decode-orc-X.X.X-windows-x64.zip` (where X.X.X is the version number)

### Installation Steps

1. **Extract the ZIP archive**
   - Right-click the downloaded ZIP file
   - Select "Extract All..."
   - Choose a destination folder (e.g., `C:\Program Files\decode-orc`)

2. **Run the application**
   - Navigate to the extracted folder
   - Double-click `orc-gui.exe` to launch the graphical interface
   - Or use `orc-cli.exe` from the Command Prompt for command-line interface

### Using the Command Line Tool

To use `orc-cli` from anywhere in Command Prompt or PowerShell:

1. Add the installation folder to your system PATH:
   - Press `Win + X` and select "System"
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Under "System variables", find and select "Path", then click "Edit"
   - Click "New" and add the path to your decode-orc folder
   - Click "OK" to save

2. You can now run `orc-cli` from any command prompt

### Notes

- This is a portable build - all required DLLs and Qt dependencies are included
- No installation or registry modifications are required
- You can move the folder to any location on your system
- To uninstall, simply delete the folder

---

## macOS Installation

### Download

1. Go to the [latest release page](https://github.com/simoninns/decode-orc/releases/latest)
2. Download the file named `decode-orc-X.X.X-macOS.dmg` (where X.X.X is the version number)

### Installation Steps

1. **Open the DMG file**
   - Double-click the downloaded DMG file
   - A Finder window will open showing the Decode Orc installer

2. **Install the application**
   - Drag the `orc-gui` app to the Applications folder (you can use the shortcut provided in the DMG)
   - Wait for the copy to complete

3. **First launch (security)**
   - Navigate to Applications in Finder
   - **Right-click** (or Control-click) on `orc-gui` and select "Open"
   - Click "Open" in the security dialog that appears
   - After the first launch, you can double-click normally to open the app

### Installing the Command Line Tool (Optional)

The DMG includes a script to install the `orc-cli` command-line tool:

1. **Run the installer script**
   - In the DMG window, double-click "Install CLI Tool"
   - Enter your administrator password when prompted
   - The script will create a symlink in `/usr/local/bin/orc-cli`

2. **Verify installation**
   - Open Terminal
   - Type `orc-cli --version` to verify the installation

### Uninstallation

To remove Decode Orc from your system:

1. **Remove the application**
   - Delete `orc-gui.app` from your Applications folder

2. **Remove CLI tool (if installed)**
   - Open Terminal
   - Run: `sudo rm /usr/local/bin/orc-cli`

---

## Linux Installation (Flatpak)

### Prerequisites

Flatpak must be installed on your system. If you don't have it:

**Ubuntu/Debian:**
```bash
sudo apt install flatpak
```

**Fedora:**
```bash
sudo dnf install flatpak
```

**Arch Linux:**
```bash
sudo pacman -S flatpak
```

### Download

1. Go to the [latest release page](https://github.com/simoninns/decode-orc/releases/latest)
2. Download the file named `decode-orc-X.X.X.flatpak` (where X.X.X is the version number)

### Installation Steps

1. **Install the Flatpak bundle**
   ```bash
   flatpak install --user decode-orc-X.X.X.flatpak
   ```
   
   Replace `X.X.X` with your downloaded version number.

2. **Grant necessary permissions (if needed)**
   
   If you need access to specific directories:
   ```bash
   flatpak override --user --filesystem=home io.github.simoninns.decode-orc
   ```

### Running the Application

**Graphical Interface:**
- Look for "Decode Orc" in your application menu
- Or run from terminal:
  ```bash
  flatpak run io.github.simoninns.decode-orc
  ```

**Command Line Interface:**
```bash
flatpak run --command=orc-cli io.github.simoninns.decode-orc
```

### Creating Shell Aliases (Optional)

For easier command-line access, add these aliases to your `~/.bashrc` or `~/.zshrc`:

```bash
alias orc-gui='flatpak run io.github.simoninns.decode-orc'
alias orc-cli='flatpak run --command=orc-cli io.github.simoninns.decode-orc'
```

After adding these, run `source ~/.bashrc` (or `~/.zshrc`) to apply the changes.

### Uninstallation

To remove Decode Orc:

```bash
flatpak uninstall io.github.simoninns.decode-orc
```

---

## System Requirements

### All Platforms

- **Processor:** 64-bit x86 processor
- **Memory:** 4 GB RAM minimum (8 GB or more recommended for large files)
- **Display:** 1280x720 minimum resolution

### Windows

- **Operating System:** Windows 10 or later (64-bit)
- **Graphics:** DirectX 11 compatible graphics card

### macOS

- **Operating System:** macOS 11.0 (Big Sur) or later
- **Architecture:** Intel 64-bit or Apple Silicon (M1/M2/M3)

### Linux

- **Flatpak:** Version 1.12 or later
- **Graphics:** OpenGL 3.3 or later support
- **Desktop Environment:** Any modern Linux desktop environment (GNOME, KDE, XFCE, etc.)

---

## Troubleshooting

### Windows

**Problem:** "Windows protected your PC" message appears

**Solution:** 
- Click "More info"
- Click "Run anyway"
- This is expected for unsigned applications

**Problem:** Application won't start or shows missing DLL errors

**Solution:**
- Ensure you've extracted all files from the ZIP archive
- Install the latest [Visual C++ Redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe)

### macOS

**Problem:** "App is damaged and can't be opened" error

**Solution:**
- This typically happens if you didn't use "Right-click > Open" for the first launch
- Open Terminal and run:
  ```bash
  xattr -cr /Applications/orc-gui.app
  ```
- Then try "Right-click > Open" again

**Problem:** CLI tool not found after installation

**Solution:**
- Make sure you ran the "Install CLI Tool" script from the DMG
- Check that `/usr/local/bin` is in your PATH:
  ```bash
  echo $PATH | grep "/usr/local/bin"
  ```
- If not found, add it to your `~/.zshrc` or `~/.bash_profile`:
  ```bash
  export PATH="/usr/local/bin:$PATH"
  ```

### Linux (Flatpak)

**Problem:** Application won't start or crashes

**Solution:**
- Update Flatpak runtime:
  ```bash
  flatpak update
  ```
- Check Flatpak version compatibility:
  ```bash
  flatpak --version
  ```

**Problem:** Can't access files in certain directories

**Solution:**
- Grant filesystem access:
  ```bash
  flatpak override --user --filesystem=/path/to/directory io.github.simoninns.decode-orc
  ```
- Or use Flatseal (graphical permissions manager):
  ```bash
  flatpak install flatseal
  flatpak run com.github.tchx84.Flatseal
  ```

**Problem:** Command not found when using aliases

**Solution:**
- Ensure you've reloaded your shell configuration:
  ```bash
  source ~/.bashrc  # or ~/.zshrc
  ```
- Or open a new terminal window

---

## Getting Help

If you encounter issues not covered in this guide:

1. Check the [project documentation](https://simoninns.github.io/decode-orc-docs/index.html)
2. Search existing [GitHub Issues](https://github.com/simoninns/decode-orc/issues)
3. Create a new issue with:
   - Your operating system and version
   - Decode Orc version
   - Steps to reproduce the problem
   - Any error messages or logs

---

## Next Steps

After installation, refer to the [user documentation](https://simoninns.github.io/decode-orc-docs/index.html) to learn how to use Decode Orc for your LaserDisc and tape decoding workflows.
