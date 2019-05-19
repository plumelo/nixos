{ config, options, lib, pkgs, ... }:
{
  imports = [
    ./pkgs.nix
    ./programs/tmux.nix
    ./programs/lf/default.nix
    ./virtualisation/lxc.nix
    ./virtualisation/lxd.nix
    ./hardware/ssd.nix
    ./hardware/zram.nix
    ./users.nix
  ];

  system.stateVersion = "19.03";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Bucharest";


  programs = {
    java.enable = true;
  };

  hardware = {
    pulseaudio.enable = true;
    cpu.amd.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  boot = {
    initrd.availableKernelModules = [
      "hid-logitech-hidpp"
    ];

    kernel.sysctl."fs.inotify.max_user_watches" = lib.mkDefault 524288;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.ntp.enable = true;

  networking.networkmanager = {
    dns = "dnsmasq";
    dynamicHosts =  {
      enable = true;
      hostsDirs."${config.users.defaultUser.name}"= {
        user=config.users.defaultUser.name;
      };
    };
  };

  environment.etc."NetworkManager/dnsmasq.d/10-dns-lxcd.conf".text = ''
    server=/local/10.0.3.1
    server=/lxd/10.0.4.1
  '';
}

