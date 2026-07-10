#!/usr/bin/env fish
# Deploy and install this nixos system.

function main
    argparse 'flake=' 'user=' 'host=' 'dest=' 'root=' -- $argv; or exit 1

    set -l root_dir "/"
    set -q _flag_root; and set root_dir $_flag_root
    
    set -l flake "/etc/dotfiles"
    set -q _flag_flake; and set flake $_flag_flake
    
    set -l host "Saber"
    set -q _flag_host; and set host $_flag_host
    
    set -l user "gold3n"
    set -q _flag_user; and set user $_flag_user
    
    set -l dest "$root_dir/home/$user/.config/dotfiles"
    set -q _flag_dest; and set dest $_flag_dest

    if test "$USER" = "nixos"
        echo "Error: not in the nixos installer" >&2
        exit 1
    else if test -z "$host"
        echo "Error: no --host set" >&2
        exit 2
    end
    
    if not test -d "$flake"
        set -l url "https://github.com/gold3n/dotfiles"
        test "$user" = "gold3n"; and set url "git@github.com:gold3n/dotfiles.git"
        rm -rf "$flake"
        git clone --recursive "$url" "$flake"
    end
    
    set -x HEYENV "{\"user\":\"$user\",\"host\":\"$host\",\"path\":\"$flake\",\"theme\":\"$THEME\"}"
    nixos-install \
        --impure \
        --show-trace \
        --root "$root_dir" \
        --flake "$root_dir$flake#$host"
end

main $argv
