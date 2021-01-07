# 

- https://github.com/huapox/kuberimages
  - [sys-bsnux/Dockerfile](https://github.com/huapox/kuberimages/blob/master/sys-bsnux/Dockerfile) `infrastlabs/fat-debian; buster`
- https://cr.console.aliyun.com/cn-shenzhen/instance/repositories
  - registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-bunsen:v1 `627.403 MB@2021-01-19 16:11:56`
  - registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-bunsen:latest `436.639 MB@2021-01-19 19:14:45`
  - registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-bunsen-repo:latest `133.940 MB@2021-01-13 00:21:10`

## build/use

```bash
########systemd
##danger!!!: 导致23.22磁盘全卸载， 4个docker全停，0号docker jnlp-slave停服<21,24auto; 22,33手工启脚本:/data1/jnlp-share/down/xx-22/23.sh>
##效果类似: openwrt-x86 in ap34;
docker  run -it --rm --network=host --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro sys-bsnux1
docker  run -it --rm --privileged -p 3389:3389 -p 2222:22 -v /sys/fs/cgroup:/sys/fs/cgroup:ro sys-bsnux1


########t1, docker-bunsen
docker build -t t1 .
docker run -it --rm --privileged -p 3389:3389 -p 2223:22 -v /sys/fs/cgroup:/sys/fs/cgroup:ro t1
##systemd 启动ok; xrpd, sshd运行正常； xrdp远程OK(jumpadmin/_)
##UI效果ok; 默认黑灰色: 体验中..

## v1(627.403 MB) > latest use: #421.839 MB > 436.639 MB(fix1)
img=registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-bunsen
docker run -it --rm  --privileged -p 3381:3389 -p 2223:22 -v /sys/fs/cgroup:/sys/fs/cgroup:ro $img

```

## debug

```bash
#######xvfb
xvfb-run -s ":99" -s '-screen 0 1024x700x24 -ac' openbox-session
x11vnc -display :99 -forever -nopw

apt install procps #ps free
apt install thunar #25M


####### pkg-test
recs=($( sed 's/\#.*$//' pkgs-norecs )) 
apt install --no-install-recommends "${recs[@]}" #251 MB >> 208MB(- x2: bsnux_big_deb)

# --no-install-recommends
recs=($( sed 's/\#.*$//' pkgs-recs )) 
echo "${recs[@]}"
apt install "${recs[@]}" #218 MB
apt install --no-install-recommends "${recs[@]}" #134 MB
apt download "${recs[@]}"

# bunsen-paper-icon-theme bunsen-images
apt install -yd bunsen-paper-icon-theme bunsen-images
wget https://asia.pkg.bunsenlabs.org/debian/pool/main/p/paper-icon-theme/paper-icon-theme_1.4%2Br696.d2476a62-1_all.deb
wget https://asia.pkg.bunsenlabs.org/debian/pool/main/b/bunsen-images/bunsen-images_9.4.7-2_all.deb

```

## 附

### 1）Items

- 本块化/自用项安装: zh,dev
  - https://gitee.com/g-system/env-bsnux/blob/master/system/de-conf.md #ibus-rime, docky/plank
- 配置项: jqmenu定制_item/icon; 
  - https://gitee.com/g-system/env-bsnux/tree/master/system/obox-menu
- ff_recs:
 - xxx..: remmina, shutter, PAC, ...
 - https://gitee.com/g-system/env-bsnux/tree/master/soft

```bash
### extend>>apt_offline_repo: +lighttp,离线(bunsen)/实时(++..) http/https仓库；
### old: litePad, s11, ap34; bsnuxInsRecs?; xenServer/pve insRecs? fedora 21 recs? (where puted??)

## properUsage
- Docker构建img, pushAliyun-instrastlabs;
  - 与dbox-xubuntu区分/定位 ##both: headless
    - dbox: 圆润风 轻巧 精致
    - bsnux: Flat风 自用 极致
    - 
    - systemd_drop > tini_runsv?
    - xfwm4_openbox_lighter?
    - only: openbox+tint2+conky+thnar+Geany+
    - tigervnc > xvfb/x11vnc
      - xrdp: same;
      - novnc: toAdd;
  - (A)just另一个选择?? :  xfce, openbox, mate(传统), ~mint_cinnamon(不习惯)~, elementary
    - lmde-4-cinnamon-64bit.iso #from debian10; 不好用nemo文件管理； desk: bar,menu..
  - (B)extremLite、自用deb10_openbox版; 
    - xbt-xfce4: 通用版，不折腾 (不可/无)特别定制项.
  - ENV使用场景
    - PC_Host主机;
    - Server_VM主机;
    - Fat_配额限定;

```



### 2）210107|try offline_aptIns

> merge: docs/01-bunsen-apt-downInstall.md, docs/01b-deb10_localAptRepo.txt

- https://blog.csdn.net/candcplusplus/article/details/52156324 #ubt1404
  - https://blog.csdn.net/wangqiulin123456/article/details/39582269
  - http://www.leux.cn/doc/Debian%E4%BD%BF%E7%94%A8DVD%E6%BA%90%E7%A6%BB%E7%BA%BF%E6%9B%B4%E6%96%B0.html #iso
  - http://blog.chinaunix.net/uid-21367180-id-443581.html #sid, dpkg-dev, 2010
  - https://blog.csdn.net/developerinit/article/details/73433649 #try stretch, mysql;

```bash
########systemd
# 02: https://hub.docker.com/r/jrei/systemd-debian
  docker run -d --name systemd-debian --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro jrei/systemd-debian
  # or if it doesn't work:--privileged
  docker run -d --name systemd-debian --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro jrei/systemd-debian


# registry.cn-shenzhen.aliyuncs.com/sam-ns1/sync-kube2:sys-bsnux
img=registry.cn-shenzhen.aliyuncs.com/infrastlabs/fat-debian
docker run -it --rm --network=host -v /opt/down/cache-apt-archives/:/mnt $img bash

headless @ mac23-191 in ~ |11:43:28  
img=registry.cn-shenzhen.aliyuncs.com/infrastlabs/fat-debian
$ docker run -it --rm --privileged --network=host \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -v /opt/down/cache-apt-archives/:/mnt $img /bin/systemd

########offline_aptIns
#01:just dpkg -i *.deb ##bunsen-* 全量后，会有依赖错误;
#02: local apt repo:
deb file:///mnt/deb2 ./  #badFormat
    2  cd mnt/deb2/; chmod 777 *.deb
    8  apt update; apt install dpkg-dev 
   15  dpkg-scanpackages ./  /dev/null   | gzip > Packages.gz
   21  apt install vim.tiny; vim.tiny /etc/apt/sources.list

# sources.list
root@pci:/mnt/deb2# cat /etc/apt/sources.list
deb http://mirrors.163.com/debian/ buster main non-free contrib
deb http://mirrors.163.com/debian/ buster-updates main non-free contrib
deb http://mirrors.163.com/debian/ buster-backports main non-free contrib
deb http://mirrors.163.com/debian-security/ buster/updates main non-free contrib
#deb file:///mnt/deb2 ./
deb [trusted=yes] file:///mnt/deb2/ sid main

# ===
   41  mkdir -p dists/sid/main/binary-amd64
   42  mkdir pools; mv *.deb pools/
   47  ls -1 pools | sed 's/_.*$/ extra BOGUS/' | uniq > override
   50  dpkg-scanpackages pools override > dists/sid/main/binary-amd64/Packages.gz

   67  vim.tiny dists/sid/main/Release 
   72  mv dists/sid/main/Release dists/sid/
   71  vim.tiny /etc/apt/sources.list
   73  apt update  #E: The repository 'file:/mnt/deb2 sid Release' is not signed.

#deb [trusted=yes] file:///mnt/deb2/ sid main
root@pci:/mnt/deb2# apt update
  Get:2 file:/mnt/deb2 sid Release [96 B]
  Get:2 file:/mnt/deb2 sid Release [96 B]
  Get:4 file:/mnt/deb2 sid/main amd64 Packages [461 kB]
  Reading package lists... Done
  Building dependency tree       
  Reading state information... Done

# viewRepo
jumpadmin@pci:/mnt/fk-bunsen-netinstall$ find /mnt/deb2/ |grep -v deb$
  /mnt/deb2/
  /mnt/deb2/Packages.gz
  /mnt/deb2/dists
  /mnt/deb2/dists/sid
  /mnt/deb2/dists/sid/main
  /mnt/deb2/dists/sid/main/binary-amd64
  /mnt/deb2/dists/sid/main/binary-amd64/Packages.gz
  /mnt/deb2/dists/sid/main/Release
  /mnt/deb2/dists/sid/Release
  /mnt/deb2/pools
  /mnt/deb2/override


#  bunsen-* ins
apt install -y bunsen-images && apt -y install paper-icon-theme

apt install  bunsen-common bunsen-configs bunsen-configs-pulse bunsen-conky \
bunsen-docs bunsen-exit bunsen-fortune bunsen-keyring bunsen-os-release \
bunsen-pipemenus bunsen-themes bunsen-thunar bunsen-utilities bunsen-welcome
  # bunsen-configs  conky(down 182M) 
  # bunsen-configs-pulse #64M
  # exit 98M
  # fortune 44M
  # keyring 8M
  # os-release 5M
  # 
  # pipemenus 173M
  # themes 48M
  # thunar 54M
  # utilities 173M
  # welcome 25M

```


### 3）210107|tigervnc, xrdp容器内安装启动

> merge: docs/02-gui.md

```bash
#######1）容器内安装，手动启
# tigervnc-xorg-extension tigervnc-standalone-server tigervnc-scraping-server
jumpadmin@pci:/mnt$ sudo apt install tigervnc-standalone-server
  The following NEW packages will be installed:
    cpp cpp-8 libfile-readbackwards-perl libisl19 libmpc3 libmpfr6 tigervnc-common tigervnc-standalone-server x11-xserver-utils
  0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
  Need to get 11.6 MB of archives.

# tigervnc down/ins; ins xrdp
   13  wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.10.1.x86_64.tar.gz
   19  sudo apt install tigervnc-standalone-server
   20  vncserver #vnc localhost:5902; OK;
   21  sudo apt install xrdp; systemctl start xrdp
  ## thunar不可用(未装?)
  ## OK: openbox, tint2, jqmenu, conky   

root@pci:/# pstree
systemd-+-Xtigervnc---16*[{Xtigervnc}]
  |-clipit---17*[{clipit}]
  |-compton
  |-conky---4*[{conky}]
  |-cron
  |-dbus-daemon
  |-polkitd---2*[{polkitd}]
  |-rsyslogd---3*[{rsyslogd}]
  |-systemd---(sd-pam)
  |-systemd-journal
  |-systemd-logind
  |-tint2
  |-vncserver---Xvnc-session---openbox-+-jgmenu-+-xterm---sh---sudo---su---bash
  |                                    |        `-xterm---sh`
  |                                    `-ssh-agent`
  |-xbindkeys
  |-xcape---{xcape}
  |-xrdp---xrdp
  `-xrdp-sesman`

#######2）保存sys-bsnux1
# 保存sys-bsnux1，再次进入
headless @ mac23-191 in ~ |13:40:57  
$ docker commit e4c98990c718 sys-bsnux1
$ docker  run -it --rm --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro sys-bsnux1

#######3）sys-bsnux1二次调试
  ##danger!!!: 导致23.22磁盘全卸载， 4个docker全停，0号docker jnlp-slave停服<21,24auto; 22,33手工启脚本:/data1/jnlp-share/down/xx-22/23.sh>
  ##效果类似: openwrt-x86 in ap34;
  docker  run -it --rm --network=host --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro sys-bsnux1
  docker  run -it --rm --privileged -p 3389:3389 -p 2222:22 -v /sys/fs/cgroup:/sys/fs/cgroup:ro sys-bsnux1

#xrdp: jumpadmin/_ 可直接login;
  ##thunar: ok ###原：应该是dbus未启不能通信?  #### +thunar, +lxappearence依赖错误 未能安装; thunar为前一步手工装的; 
  ##bar: 声音可调,mixer不能打开 ###原: 点击后退出  
  ##字体乱码: jqmenu, barTime右键
  ##vnc: localhost,172.73.0.2:5901; 进入失败： problem connecting, some problem;
  --
  systemctl stop lightdm ##直接停了它； ###lightdm-vnc模式: 暂不折腾
```

- 保存sys-bsnux1，再次进入

```bash
headless @ mac23-191 in ~ |13:42:51  
$ docker  exec -it 572 bash
root@572ecaeaab19:/# netstat -ntlp
  Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
  tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      129/sshd            
  tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      407/exim4           
  tcp6       0      0 127.0.0.1:3350          :::*                    LISTEN      142/xrdp-sesman     
  tcp6       0      0 :::22                   :::*                    LISTEN      129/sshd            
  tcp6       0      0 :::3389                 :::*                    LISTEN      247/xrdp    

root@572ecaeaab19:/# pstree
systemd-+-atd
  |-cron
  |-dbus-daemon
  |-exim4
  |-lightdm-+-Xorg---17*[{Xorg}]
  |         |-lightdm-+-lightdm-gtk-gre---18*[{lightdm-gtk-gre}]
  |         |         `-2*[{lightdm}]`
  |         |-lightdm
  |         `-2*[{lightdm}]`
  |-polkitd---2*[{polkitd}]
  |-rsyslogd---3*[{rsyslogd}]
  |-sshd
  |-systemd-+-(sd-pam)
  |         |-at-spi-bus-laun-+-dbus-daemon
  |         |                 `-3*[{at-spi-bus-laun}]`
  |         |-at-spi2-registr---2*[{at-spi2-registr}]
  |         |-dbus-daemon
  |         `-gvfsd---2*[{gvfsd}]`
  |-systemd-journal
  |-systemd-logind
  |-systemd-udevd
  |-udisksd---4*[{udisksd}]
  |-xrdp
  `-xrdp-sesman`
root@572ecaeaab19:/# #shutdown -h now
root@572ecaeaab19:/# systemctl  -a |grep running
  init.scope          loaded    active     running   System and Service Manager    
  session-c1.scope    loaded    active     running   Session c1 of user lightdm    
  atd.service         loaded    active     running   Deferred execution scheduler  
  cron.service        loaded    active     running   Regular background program processing daemon    
  dbus.service        loaded    active     running   D-Bus System Message Bus      
  exim4.service       loaded    active     running   LSB: exim Mail Transport Agent         
  lightdm.service     loaded    active     running   Light Display Manager         
  polkit.service      loaded    active     running   Authorization Manager         
  rsyslog.service     loaded    active     running   System Logging Service        
  ssh.service         loaded    active     running   OpenBSD Secure Shell server   
  systemd-journald.service     loaded    active     running   Journal Service      
  systemd-logind.service       loaded    active     running   Login Service        
  systemd-udevd.service        loaded    active     running   udev Kernel Device Manager    
  udisks2.service     loaded    active     running   Disk Manager         
  user@109.service    loaded    active     running   User Manager for UID 109      
  xrdp-sesman.service          loaded    active     running   xrdp session manager          
  xrdp.service        loaded    active     running   xrdp daemon          
  dbus.socket         loaded    active     running   D-Bus System Message Bus Socket        
  syslog.socket       loaded    active     running   Syslog Socket        
  systemd-journald-audit.socket         loaded    active     running   Journal Audit Socket          
  systemd-journald-dev-log.socket       loaded    active     running   Journal Socket (/dev/log)     
  systemd-journald.socket      loaded    active     running   Journal Socket       
  systemd-udevd-control.socket          loaded    active     running   udev Control Socket  
  systemd-udevd-kernel.socket  loaded    active     running   udev Kernel Socket 

```


### 4）210113|pkgs-{recs,norecs}-size

> merge: ./size.md

```bash
root@5ebcef76ded4:/# items=($(sed 's/\#.*$//' pkgs-recs))   && apt  install --no-install-recommends "${items[@]}"
Need to get 94.8 MB/106 MB of archives.
After this operation, 606 MB of additional disk space will be used.

root@5ebcef76ded4:/# items=($(sed 's/\#.*$//' pkgs-norecs))   && apt  install --no-install-recommends "${items[@]}"
Need to get 250 MB/253 MB of archives.
After this operation, 1151 MB of additional disk space will be used.
```

- pkgs-recs

```bash
## bunsenlabs
bunsen-common
bunsen-configs
#bunsen-configs-pulse  36.1 MB
bunsen-conky 22.8 MB
bunsen-docs
bunsen-exit
bunsen-fortune 13.1 MB
bunsen-images  0 B/7323 kB
bunsen-keyring
bunsen-os-release
# bunsen-papirus-icon-theme 10.5 MB
# bunsen-pipemenus 68.2 MB
# bunsen-themes 46.4 MB
# bunsen-thunar 45.6 MB
# bunsen-utilities 49.9 MB
bunsen-welcome 4130 kB
```

- pkgs-norecs-anay

```bash
$ cat pkgs-norecs |grep -v "^#\|^$"  |wc
    137     137    1382
$ cat pkgs-norecs-anay |grep -v "^#\|^$"  |wc
     81      83     762

# editList
$ cat pkgs-norecs-anay |grep  "^#\|^$"   |grep -v install
##################################
##clean from: pkgs-norecs
##################################

#arandr 56.6 MB  <<
#catfish #47.5 MB  <<
#compton 21.5 MB > 130Kb;
#conky-all 22.5 MB  <<
#evince 68.4 MB pdf,docView;
#fbxkb 37.1 MB >  40.7 kB


#fonts-noto #9192 kB
#fonts-noto-cjk #54.3 MB
#galculator 42.0 MB    <<
#galternatives 47.2 MB  <<
#gdebi  #60M
#geany  44.8 MB
#ghostscript 12.1 MB   #Adobe/PostScript
#gigolo 37.2 MB #remote filesys mount
#gmrun 37.1 MB --
# ---
#gnome-keyring  41.9 MB
#gnome-themes-standard 40.8 MB >  4499 kB
#gparted 39.1 MB
#gsimplecal 39.5 MB  <<
#gtk2-engines-pixbuf 16.3 MB > 已装
#gvfs  38.5 MB
#gvfs-backends 53.6 MB
#gvfs-fuse 38.5 MB
#hardinfo 40.0 MB   <<
#hexchat 37.1 MB


#jgmenu 22.2 MB
#libblockdev-crypto2 10.0 MB
#libexo-1-0 46.5 MB
#libinput-tools 5014 kB
#libqt5svg5 45.9 MB
#lxappearance 37.2 MB   <<
#lxterminal 43.1 MB  <<
#nitrogen 39.1 MB  <<
#obconf 43M   <<
#openbox 21.3 MB   <<
#papirus-icon-theme 10.5 MB > 已装
#pavucontrol 46.5 MB --
#pnmixer 42.3 MB --
#policykit-1-gnome  42.0 MB
#python-keybinder 45.1 MB
#python-notify 45.2M


#qt5-style-plugins 69.2 MB > 11.2M(xrdp后端)
#ristretto 39.2 MB   <<
#thunar 46.6 MB  <<
#thunar-gtkhash 45.8 MB  <<
#thunar-media-tags-plugin 47.1 MB  <<
#thunar-volman 46.8 MB --
#tint2 38.0 MB  <<
#tumbler 26.5 MB > 13.9M
#unar 13.3 MB
#xfce4-notifyd 43.5 MB  <<
#xfce4-screenshooter 43.9 MB  <<
#xfsprogs 13.9 MB #log system
#yad 41.9 MB
#gnome-system-monitor 44.7M  <<
#plank 43.6 MB  <<
#+xprop: xmonad > x11-utils


# editListClean
$ cat size.md  |grep "<<" |awk '{print $1}' |sed "s/#//g"
    arandr
    catfish
    ...
```
