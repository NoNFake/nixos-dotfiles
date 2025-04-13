{ pkgs, config, libs, ...}:

{

#hardware.opengl = { enable = true; };


hardware.graphics = {
     enable = true;
     #driSupport = true;
     #driSupport32Bit = true;
  };
  
services.xserver.videoDrivers = ["nvidia"];


hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # true
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    prime = {

      reverseSync.enable = true;
      # Enable if using an external GPU
      allowExternalGpu = false;

      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    
      
    };

  package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
