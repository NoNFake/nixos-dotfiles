{ config, lib, pkgs, ... }:



{

services.xserver = {
     
   # MAIN='eDP-1'
   # MAIN_RESOLUTION="3072x1920_120.00"    
   enable = true;
   windowManager.qtile.enable = true;

 
   displayManager.sessionCommands = ''

        xrandr --newmode "3072x1920_120.00"  1066.35  3072 3352 3696 4320  1920 1921 1924 2057  -HSync +Vsync
        xrandr --addmode eDP-1 "3072x1920_120.00"
        
	# With scale
	#xrandr --output eDP-1 --scale 0.7 --mode "3072x1920_120.00"
        xrandr --output eDP-1 --mode "3072x1920_120.00"
	xwallpaper --zoom ~/Pictures/wallpaper/forest-mountain-cloudy-valley.png
        xset r rate 200 35 &
        '';

   dpi = 220;
   upscaleDefaultCursor = true; #  false
   };
  
  environment.variables = {
  GDK_SCALE = "2.2"; # default 1 I think
  GDK_DPI_SCALE = "0.4"; # default 1 I think
  _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2.2"; # default 1 I think
  QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  XCURSOR_SIZE = "64"; # default 16 I think
  };

 


}
