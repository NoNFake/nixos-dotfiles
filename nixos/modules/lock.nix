{
config,
lib,
pkgs,
...

}:

{

programs.xss-lock.enable = true;
programs.xss-lock.lockerCommand = "xsecurelock";

}
