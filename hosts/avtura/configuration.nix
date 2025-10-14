# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "avtura"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tom = {
    isNormalUser = true;
    description = "Tom";
    extraGroups = [ "networkmanager" "wheel" "input" "docker" ];
    packages = with pkgs; [ ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "tom" = import ./home.nix; };
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "tom";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kitty
    swww
    waybar
    hyprlock
    hyprpaper
    hyprcursor
    mpv
    gcc
    dunst
    libnotify
    git
    wofi
    brightnessctl
    ncmpcpp
    obsidian
    keepassxc
    google-chrome
    jdk
    rustup
    yt-dlp
    playerctl
    stow
    lazygit
    feh
    mr
    mpc
    mycli
    mariadb.client
    unzip
    gum
    pv
    jq
    wget
    fd
    ripgrep
    wl-clipboard-x11
    python3
    maven
    ant
    openvpn
    openconnect
    killall
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    wlogout
    lazydocker
    pastel
    caligula
    astroterm
    dysk
    bat
    eza
    xh
    zellij
    dust
    yazi
    hyperfine
    bacon
    rusty-man
    delta
    tokei
    protonvpn-gui
    cargo
    rustc
    rustfmt
    clippy
    qbittorrent
    nicotine-plus
    nodejs
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];
  virtualisation.docker.enable = true;
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
  system.stateVersion = "25.05"; # Did you read the comment?i

  programs.hyprland.enable = true;
  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  programs.firefox.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.mpd = {
    enable = true;
    extraConfig = ''
            audio_output {
               type "pipewire"
      	 name "My Pipewire Output"
            }
    '';
    musicDirectory = "/home/tom/media/music";
    user = "tom";
  };
  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR =
      "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
  };
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "tom";
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
  };
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
}
