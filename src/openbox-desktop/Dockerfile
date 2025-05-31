FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/fat-debian

# rsync 
RUN apt update \
  && apt -y install --no-install-recommends \
  psmisc htop rsync \
  openbox obconf tint2 geany xsettingsd thunar \
  lxappearance lxpolkit rofi dunst \
  && apt clean

# jgmenu
RUN apt update \
  && apt -y install --no-install-recommends \
  sudo net-tools tree tmux lrzsz lvm2 fuse \
  xterm gnome-system-monitor ristretto plank \
  aptitude feh compton xfce4-notifyd xbindkeys lxterminal gdebi catfish

# xrdp xorg
# RUN apt update \
#   && apt -y install tigervnc-standalone-server xrdp \
#   && apt clean \
#   && systemctl enable xrdp

# xvfb
RUN apt update \
  && apt -y install --no-install-recommends \
  xvfb x11vnc \
  && apt clean

# .dotfiles
# su - jumpadmin #just git clone
RUN git clone --depth=1 https://gitee.com/huapox/dotfiles /tmp/dotfiles \
  && cd /tmp/dotfiles/ \
  && rsync -avxHAXP --exclude '.git*' .* /root/ \
  && fc-cache -rv \
  && rm -rf /tmp/dotfiles

# http://git.ali.devcn.fun:81/g-dev1/fk-docker-xrdp/src/branch/sam-custom/lite/entry0.sh
ADD entry0.sh /entry0.sh
RUN chmod +x /entry0.sh
ENV DISPLAY :99
EXPOSE 22 3389 5900
# ENTRYPOINT ["/bin/systemd"]
ENTRYPOINT ["/entry0.sh"]


# tini+runsv
# ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /tini
# RUN chmod +x /tini
# apt install tini
# Get:1 http://mirrors.163.com/debian buster/main amd64 tini amd64 0.18.0-1 [247 kB] ##731 kB
RUN apt update \
  && apt -y install --no-install-recommends \
  tini runit dropbear \
  && apt clean
COPY --chown=root:root ./conf/etc/ /etc
RUN echo -e "#!/bin/bash\nexec tini -- runsvdir -P /etc/service/\n" > /entry1.sh \
  && chmod +x /entry1.sh && chmod +x -R /etc/service/*
ENV SSHD_PORT 22
ENTRYPOINT ["/entry1.sh"]

