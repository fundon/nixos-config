# fundon's NixOS configurations

## Get started

I used [`nix-installer`](https://github.com/DeterminateSystems/nix-installer) to init my setups.

But I modified the original code to support file system `case sensitivity`.

> Because the compilation is in the `/tmp` directory, which is case-sensitive,
> and the original `/nix` is not case-sensitive, when in the `mv` file,
> there will be a problem.

## NixOS

coming soon

## Darwin

### r2d2: iMac Intel

```console
cd ~/.config/nix
nix build .#darwinConfigurations.r2d2.system --show-trace
/result/sw/bin/darwin-rebuild switch --flake .#r2d2 --show-trace
```

### c3po: Apple M1 13 2020

```console
cd ~/.config/nix
nix build .#darwinConfigurations.c3po.system --show-trace
/result/sw/bin/darwin-rebuild switch --flake .#c3po --show-trace
```

### Tips

* If a standalone volume be used. Turns on `auto` option, which is required.

> Because `/et/shells`, `/etc/nix`, ... they are symbolic links. Linking to `/nix/*`.
```
# nix-installer created volume labelled `Nix Store`
UUID=767AB14B-7D53-4F88-9114-4FA344DF73BB /nix apfs rw,auto,nobrowse,suid,owners
```

* Modify the shell

```console
chsh -s /run/current-system/sw/bin/fish
```

* List generations

```console
nix-env --list-generations --profile ~/.local/state/nix/profiles/home-manager
```

* Clean profiles

> See [How to remove NixOS system profile?](https://discourse.nixos.org/t/how-to-remove-a-nixos-system-profile/6317)

```console
$ # print current system profile
$ nix-store --gc --print-roots | grep result
/Users/fundon/.config/nix/result -> /nix/store/m2vnxs3xl1r0iwd7zj2r8kf0jprgw4r2-darwin-system-24.05.20231122.19cbff5+darwin4.4b9b83d

$ # list all profiles
$ ls -la /nix/var/nix/profiles/
$ readlink /nix/var/nix/profiles/system
system-153-link

$ # remove old profiles
$ ./scripts/clean-old-system-profiles.fish

$ nix-store --optimise -vvv
$ nix-collect-garbage -d -vvv
```

* Install `libpq`

> Currently, `libpq` is not a package in `nix`.
> Waiting this PR [#234470](https://github.com/NixOS/nixpkgs/pull/234470).

```console
$ nix-env -iA --file https://github.com/szlend/nixpkgs/archive/libpq.tar.gz libpq -vvv
```

## Thanks to the following configurations

* [MatthiasBenaets](https://github.com/MatthiasBenaets/nixos-config)
* [Misterio77](https://github.com/Misterio77/nix-config)
* [mitchellh](https://github.com/mitchellh/nixos-config)
* [srid](https://github.com/srid/nixos-config)
