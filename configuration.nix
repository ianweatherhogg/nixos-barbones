# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = false;
  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=0,1
  '';

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };
  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    wget
    # gitAndTools.gitFull
    git

    # (chromium.override {
    #    enablePepperFlash = true;
    # })
    htop
    i3
    rxvt_unicode
    # rust
    emacs
    python
    virtmanager
    kvm
    truecrypt
    tree
    xclip
    xsel
    # vagrant
    # docker
    dmenu
    # firefox
    rsync
    unison
    i3status
    aspell
    aspellDicts.en
    aspellDicts.de
    xlibs.xmodmap
    # thunderbird
    gnupg
    # scala
    # jdk
    tcpdump
    pinentry
    # vlc
    # youtubeDL
    sqlite
    silver-searcher
    pass
    lsof
    unzip
    # evince
    rlwrap
    nix-repl
    nixops
    pulseaudio
  ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
      # dejavu_fonts
      # vistafonts
      # ttf_bitstream_vera
      # liberation_ttf
      # dejavu_fonts
      # terminus_font
    ];
  };

  nix.package = pkgs.nixUnstable;

  sound.enableOSSEmulation = false;
  hardware.pulseaudio.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    rxvt_unicode = {
      perlBindings = true;
    };
    # firefox = {
    #   enableAdobeFlash = true;
    #   jre = false;
    # };
  };

  services.xserver = {
    autorun = true;
    displayManager.slim = {
      defaultUser = "ian";
      enable = true;
      theme = pkgs.fetchurl {
        url = https://github.com/jagajaga/nixos-slim-theme/archive/1.0.tar.gz;
        sha256 = "08ygjn5vhn3iavh36pdcb15ij3z34qnxp20xh3s1hy2hrp63s6kn";
      };
    };
    displayManager.sessionCommands = ''
       xmodmap -e 'pointer = 3 2 1 5 4 7 6 8 9 10 11 12'
       urxvtd -q -o -f
    '';
    desktopManager = {
      xterm.enable = false;
      default = "none";
    };
    enable = true;
    layout = "gb";
#    startGnuPGAgent = true;
    windowManager = {
     i3.enable = true;
     default = "i3";
    };
  };

  # environment.variables = {
  #   NIX_PATH = pkgs.lib.mkOverride 0 [
  #     "nixpkgs=/home/ian/.nix-defexpr/channels/nixpkgs"
  #     "nixos=/home/ian/.nix-defexpr/channels/nixpkgs/nixos"
  #     "nixos-config=/etc/nixos/configuration.nix"
  #   ];
  # };

  services.cron.enable = false;

  virtualisation.libvirtd.enable = true;

  programs.zsh.enable = true;
  programs.ssh.startAgent = false;
  programs.bash.enableCompletion = true;
  security.sudo.enable = true;

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.ian = {
    name = "ian";
    group = "users";
    uid = 1000;
    createHome = true;
#    createUser = true; # 16Oct14 apparantly no longer supported
    home = "/home/ian";
    useDefaultShell = true;
    description = "Ian Weatherhogg";
    password = "ian";
    extraGroups = [
      "wheel"
      "vboxusers"
      "libvirtd"
      "audio"
    ];
  };

}
