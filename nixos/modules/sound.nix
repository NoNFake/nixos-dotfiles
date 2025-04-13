{ config, pkgs, lib, ... }:

let
  volumeStep = "5%";
in
{


  #boot.extraModprobeConfig = ''
  #  options snd-intel-dspcfg dsp_driver=1
  #'';

  #sound.enable = true;
  options.sound-alsa.enable = lib.mkEnableOption "Pure ALSA-only sound setup with media keys";

  config = lib.mkIf config.sound-alsa.enable {
    # Remove old/deprecated sound options
    #sound.enable = lib.mkForce false;
    hardware.pulseaudio.enable = lib.mkForce false;
    #services.pipewire.enable = lib.mkForce false;
    #sound.enable = true;
    hardware.bluetooth.enable = true;
    

   hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
  load-module module-bluetooth-policy
  load-module module-bluetooth-discover
  ## module fails to load with 
  ##   module-bluez5-device.c: Failed to get device path from module arguments
  ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
  # load-module module-bluez5-device
  # load-module module-bluez5-discover
'';

  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull;
  };

hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };
# Provide optional asound.conf (optional, customize if needed)
    environment.etc."asound.conf".text = ''
      defaults.pcm.card 0
      defaults.ctl.card 0
    '';

    # Install ALSA utilities (for amixer, alsamixer, etc.)
    environment.systemPackages = with pkgs; [
      alsa-utils
    ];

    # Enable actkbd for media key handling (for volume keys)
    services.actkbd = {
      enable = true;
      bindings = [
        # Mute key (XF86AudioMute)
        {
          keys = [ 113 ];
          events = [ "key" ];
          command = "${pkgs.alsa-utils}/bin/amixer -q set Master toggle";
        }

        # Volume Down (XF86AudioLowerVolume)
        {
          keys = [ 114 ];
          events = [ "key" "rep" ];
          command = "${pkgs.alsa-utils}/bin/amixer -q set Master ${volumeStep}- unmute";
        }

        # Volume Up (XF86AudioRaiseVolume)
        {
          keys = [ 115 ];
          events = [ "key" "rep" ];
          command = "${pkgs.alsa-utils}/bin/amixer -q set Master ${volumeStep}+ unmute";
        }

        # Mic Mute key (if present; otherwise you can remove this)
        {
          keys = [ 190 ];
          events = [ "key" ];
          command = "${pkgs.alsa-utils}/bin/amixer -q set Capture toggle";
        }
      ];
    };
  };
}
