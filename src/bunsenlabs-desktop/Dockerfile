# TODO: lighttpd: http,https repoServer.
# deb https://pkg.bunsenlabs.org/debian lithium main
# echo "127.0.0.1 pkg.bunsenlabs.org"
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/fat-debian

#docker build --pull -t off1 -f Dockerfile.repo .
#temp: just use off1 as baseImg
# FROM off1 
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-bunsen-repo

RUN domain="mirrors.163.com" \
 && echo "deb http://$domain/debian/ buster main contrib non-free" > /etc/apt/sources.list \
 && echo "deb http://$domain/debian/ buster-updates main contrib non-free">> /etc/apt/sources.list \
 && echo "deb [trusted=yes] file:///apt-repository/ sid main" >> /etc/apt/sources.list

# rsync 
RUN apt update \
  && apt install -y apt-transport-https bash sudo curl wget gnupg \
  && apt clean
RUN cd /bin && mv sh sh00 && ln -s /bin/bash sh

COPY ./pkgs-norecs-anay /pkgs-norecs
COPY ./pkgs-recs /pkgs-recs

# +jgmenu
RUN apt update \
  && items=($(sed 's/\#.*$//' pkgs-norecs)) \
  && apt -y install --no-install-recommends "${items[@]}" \
  && apt clean

RUN apt update \
  && apt -y install --no-install-recommends \
    arandr \
    catfish \
    conky-all \
    galculator \
    galternatives \
    gsimplecal \
    hardinfo \
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
    

RUN apt update \
  && items=($(sed 's/\#.*$//' pkgs-recs)) \
  && apt -y install --no-install-recommends "${items[@]}" \
  && apt clean

# +xprop: xmonad > x11-utils
RUN apt update \
  &&  apt -y install --no-install-recommends \
  tigervnc-standalone-server xrdp xorgxrdp \
  fonts-noto jgmenu compton x11-utils \
  && apt clean \
  && systemctl enable xrdp
  # fonts-noto-cjk libqt5svg5 libexo-1-0 fbxkb \
  # gnome-themes-standard qt5-style-plugins tumbler \

EXPOSE 22 3389
ENTRYPOINT ["/bin/systemd"]