{pkgs, ...}: {
  programs.git = {
    enable = true;
    userEmail = "abhi@sheke.tech";
    userName = "devsheke";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.gh = with pkgs; {
    enable = true;
    extensions = [gh-dash gh-eco];
    settings.editor = "nvim";
  };
}
