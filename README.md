# fundon's NixOS configurations

## Darwin

### r2d2: iMac Intel

```console
cd ~/.config/nix
$ nix build .#darwinConfigurations.r2d2.system --show-trace
$ /result/sw/bin/darwin-rebuild switch --flake .#r2d2 --show-trace
```

### c3po: Apple M1 13 2020

```console
cd ~/.config/nix
$ nix build .#darwinConfigurations.c3po.system --show-trace
$ /result/sw/bin/darwin-rebuild switch --flake .#c3po --show-trace
```

## Thanks to the following configurations

* [MatthiasBenaets](https://github.com/MatthiasBenaets/nixos-config)
* [mitchellh](https://github.com/mitchellh/nixos-config)
* [srid](https://github.com/srid/nixos-config)
