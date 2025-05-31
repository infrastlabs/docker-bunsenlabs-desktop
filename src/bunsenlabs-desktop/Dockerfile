# TODO: lighttpd: http,https repoServer.
# deb https://pkg.bunsenlabs.org/debian lithium main
# echo "127.0.0.1 pkg.bunsenlabs.org"
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/fat-debian

#docker build --pull -t off1 -f Dockerfile.repo .
#temp: just use off1 as baseImg
# FROM off1 
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-bunsen-repo
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-bunsenlabs-desktop:deian10-lithium-repo

# repo: +non-free
# mirrors.tuna.tsinghua.edu.cn  mirrors.ustc.edu.cn
# mirrors.163.com  mirrors.aliyun.com  mirrors.tencentyun.com
RUN domain="mirrors.ustc.edu.cn" \
 && echo "deb http://$domain/debian/ buster main contrib non-free" > /etc/apt/sources.list \
 && echo "deb http://$domain/debian/ buster-updates main contrib non-free">> /etc/apt/sources.list; 
RUN echo "deb [trusted=yes] file:///apt-repository/ sid main" >> /etc/apt/sources.list

# rsync 
RUN apt update \
  && apt install -y apt-transport-https bash sudo curl wget gnupg \
  && apt clean
RUN cd /bin && mv sh sh00 && ln -s /bin/bash sh

COPY ./src/bunsenlabs-desktop/pkgs-norecs-anay /pkgs-norecs
COPY ./src/bunsenlabs-desktop/pkgs-recs /pkgs-recs

# +jgmenu
RUN apt update \
  && items=($(sed 's/\#.*$//' pkgs-norecs)) \
  && apt -y install --no-install-recommends "${items[@]}" \
  && apt clean

# have unmet dependencies:
  #16 2.383  conky-all : Depends: libncurses6 (>= 6) but it is not going to be installed
  #16 2.383  hardinfo : Depends: zlib1g-dev but it is not going to be installed
RUN apt update \
  && apt -y install --no-install-recommends \
    arandr \
    catfish \
    # conky-all \
    galculator \
    galternatives \
    gsimplecal \
    # hardinfo \
    lxappearance \
    lxterminal \
    nitrogen \
    obconf \
    openbox \
    ristretto \
    thunar \
    thunar-gtkhash \
    thunar-media-tags-plugin \
    tint2 \
    xfce4-notifyd \
    xfce4-screenshooter \
    gnome-system-monitor \
    plank  \
  && apt clean
    

# have unmet dependencies:
#   2.433  bunsen-conky : Depends: conky-all but it is not going to be installed
#   2.433  bunsen-exit : Depends: policykit-1 but it is not going to be installed
RUN apt update \
  && items=($(sed 's/\#.*$//' pkgs-recs)) \
  && apt -y install --no-install-recommends "${items[@]}" \
  && apt clean

# +xprop: xmonad > x11-utils
#18 2.536 The following packages have unmet dependencies:
#18 2.572  xorgxrdp : Depends: xorg-input-abi-24
#18 2.572             Depends: xorg-video-abi-24
#18 2.572             Depends: xserver-xorg-core (>= 2:1.18.99.901) but it is not going to be installed
RUN apt update \
  &&  apt -y install --no-install-recommends \
  tigervnc-standalone-server xrdp \
  # xorgxrdp \
  fonts-noto jgmenu compton x11-utils \
  && apt clean
  # fonts-noto-cjk libqt5svg5 libexo-1-0 fbxkb \
  # gnome-themes-standard qt5-style-plugins tumbler \
#  10.01 /bin/sh: systemctl: command not found
# RUN systemctl enable xrdp

EXPOSE 22 3389
ENTRYPOINT ["/bin/systemd"]