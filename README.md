# nix-config

NixOS + home-manager flake for a ThinkPad T480s (`t480s`).

- **nixos-unstable**, structured with flake-parts (layout borrowed from
  [Kranzes/nix-config](https://github.com/Kranzes/nix-config))
- **disko**: GPT, 1G ESP, LUKS2 → ext4, swapfile
- **lanzaboote**: Secure Boot keys are generated and enrolled automatically,
  then the LUKS volume is re-sealed to a `systemd-pcrlock` (measured boot) policy
- **Hyprland** (UWSM, Lua config) + **noctalia** shell, regreet login
- **claude-code** from [llm-agents.nix](https://github.com/numtide/llm-agents.nix)

```
flake.nix
hosts/      flake-module.nix wires up nixosConfigurations; one dir per host
profiles/   reusable NixOS modules, exported as nixosModules.profiles-*
home/       home-manager config for shahar
dev/        devShell + treefmt (`nix fmt`)
```

## Fresh install

### 1. Firmware (F1 at boot)

- Update the BIOS first (Thunderbolt firmware ≥ 1.50 avoids the T480s TB3 bug).
- *Security → Security Chip*: enable TPM 2.0.
- *Security → Secure Boot*: **Reset to Setup Mode** and **Clear All Secure Boot
  Keys**. Leave Secure Boot enabled. It stays in Setup Mode until the keys are
  enrolled.
- Boot the NixOS unstable installer ISO from USB. If the firmware won't boot it
  while in Setup Mode, disable Secure Boot for now and turn it back on after
  step 4.

### 2. Partition

```console
$ git clone https://github.com/shaharulo/nix-config && cd nix-config
$ sudo nix --extra-experimental-features 'nix-command flakes' \
    run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#t480s
```

disko asks for the LUKS passphrase. Keep it: it stays as the fallback unlock
method.

### 3. Bootstrap TPM unlock

The automatic measured-boot enrollment needs an existing TPM2 keyslot to unlock
the disk without you. Add a temporary one that isn't bound to any PCRs. It gets
replaced on the second boot:

```console
$ sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs= /dev/disk/by-partlabel/disk-main-luks
$ sudo systemd-cryptenroll --recovery-key /dev/disk/by-partlabel/disk-main-luks  # optional, write it down
```

### 4. Install

```console
$ sudo nixos-install --flake .#t480s --no-root-passwd
$ sudo nixos-enter --root /mnt -c 'passwd shahar'
$ sudo cp -r . /mnt/home/shahar/nix-config && sudo nixos-enter --root /mnt -c 'chown -R shahar:users /home/shahar/nix-config'
$ reboot
```

The first generation is installed unsigned.

### 5. Automatic provisioning (two automatic reboots)

1. **Boot 1:** `generate-sb-keys` creates keys in `/var/lib/sbctl`.
   `prepare-sb-auto-enroll` stages them on the ESP, re-signs everything and
   reboots.
2. **Boot 2:** systemd-boot enrolls the keys and Secure Boot is now enforcing.
   `auto-cryptenroll` wipes the bootstrap TPM2 slot, re-enrolls it against the
   `systemd-pcrlock` policy (PCRs 0, 4, 7) and reboots.
3. **Boot 3:** the disk unlocks only if firmware, Secure Boot state and the
   signed lanzaboote stub match the policy. Every `nixos-rebuild` updates the
   policy automatically.

Check the result:

```console
$ bootctl status | grep 'Secure Boot'      # enabled (user)
$ sbctl status
$ systemd-cryptenroll /dev/disk/by-partlabel/disk-main-luks   # password + tpm2 (+ recovery)
```

If the TPM refuses to unlock (for example after a firmware update), the
passphrase prompt appears and the policy is rebuilt on that boot.

Optional, for attended unlock: add a PIN to the TPM slot with
`systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-with-pin=true --tpm2-pcrlock=/var/lib/systemd/pcrlock.json /dev/disk/by-partlabel/disk-main-luks`.

## Day to day

```console
$ nixos-rebuild switch --flake ~/nix-config#t480s --elevate=run0
$ nix flake update && nix fmt
```

`sudo` is replaced with `run0`, and a `sudo` shim is kept. Keybinds are in
`home/shahar/hyprland.nix`. `SUPER+Space` opens the launcher, `SUPER+comma`
opens noctalia settings and `SUPER+Return` opens a terminal.
