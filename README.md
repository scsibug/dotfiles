There are some items that need to be done manually, described below.

# Install Fonts

Install FiraCode-Regular-Symbol:

see https://github.com/tonsky/FiraCode/issues/211#issuecomment-239058632


# Install Icons

----
M-x all-the-icons-install-fonts
----

# Install Rust Analyzer

----
$ rustup component add rust-analyzer
$ RA=$(rustup which --toolchain stable rust-analyzer)
$ ln -s $RA ~/.cargo/bin
----

# Install Starship

----
cargo install starship --locked
----

Add the following to zshrc:

----
eval "$(starship init zsh)"
----

# Install FZF/Ripgrep

Counsel has integrations that use fzf and rg.

## OS X

----
brew install rg fzf
----

## Linux

----
dnf install rg fzf
----
