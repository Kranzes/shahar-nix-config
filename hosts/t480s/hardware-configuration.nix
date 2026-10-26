{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  device = "/dev/nvme0n1";
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
  ];

  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1G";
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
              settings = {
                allowDiscards = true;
                bypassWorkqueues = true;
                crypttabExtraOpts = [ "tpm2-device=auto" ];
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      configurationLimit = 4; # Max allowed with measured boot.

      # First boot: generate keys, stage them on the ESP and reboot so
      # systemd-boot enrolls them into the firmware (needs Setup Mode).
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };

      measuredBoot = {
        enable = true;
        # PCR 1/2/3 can be flaky; add them once verified on this machine.
        pcrs = [
          0
          4
          7
        ];
        # Second boot (Secure Boot on): swap the bootstrap TPM2 keyslot for
        # one sealed against the systemd-pcrlock policy.
        autoCryptenroll = {
          enable = true;
          inherit (config.boot.initrd.luks.devices.crypted) device;
          autoReboot = true;
        };
      };
    };
    loader.systemd-boot.enable = lib.mkForce (!config.boot.lanzaboote.enable);
    loader.efi.canTouchEfiVariables = true;
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
    zswap.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  services.fwupd.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
