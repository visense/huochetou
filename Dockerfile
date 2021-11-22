FROM debian
RUN apt update
RUN apt install ssh curl wget npm nginx nano bash tmux qbittorrent-nox htop -y
RUN npm install -g wstunnel
RUN wget https://raw.githubusercontent.com/lhx11187/huochetou/main/default -O /etc/nginx/sites-available/default
RUN wget -c -O /root/ttyd https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64
#RUN wget https://raw.githubusercontent.com/MvsCode/frps-onekey/master/install-frps.sh -O ./install-frps.sh
#RUN chmod 700 ./install-frps.sh
#RUN sh -c '/bin/echo -e "2\n5130\n5131\n5132\n5133\nadmin\nadmin\n\n\n\n\n\n\n\n\n\n" | ./install-frps.sh install'
RUN mkdir /run/sshd
RUN echo '/root/start.sh >/dev/null 2>&1 &' >>/1.sh
RUN echo 'wstunnel -s 0.0.0.0:8888 &' >>/1.sh
RUN echo '/usr/sbin/sshd -D' >>/1.sh
#RUN echo '/root/ttyd login bash &' >>/1.sh
#RUN echo 'service nginx start' >>/1.sh
#RUN echo '/etc/init.d/nginx restart &' >>/1.sh
#RUN echo '/etc/init.d/frps restart' >>/1.sh
RUN echo '/root/ttyd login bash >/dev/null 2>&1 &' >>/root/start.sh
RUN echo 'service nginx enable && service nginx start' >>/root/start.sh
RUN echo '/etc/init.d/nginx restart >/dev/null 2>&1 &' >>/root/start.sh
RUN echo 'qbittorrent-nox -d' >>/root/start.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo root:7702843|chpasswd
RUN chmod 755 /1.sh
RUN chmod 755 /root/ttyd
RUN chmod 755 /root/start.sh
EXPOSE 80 8888 443 3306
CMD  /1.sh
