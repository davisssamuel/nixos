{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    curl
    git
    stow
    tree
    vim
    wget
  ];
}
