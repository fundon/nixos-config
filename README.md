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

* Modify the shell

```console
chsh -s /run/current-system/sw/bin/fish
```

* List generations

```console
nix-env --list-generations --profile ~/.local/state/nix/profiles/home-manager
```

## Thanks to the following configurations

* [MatthiasBenaets](https://github.com/MatthiasBenaets/nixos-config)
* [Misterio77](https://github.com/Misterio77/nix-config)
* [mitchellh](https://github.com/mitchellh/nixos-config)
* [srid](https://github.com/srid/nixos-config)
