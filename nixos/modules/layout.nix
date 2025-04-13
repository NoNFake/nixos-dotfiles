{
config,
lib,
pkgs,
...

}:


{

  services.xserver.xkb.layout = "us,ua";
  #services.xserver.xkb.variant = "workman,";
  services.xserver.xkb.options = "grp:win_space_toggle";
}

