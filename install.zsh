#!/usr/bin/env zsh
# Deploy and install this nixos system.

function main() {
  zparseopts -E -D -F -- -flake:=flake -user:=user -host:=host -dest:=dest -root:=root || exit 1

  local root="${${root[2]}:-/}"
  local flake="${${flake[2]}:-/etc/dotfiles}"
  local host="${${host[2]}:-Saber}"
  local user="${${user[2]}:-gold3n}"
  local dest="${dest[2]:-$root/home/$user/.config/dotfiles}"

  if [[ "$USER" == nixos ]]; then
    >&2 echo "Error: not in the nixos installer"
    exit 1
  elif [[ -z "$host" ]]; then
    >&2 echo "Error: no --host set"
    exit 2
  fi
  
  if [[ ! -d "$flake" ]]; then
    local url=https://github.com/gold3n/dotfiles
    [[ "$user" == gold3n ]] && url="git@github.com:gold3n/dotfiles.git"
    rm -rf "$flake"
    git clone --recursive "$url" "$flake"
  fi
  
  export HEYENV="{\"user\":\"$user\",\"host\":\"$host\",\"path\":\"$flake\",\"theme\":\"$THEME\"}"
  nixos-install \
      --impure \
      --show-trace \
      --root "$root" \
      --flake "${root}${flake}#${host}"
}

set -e
main $*
