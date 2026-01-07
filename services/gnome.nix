{ pkgs, vars, ... }:
{
  services = {
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = vars.username;
      };
    };
    desktopManager.gnome.enable = true;
    gnome = {
      core-apps.enable = true;
      core-developer-tools.enable = false;
      games.enable = false;
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];
}
