{ pkgs, ... }:

{

# FONTS

    fonts = {

    packages = with pkgs; [
    nerdfonts
    font-awesome
  ];

    enableDefaultPackages = true;

    fontconfig = {
      enable = true;
      hinting.enable = true;
#     hinting.autohint = false;
      hinting.style = "full";
      subpixel.lcdfilter = "legacy";
      subpixel.rgba = "rgb";
      antialias = true;
    };
  };
}
