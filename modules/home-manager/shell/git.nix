{pkgs, ...}: {
  programs.git.enable = true;

  programs.gh = with pkgs; {
    enable = true;
    extensions = [gh-dash gh-eco];
    settings.editor = "nvim";
  };
}
