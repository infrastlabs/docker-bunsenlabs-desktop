# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/fat-debian
FROM registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:library--debian---10-slim
ENV \
  DEBIAN_FRONTEND=noninteractive
# mirrors.tuna.tsinghua.edu.cn  mirrors.ustc.edu.cn
# mirrors.163.com  mirrors.aliyun.com  mirrors.tencentyun.com
ARG TARGETPLATFORM
RUN echo "Acquire {\n\
  APT::Get::Allow-Unauthenticated \"true\";\n\
  GPG::Ignore \"true\";\n\
  AllowInsecureRepositories \"true\";\n\
  AllowDowngradeToInsecureRepositories \"true\";\n\
}" > /etc/apt/apt.conf.d/skip-gpg-check-ig; \
  \
  # https://mirrors.ustc.edu.cn/help/debian.html #deb12: invalid signature
  # rm -f /etc/apt/sources.list.d/debian.sources; \
  sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources; \
  # apt 2.1.9 及以后的版本中，apt 的 HTTP Pipelining 特性与 Nginx 服务器疑似存在一定的不兼容问题
  echo "Acquire::http::Pipeline-Depth \"0\";" > /etc/apt/apt.conf.d/99nopipelining; \
  # 使用 HTTPS 可以有效避免国内运营商的缓存劫持，但需要事先安装 apt-transport-https (Debian Buster 及以上版本不需要)
  \
  echo 'apt update -qq && apt install -yq --no-install-recommends $@ && apt clean && rm -rf /var/lib/apt/lists/*; ' > /usr/local/bin/apt.sh \
    && chmod +x /usr/local/bin/apt.sh; 

# rsync 
RUN apt.sh \
  psmisc htop rsync \
  openbox obconf tint2 geany xsettingsd thunar \
  lxappearance lxpolkit rofi dunst

# jgmenu
RUN apt.sh \
  sudo net-tools tree tmux lrzsz lvm2 fuse \
  xterm gnome-system-monitor ristretto plank \
  aptitude feh compton xfce4-notifyd xbindkeys lxterminal gdebi catfish

# xrdp xorg
# RUN apt.sh tigervnc-standalone-server xrdp \
#   && systemctl enable xrdp

# xvfb
RUN apt.sh \
  xvfb x11vnc git

# .dotfiles
# su - jumpadmin #just git clone
RUN echo abc.123; exit 0; \
  git clone --depth=1 https://gitee.com/huapox/dotfiles /tmp/dotfiles \
  && cd /tmp/dotfiles/ \
  && rsync -avxHAXP --exclude '.git*' .* /root/ \
  && fc-cache -rv \
  && rm -rf /tmp/dotfiles

# http://git.ali.devcn.fun:81/g-dev1/fk-docker-xrdp/src/branch/sam-custom/lite/entry0.sh
ADD src/openbox-desktop/entry0.sh /entry0.sh
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
RUN apt.sh \
  tini runit dropbear

# ERROR: failed to solve: cannot copy to non-directory: /var/lib/buildkit/runc-overlayfs/cachemounts/buildkit161404099/etc/service
# COPY --chown=root:root ./src/openbox-desktop/conf/etc/ /etc/
# RUN chmod +x -R /etc/service/*;
  # echo -e "#!/bin/bash\nexec tini -- runsvdir -P /etc/service/\n" > /entry1.sh \
  # && chmod +x /entry1.sh && 
ENV SSHD_PORT 22
# ENTRYPOINT ["/entry1.sh"]
ENTRYPOINT ["tini", "--", "runsvdir -P /etc/service/"]

