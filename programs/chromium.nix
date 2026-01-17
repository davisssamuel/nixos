{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    chromium
    # ungoogled-chromium
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    ];
  };
}
