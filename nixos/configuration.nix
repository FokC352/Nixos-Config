# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t14>
      ./hardware-configuration.nix
      ./hyprland.nix
      ./os.nix
    ];

  hardware.graphics = {
	enable = true;
	extraPackages = with pkgs; [

	vpl-gpu-rt
	];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.firmware = [
    (
      let
        model = "37xx";
        version = "0.0";

        firmware = pkgs.fetchurl {
          url = "https://github.com/intel/linux-npu-driver/raw/v1.2.0/firmware/bin/vpu_${model}_v${version}.bin";
          hash = "sha256-qGhLLiBnOlmF/BEIGC7DEPjfgdLCaMe7mWEtM9uK1mo=";
        };
      in
      pkgs.runCommand "intel-vpu-firmware-${model}-${version}" { } ''
        mkdir -p "$out/lib/firmware/intel/vpu"
        cp '${firmware}' "$out/lib/firmware/intel/vpu/vpu_${model}_v${version}.bin"
      ''
    )
  ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.kernelPackages = pkgs.linuxPackages_latest;


  networking.hostName = "T14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager = {
	sddm.wayland.enable = true;
	defaultSession = "hyprland";
	sddm.enableHidpi = true;
  };

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Fingerprint
  services.fprintd = {
	enable = true;
  };

  services.power-profiles-daemon = {
	enable = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.serbanc = {
    isNormalUser = true;
    description = "Serban Cosmiuc";
    extraGroups = [ "networkmanager" "wheel" "input" "root"];
    packages = with pkgs; [
    #  thunderbird
    ];

    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "serbanc";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
	  "git"
	  "z"
	  "vi-mode"
	  "tldr"
	  "starship"
	  "aliases"
	  "autojump"
        ];
      };
    };


  programs.foot = {
	enable = true;
	enableZshIntegration = true;
  };

  programs.starship = {
	enable = true;
  };

  programs.autojump = {
	enable = true;
  };

  programs.thunar = {
	enable = true;

	plugins = with pkgs.xfce; [
	thunar-volman
	thunar-archive-plugin
	thunar-media-tags-plugin
	];
  };

  programs.file-roller = {
	enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.variables = {
	FREETYPE_PROPERTIES="truetype:interpreter-version=35 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"; 
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	wget
  	neovim
	git
  	fuzzel
  	foot
	gnome-logs
	fastfetch
  	waybar
	vesktop
	libnotify
	dunst
	brightnessctl
	kanshi
	swww
	grim
	slurp
	wlsunset
	starship
	networkmanagerapplet
	font-awesome
	nerdfonts
	zsh
	oh-my-zsh
	fzf
	autojump
	tldr
	cht-sh
	fprintd
	pyprland
	hypridle
	hyprlock
	power-profiles-daemon
	wl-clipboard
	btop
	obsidian
	xfce.thunar
	xfce.thunar-archive-plugin
	gvfs
	file-roller
	torzu
	qbittorrent
	pwvucontrol
	gparted
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
