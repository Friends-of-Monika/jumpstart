# Jumpstart
A convenient toolkit for rapidly setting up dev install for the
[Monika After Story](https://github.com/Monika-After-Story/MonikaModDev)
mod development.

## Usage
### Getting started
Download `jumpstart.sh` script file and save it somewhere:

```shell
$ curl -o jumpstart https://raw.githubusercontent.com/Friends-of-Monika/jumpstart/master/jumpstart.sh
```

Optionally, you can add it to `/usr/bin` (or any other location that is on $PATH.)

In further examples, it is assumed that `jumpstart.sh` is saved as `jumpstart`
(no `.sh` extension) in current working directory.

### Installing MAS
Jumpstart provides a fully automatic way to install MAS to DDLC with `install` command:

```shell
$ ./jumpstart install <existing DDLC install>
```

By default, the script will download the most recent stable release.
If a Deluxe (spritepacks included) version is available within this release,
you'll be prompted if you'd like to install it instead of the default distribution.

### Configuring dev install
With Jumpstart you can convert MAS install into dev install within just few <kbd>Enter</kbd> hits:

```shell
$ ./jumpstart dev <MAS install>
```

You'll be asked if you'd like to enable console, install expressions previewer or import
existing MAS persistent into dev install.
