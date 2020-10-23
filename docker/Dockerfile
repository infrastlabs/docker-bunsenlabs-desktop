FROM debian:stretch-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN domain="mirrors.163.com" \
 && echo "deb http://$domain/debian/ stretch main contrib non-free" > /etc/apt/sources.list \
 && echo "deb http://$domain/debian/ stretch-updates main contrib non-free">> /etc/apt/sources.list


#&& apt-get install -y xfce4-session \
#git curl wget 
RUN apt-get update \
  && apt-get install -y rsync apt-transport-https bash sudo \
  && apt-get clean

RUN apt install -y xvfb x11vnc openbox tint2  

#RUN git clone https://gitee.com/g-system/fk-bunsen-netinstall && cd fk-bunsen-netinstall \
 #&& ls -lh 
#RUN bash install #be run from a terminal

COPY ./etc/apt/sources.list.d /etc/apt/sources.list.d
COPY ./etc/apt/trusted.gpg.d /etc/apt/trusted.gpg.d
COPY ./pkgs-norecs /pkgs-norecs
COPY ./pkgs-recs /pkgs-recs
RUN apt update && cd /bin && mv sh sh00 && ln -s /bin/bash sh
#RUN bash -c "recs=($( sed 's/\#.*$//' pkgs-recs )) && apt --quiet install \"${recs[@]}\""
RUN recs=($( sed 's/\#.*$//' pkgs-recs )) && apt -y -d install --no-install-recommends "${recs[@]}"
#RUN apt install -yd bunsen-paper-icon-theme bunsen-images

#ENTRYPOINT ["/startup.sh"]
EXPOSE 5900