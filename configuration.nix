# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "i915" ];
  boot.blacklistedKernelModules = [ "xe" ];
  boot.kernelParams = [
    "i915.force_probe=*"
    
   ];

  
  
  networking.hostName = "veggie"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vlad = {
    isNormalUser = true;
    description = "vlad";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "render" "seat" "input" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  fonts = {
    fontconfig.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      dejavu_fonts
      liberation_ttf
    ];
  };
  
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    emacs-nox
    nh
    git
    tmux
    vulkan-tools
    mpv
    ffmpeg
    libva-utils
    pciutils
    iw
    curl
    alsa-utils
    libdrm
    mesa-demos
    wiremix
    gamescope
    ( mpv.override { scripts = [
      mpvScripts.modernz
      mpvScripts.mpris
                     ]; } )
    jellyfin-mpv-shim
    uv
    python315
  ];

  

 
 
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
  security.polkit.enable = true;

  services.kmscon = {
    enable = true;
    hwRender = true;
    fonts = [{ name = "JetBrains Mono"; package = pkgs.jetbrains-mono; }];
    extraConfig = "font-size=28";  # tune for 4K TV viewing distance
    autologinUser = "vlad";
  };

  security.sudo.extraRules = [{
    users = ["vlad"];
    commands = [
      { command = "/run/current-system/sw/bin/chvt"; options = ["NOPASSWD"]; }
      { command = "/run/current-system/sw/bin/fgconsole"; options = ["NOPASSWD"]; }
    ];
  }];
  
  
#   environment.etc."wireplumber/wireplumber.conf.d/10-headless.conf".text = ''
#   wireplumber.profiles = {
#   main = {
#     monitor.alsa = true
#   }
# }

# wireplumber.settings = {
#   device.restore-profile = false
#   device.restore-routes  = false
# }

# monitor.alsa.rules = [
#   {
#     matches = [
#       { device.name = "~alsa_card.*" }
#     ]
#     actions = {
#       update-props = {
#         api.acp.auto-profile = true
#         api.acp.auto-port = true
#         device.profile = "output:hdmi-stereo"
#       }
#     }
#   }
# ]
# }
# '';

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
    
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      #intel-vaapi-driver
      vpl-gpu-rt
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
    
  };



  hardware.enableRedistributableFirmware = true;
  

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };

  # services.getty.autologinUser = "vlad";
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.seatd.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };

 
  
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

 
  system.stateVersion = "25.11"; # Did you read the comment?

}
