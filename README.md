# YTMP3 Setup

**YTMP3 Setup** is a script designed to simplify the installation and configuration of the [YTMP3-JS] module, which allows downloading and converting YouTube videos to MP3 format. This project is tailored for Linux environments, including Termux on Android devices.

## Features

- **Automatic OS Detection**: Identifies the operating system to choose the appropriate installation method.
- **Node.js Installation**: Checks for Node.js and installs it if necessary, supporting versions 16 and newer.
- **Package Manager Support**: Uses `apt-get` on Linux systems, including Termux.
- **Global Installation**: Installs the [YTMP3-JS] module globally using npm.
- **Dry Run Option**: Provides a `--dry-run` flag for testing the script without making actual changes.

## Requirements

- **Operating System**: Linux (including Termux on Android).
- **Dependencies**: Node.js >= 16.
- **Permissions**: Sufficient permissions to install packages and modify system settings.

## Installation

```bash
curl -s https://raw.githubusercontent.com/mitsuki31/ytmp3-setup/master/setup.sh | bash
```

After installation, use the `ytmp3` command to download and convert YouTube videos to MP3 format.
For a list of options and commands, run:

```bash
ytmp3 -?
```

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.


<!-- Links -->
[YTMP3-JS]: https://npmjs.com/package/ytmp3-js
