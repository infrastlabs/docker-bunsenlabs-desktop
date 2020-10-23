

--no-install-recommends

recs=($( sed 's/\#.*$//' pkgs-recs )) 
echo "${recs[@]}"
apt install "${recs[@]}" #218 MB
apt install --no-install-recommends "${recs[@]}" #134 MB

apt download "${recs[@]}"



wget https://asia.pkg.bunsenlabs.org/debian/pool/main/b/bunsen-images/bunsen-images_9.4.7-2_all.deb

wget https://asia.pkg.bunsenlabs.org/debian/pool/main/p/paper-icon-theme/paper-icon-theme_1.4%2Br696.d2476a62-1_all.deb

apt install -yd bunsen-paper-icon-theme bunsen-images



## debug

apt install procps #ps free

xvfb-run -s ":99" -s '-screen 0 1024x700x24 -ac' openbox-session
x11vnc -display :99 -forever -nopw


apt install thunar #25M

recs=($( sed 's/\#.*$//' pkgs-norecs )) 
apt install --no-install-recommends "${recs[@]}" #251 MB >> 208MB(- x2: bsnux_big_deb)




