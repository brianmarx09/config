# Minimalist performance-oriented configs for Linux, OS X, Windows, and various apps

This repository holds (what I hope are) useful config files that you can bring into your own dev cycle in whole or part.
I'd appreciate credit, but it's not necessary. I'm just sharing time-saving tricks and shortcuts from different systems I work on.

These are stripped down versions of my personal configs that are missing personal login info and more complex commands I haven't had time to document or provide the dependency list for.

They are commented and provide wrappers and augmented functionality to a raw OS; they are not intended to perform complex tasks.

Currently, only the Linux configs are committed in a usable state.
I intend to continue updating this repo as I develop on each OS, so these files will be staying current for some time.

## Linux

Quickest setup:
 
  - Save the [.bash_aliases](https://github.com/entangledloops/config/blob/master/linux/.bash_aliases) file into your home directory.
  - Open a terminal anywhere and type: `source ~/.bash_aliases && setup`

On a clean LUbuntu 16.04.x system, they should be drag-and-drop to install in your home directory with minor exception.

Specifically, you must move the files in .bak/* into their correspondingly named subdirs of your root installation. An example is the ask-trash-empty script, which goes in `/usr/local/bin`, and therefore you will find it in `.bak/usr/local/bin` here. This particular script adds an "Empty Trash" context item to the trash icon on your desktop.

Read through the [.bash_aliases](https://github.com/entangledloops/config/blob/master/linux/.bash_aliases) source for a good example of what is offered to you. Note that some common dependencies may currently be absent from the alias `deps` defined therein, but you can use the provided `pkg` command to locate the source of any missing packages.
