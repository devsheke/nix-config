{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
    };
  };

  programs.gh = with pkgs; {
    enable = true;
    extensions = [
      gh-dash
      gh-eco
    ];
    settings.editor = "nvim";
  };
}
