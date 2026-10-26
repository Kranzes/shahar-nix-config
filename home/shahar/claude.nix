{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  programs.claude-code = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    lspServers.nix = {
      command = lib.getExe pkgs.nixd;
      extensionToLanguage.".nix" = "nix";
    };
    settings = {
      model = "opus";
      tui = "fullscreen";
    };
  };
}
