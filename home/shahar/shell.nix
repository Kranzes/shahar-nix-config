{ pkgs, config, ... }:

{
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.bat = {
    enable = true;
    config.paging = "never";
  };

  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.ignoreDups = true;
    initContent = ''
      setopt PROMPT_SUBST INTERACTIVE_COMMENTS
      source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh
      PROMPT='[%n@%m %~]%(!.#.$)$(__git_ps1) '
      zstyle ':completion:*' menu select
    '';
    shellAliases = {
      rm = "rm -I";
      mv = "mv -i";
      ls = "ls --group-directories-first --color=auto";
      cat = "bat";
    };
  };
}
