FROM debian
RUN apt update
RUN apt install ssh curl wget npm nginx nano bash tmux qbittorrent-nox htop net-tools -y
RUN npm install -g wstunnel
RUN wget https://raw.githubusercontent.com/lhx11187/huochetou/main/default -O /etc/nginx/sites-available/default
RUN cd /root && mkdir /root/ttyd && wget -c -O /root/ttyd/ttyd https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64
RUN wget -c -O /root/v2ray-linux-64.zip https://github.com/v2fly/v2ray-core/releases/download/v4.43.0/v2ray-linux-64.zip
RUN unzip /root/v2ray-linux-64.zip -d /root/v2ray
RUN wget -c -O /root/verysync-linux-amd64-v2.11.0.tar.gz http://dl-cn.verysync.com/releases/v2.11.0/verysync-linux-amd64-v2.11.0.tar.gz
RUN cd /root && tar -zxvf verysync-linux-amd64-v2.11.0.tar.gz
RUN mv /root/verysync-linux-amd64-v2.11.0 /root/verysync
RUN wget -c -O /root/linux-amd64-webdav.tar.gz https://github.com/hacdias/webdav/releases/download/v4.1.1/linux-amd64-webdav.tar.gz
RUN cd /root && mkdir webdav && tar -zxvf linux-amd64-webdav.tar.gz -C /root/webdav/
RUN mkdir /run/sshd
RUN echo '/root/start.sh >/dev/null 2>&1 &' >>/1.sh
RUN echo 'wstunnel -s 0.0.0.0:8888 &' >>/1.sh
RUN echo '/usr/sbin/sshd -D' >>/1.sh
RUN echo '/root/ttyd/ttyd login bash >/dev/null 2>&1 &' >>/root/start.sh
RUN echo 'service nginx enable && service nginx start' >>/root/start.sh
RUN echo '/etc/init.d/nginx restart >/dev/null 2>&1 &' >>/root/start.sh
RUN echo 'qbittorrent-nox -d' >>/root/start.sh
RUN echo 'cd /root/verysync && ./start.sh >/dev/null 2>&1 &' >>/root/start.sh
RUN echo 'cd /root/v2ray && ./start.sh >/dev/null 2>&1 &' >>/root/start.sh
RUN echo 'cd /root/webdav && ./start.sh >/dev/null 2>&1 &' >>/root/start.sh
RUN echo 'cd /root/verysync' >>/root/verysync/start.sh
RUN echo 'killall -9 verysync' >>/root/verysync/start.sh
RUN echo './verysync -gui-address 0.0.0.0:8886 -no-browser -no-restart -logflags=0 >/dev/null 2>&1 &' >>/root/verysync/start.sh
RUN echo 'killall -9 v2ray' >>/root/v2ray/start.sh
RUN echo 'nohup ./v2ray &' >>/root/v2ray/start.sh
RUN echo 'killall -9 webdav' >>/root/webdav/start.sh
RUN echo './webdav -c ./config.yaml &' >>/root/webdav/start.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo root:password|chpasswd
RUN chmod 755 /1.sh
RUN chmod 755 /root/ttyd
RUN chmod 755 /root/start.sh
RUN chmod 755 /root/v2ray/start.sh
RUN chmod 755 /root/verysync/start.sh
RUN chmod 755 /root/webdav/start.sh
EXPOSE 80 8888 443 3306
CMD  /1.sh
