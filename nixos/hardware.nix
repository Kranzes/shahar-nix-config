{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  btrfsOpts = [
    "compress=zstd"
    "noatime"
  ];
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # Based on disko's example/luks-btrfs-subvolumes.nix.
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = btrfsOpts;
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = btrfsOpts;
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = btrfsOpts;
                };
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "16G";
                };
              };
            };
          };
        };
      };
    };
  };

  # Generated on the machine with `nixos-facter`, see README.
  hardware.facter.reportPath = lib.mkIf (builtins.pathExists ./facter.json) ./facter.json;

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
      configurationLimit = 4;
      measuredBoot = {
        enable = true;
        pcrs = [
          0
          2
          3
          4
          7
        ];
        autoCryptenroll = {
          enable = true;
          device = "/dev/disk/by-partlabel/disk-main-luks";
          autoReboot = true;
        };
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
    zswap.enable = true;
  };

  hardware.enableAllFirmware = true;

  services.fwupd.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
