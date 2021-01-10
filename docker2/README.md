# 

- https://cr.console.aliyun.com/cn-shenzhen/instance/repositories
  - registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-debian-openbox:latest `已删`

## Run

```bash
# fk-bunsen-netinstall/docker2
headless @ vm23-197 in .../fk-bunsen-netinstall/docker2 |15:40:17  |br-docker ✓| 
  $ docker build -t obox-b2 .
  $ docker run -it --rm -v $(pwd):/src -p 3389:3389 -p 2223:22 -p 5900:5900 --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro  obox-b2

##dbg_vncViewer:
# /home/headless:/src #ff_$pwd用法: @dbox挂载目录不一致
  $ docker run -it --rm -v /home/headless:/src -p 3389:3389 -p 2223:22 -p 5900:5900 --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --entrypoint=bash obox-b2
  root@b78d823d5812:/# #dbg
    export DISPLAY=:1
    xterm 
  root@b78d823d5812:/# bash entry0.sh 
  ## 
  # mRemoteNG: conn退出，
  # vnc-4_1_2-x86_win32_viewer: 顺利连接; 无pw; 172.25.23.197:5900
  # 黑屏: 右键:obconf;

# huapox/dotfiles
root@8fe667f1a589:/src/ctDown2# git clone --depth=1 https://gitee.com/huapox/dotfiles
root@8fe667f1a589:/src/ctDown2# du -sh dotfiles/
  8.5M	dotfiles/
  cd dotfiles
    rsync -avxHAXP --exclude '.git*' .* ~/
    fc-cache -rv
  bash /entry0.sh
  # vncview远程: uiOK;
  # ssh下: obconf; lxappearance; #改wm, 外观;
  # thunar: dbusWarn in console.  #geany
  # gnome-system-monitor: dbusWarn, 图不能看(like: ff_dbox故障时效果)
  # plank: 可用;
```

## 附

### 1）Items

> wm/apps > xvfb/x11vnc(xrdp/novnc) > tini/runsv

- https://elementary.io/ #refUI
- www.lainme.com/doku.php/blog/2018/07/如何优雅的在windows_10上装x
- https://www.cnblogs.com/ldcs/p/13873609.html #x11-xserver-utils $xhost +
- https://hub.docker.com/r/jrei/systemd-debian #systemd
- https://github.com/Fullaxx/ubuntu-desktop #baseEnv: apps ##ubt20.4 152M;
- https://github.com/danakj/openbox #2002-2015;
- jgmenu: https://github.com/johanmalm/jgmenu/graphs/contributors

**base**

- app0: sudo net-tools tree tmux lrzsz lvm2 fuse
- app1: openbox, tint2, conky, thunar, geany, 
- app2: gnome-system-monitor ristretto plank #ibus-rime docky
- app4: aptitude feh compton xfce4-notifyd xbindkeys lxterminal jgmenu gdebi catfish
- 
- conf: obconf, lxappearance, tint2conf
- bindKeys: 

**dotfiles**

- https://github.com/owl4ce/dotfiles
- https://github.com/addy-dclxvi/dotfiles #ThinkPad-X230-Debian-Openbox and Aspire-A514-Debian-Fluxbox 
- https://github.com/antoniosarosi/dotfiles #GoodSort: Qtile, rofi

**themes**

- https://github.com/numixproject #numix-gtk-theme numix-icon-theme-circle 
- https://github.com/themix-project #oomox-gtk-theme 
- https://github.com/addy-dclxvi #re; #openbox-theme-collections gtk-theme-collections 
- 
- https://github.com/vinceliuice/vimix-gtk-themes
- https://github.com/vinceliuice/Mojave-gtk-theme
- https://github.com/daniruiz/flat-remix-gtk
  - https://drasite.com/flat-remix-gtk
- https://github.com/nana-4/materia-theme #non-openbox Debian10
- https://github.com/pop-os/gtk-theme #gnone?
- https://github.com/B00merang-Project/macOS

**xorg/xvfb xrdp**

- xvfb x11vnc `tigervnc-standalone-server/x11vnc`
  - https://hub.docker.com/r/hironishi/openbox-mozc-docker/dockerfile #ubt1804 #jp
  - https://hub.docker.com/r/naei/openbox-novnc/dockerfile #ubt1604  ##mRenoteNG_connSameErr


```bash
##deb921_s11:
  xhost+ #sam$

##OK
docker run -it --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  --entrypoint=/usr/bin/xterm fullaxx/ubuntu-desktop
```

### 2）xvbf/x11vnc test

- old ref
  - http://git.ali.devcn.fun:81/g-dev1/fk-docker-xrdp/src/branch/sam-custom/lite/entry0.sh #cmds
  - http://git.ali.devcn.fun:81/g-dev1/fk-docker-xubuntu/src/branch/sam-custom/detail.md #ff_xvfb_x11vnc
- new ref

```bash
# https://github.com/hiroshi-nishiura/openbox-mozc-docker/blob/master/startup.sh
  x11vnc -passwd ubuntu -env FD_GEOM=1920x1080 -env FD_PROG=openbox-session -create

# https://hub.docker.com/r/naei/openbox-novnc/dockerfile
# X Server
  Xvfb :1 -screen 0 1600x900x16 & \
# Openbox
  (export DISPLAY=:1 && openbox-session) & \
# VNC Server
  if [ -z $VNC_PASSWD ]; then \
    # no password
    x11vnc -display :1 -xkb -forever; \
  else \
    # set password from VNC_PASSWD env variable
    mkdir ~/.x11vnc && \
    x11vnc -storepasswd $VNC_PASSWD /root/.x11vnc/passwd && \
    x11vnc -display :1 -xkb -forever -rfbauth /root/.x11vnc/passwd & \
  fi && \

```

### 3）210110|bunsen `/apt-repository`

> merge: ./02-bunsen.md

```bash
    3  ln -s /opt/apt-repository  / #/apt-repository
    6  echo "deb [trusted=yes] file:///apt-repository/ sid main" >> /etc/apt/sources.list
    7  apt update; apt install jgmenu

   12  cd apt-repository/
   13  touch lst; vi lst 
   19  ss=$(cat lst |grep -v "^#")
   21  apt install --no-install-recommends $ss

```

### 4）210110| owl4ce/dotfiles

> merge: ./01-owl4ce_dotfilesIns.md

- owl4ce/dotfiles

```bash
#########dotfiles
# docker run -it --rm -v $(pwd):/src -p 3389:3389 -p 2223:22 registry.cn-shenzhen.aliyuncs.com/infrastlabs/fat-debian bash
  cd /src/; git clone https://gitee.com/huapox/dotfiles

# cmds
cd /src/dotfiles/
  du -sh .[!.]* |grep M
  rsync -avxHAXP --exclude '.git*' .* ~/
  fc-cache -rv
  chmod u+s `which {poweroff,reboot,brightnessctl}` #lite1: none.

# Papirus-Custom
  cd ~/.icons && tar -Jxvf Papirus-Custom.tar.xz && tar -Jxvf Papirus-Dark-Custom.tar.xz
  sudo ln -s ~/.icons/Papirus-Custom /usr/share/icons/Papirus-Custom
  sudo ln -s ~/.icons/Papirus-Dark-Custom /usr/share/icons/Papirus-Dark-Custom


#########obox-lite1 (xvfb+xrdp)
  # @dbox: /mnt/home/headless/ctData
  # xrdp 700Kb; xvfb 27.1/33.7M; xorg 62.3/66.4M;
  $ sudo apt install --no-install-recommends xrdp
  $ sudo apt install --no-install-recommends xvfb
  systemctl enable xrdp
  docker commit xxx obox-lite1 #ap34 (@dbox-headless)

# use1
  docker run -it --rm -v $(pwd):/src -p 3389:3389 -p 2223:22 --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --entrypoint=/bin/systemd obox-lite1 bash
  # xrdp> xvfb: 不会启动;
  # ins xorg: 43M?; 再次xorg:也不会启动
  # commit xxx obox-lite2; 重试lite2_xrdp: 不会启动
  # ins tigervnc-standalone-server:1M; jumpadmin> vncserver启动[:1]; > xrdp_vnc:127.0.0.1:5901 OK;
  jumpadmin@2f29e80c1962:/src/ctDown/dotfiles$ export DISPLAY=:1; xterm 
  # obconf; lxappearance; 改wm样式,改掉暗色主题; OK2

#########commit-obox1
  docker commit xxx obox1 #vm23.197 (@dbox-headless)
  # -d || -it --rm
  headless @ vm23-197 in /opt/t_test1 |15:37:38  
    $ docker run -d -v $(pwd):/src -p 3389:3389 -p 2223:22 --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --entrypoint=/bin/systemd obox1 bash
    ## openUI可进, obmenu-genErr;

    export DISPLAY=:10
    xterm.  plankRunErr;
    #lxappearence  obconf

```

- ins-apps

```bash
# 56.9M;
apt install --no-install-recommends \
  psmisc htop rsync \
  openbox obconf tint2 geany xsettingsd thunar \
  lxappearance lxpolkit rofi dunst

# apt update; apt install openbox
apt install --no-install-recommends \
  psmisc htop rsync python \
  openbox obconf tint2 geany xsettingsd thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman \
  lxappearance lxpolkit rofi dunst rxvt-unicode scrot wireless-tools \
  neofetch imagemagick nitrogen brightnessctl gsimplecal viewnior \
  xautolock xclip parcellite tumbler w3m w3m-img \
  alsa-utils pavucontrol mpv mpd mpc ncmpcpp ffmpeg ffmpegthumbnailer playerctl qt5ct qt5-style-plugins
  #161M
  #xclip parcellite #clipboard
  #gsimplecal #datetime
  # mpd mpc ncmpcpp #player

  # wireless-tools 135Kb;
  # rxvt-unicode 21M;
  # rofi 22M;
  # dunst 20M;
  # lxappearance/lxpolkit 39M;
  # neofetch 35M;
  # imagemagick 42M;
  # nitrogen 40.5M;
  # brightnessctl 13Kb;
  # gsimplecal 43M;
  # viewnior 39M;
  # thunar/thunar-media-tags-plugin/thunar-volman 99M;
  # thunar-archive-plugin 114M;
  # openbox obconf 59M;
  # tint2 39M;

```


- host-x11
  - [TranslateProject/20150423 20 Awesome Docker Containers for a Desktop User.md](https://github.com/LCTT/TranslateProject/blob/138754f7df04386cc0af92fcfc15e63e297c901c/published/201506/20150423%2020%20Awesome%20Docker%20Containers%20for%20a%20Desktop%20User.md) at `20150423=138754f7df04386cc0af92fcfc15e63e297c901c · LCTT/TranslateProject`

```bash
##deb921_s11:
xhost+ #sam$

##ERR
docker run -it \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  --device /dev/sda:/dev/sda \
  --name gparted \
  jess/gparted

##OK
docker run -it --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  --entrypoint=/usr/bin/xterm fullaxx/ubuntu-desktop
```

