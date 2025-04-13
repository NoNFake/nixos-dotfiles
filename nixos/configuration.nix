# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	./modules/steam.nix
	./modules/nvidia.nix
	./modules/light.nix    
	./modules/sound.nix
	./modules/layout.nix
	./modules/xrandr.nix
		./modules/lock.nix
	./modules/obs.nix

];  



#  security.rtkit.enable = true;
#  services.pipewire = {
#   enable = true;
#   alsa.enable = true;
#   alsa.support32Bit = true;
#   pulse.enable = true;
#   jack.enable = true;
 #  audio.enable = true;
#  };
#  hardware.pulseaudio.enable = false;





  #sound.enable = true;
#  hardware.pulseaudio.enable = false; # Use PipeWire instead of PulseAudio
#  services.pipewire = {
#    enable = true;
#    audio.enable = true;
    #alsa.enable = true;
#    alsa.support32Bit = true;
#    pulse.enable = true;
#  };
 hardware.enableAllFirmware = true;
 hardware.firmware = [ pkgs.linux-firmware ];


#monitor.alsa.properties = {
#  alsa.use-ucm = true
#}




  
  sound-alsa.enable = true;

  nixpkgs.config.allowUnfree = true;
 
  # bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

   
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';
  
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";
  

  # Hibernate 
  systemd.sleep.extraConfig = ''
  	HibernateDelaySec=2m
  '';

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # lid
  services.logind.lidSwitch = "poweroff";
  services.logind.lidSwitchExternalPower = "lock";
  services.logind.lidSwitchDocked = "lock";


  # power manager
  powerManagement.enable = true;
  
  # thermald
  services.thermald.enable = true;

  # tlp
  services.tlp = {
  enable = true;
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 20;

    # Optional helps save long term battery health
    START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
    STOP_CHARGE_THRESH_BAT0 = 80;  # 80 and above it stops charging
  };
};
  



  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  
#  services.xserver = {
#	enable = true;
#	windowManager.qtile.enable = true;
#
#	displayManager.sessionCommands = ''
#
#	xrandr --newmode "3072x1920_120.00"  1066.35  3072 3352 3696 4320  1920 1921 1924 2057  -HSync +Vsync
#	xrandr --addmode eDP-1 "3072x1920_120.00"
#	xrandr --output eDP-1 --scale 0.7 --mode "3072x1920_120.00"	
#	xwallpaper --zoom ~/Pictures/wallpaper/forest-mountain-cloudy-valley.png
#	xset r rate 200 35 & 
#	'';
#  };

  services.picom = {
	enable = true;
	backend = "glx";
	fade = true;
  };  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #  enable = true;
  #   pulse.enable = true;
  #  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.qurii = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       tree
     ];
   };

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
	neovim
	alacritty
	btop
	xwallpaper	

	pcmanfm
	rofi
	lshw

	git
	pfetch
	vscode

	# For FN
	libinput
	
	# sound
	alsa-utils	
    	sof-firmware
	audacity	
	# lock
	xsecurelock
   	xss-lock

	discord
	pipewire	

   ];
  
  fonts.packages = with pkgs; [
	jetbrains-mono
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

