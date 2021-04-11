FROM alpine:latest
MAINTAINER Ludovic MAILLET <Ludo.goodlinux@gmail.com>

ENV DOMAIN=test.maillet.me \ 
    CRONDELAY=*/5   \
    CONFFILE=/root/domain-settings   \
    TZ=Europe/Paris

RUN apk -U add python3 python3-dev py3-pip cargo openssl-dev gcc musl-dev libffi-dev curl apk-cron tzdata nano openresolv \ 
  && pip install pip domain-connect-dyndns --upgrade \
  && cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ >  /etc/timezone \ 
  && echo "echo '-----Begin-----------------------------------------------------------'" > /usr/local/bin/updateDomain \ 
  && echo "date"   >> /usr/local/bin/updateDomain  \ 
  && echo "domain-connect-dyndns update --all --config /root/dom-settings.txt"   >> /usr/local/bin/updateDomain \ 
  && echo "echo '-----End-------------------------------------------------------------'" >> /usr/local/bin/updateDomain \ 
  && echo "apk -U upgrade" > /usr/local/bin/updtPkg \ 
  && echo "name_servers=1.1.1.1" > /etc/resolvconf.conf  \ 
  && echo 'IPFILE=/var/local/currentip' 		> /usr/local/bin/chkip    \
  && echo 'NEW_IP=$(curl -s ifconfig.me)' 		>> /usr/local/bin/chkip    \
  && echo 'if [ ! -e $IPFILE ]; then' 			>> /usr/local/bin/chkip    \
  && echo '        curl -s ifconfig.me > $IPFILE' >> /usr/local/bin/chkip    \
  && echo 'fi' 									>> /usr/local/bin/chkip    \
  && echo 'CUR_IP=$(cat /var/local/currentip)' 	>> /usr/local/bin/chkip    \
  && echo 'if [ "$NEW_IP" != "$CUR_IP" ]; then' 	>> /usr/local/bin/chkip    \
  && echo '        echo $(date) " ==> $NEW_IP mise à jour demandée"' >> /usr/local/bin/chkip    \
  && echo '        /usr/local/bin/updateDomain' >> /usr/local/bin/chkip    \
  && echo '        curl -s ifconfig.me > $IPFILE' >> /usr/local/bin/chkip    \
  && echo 'else' 								>> /usr/local/bin/chkip    \
  && echo '        echo $(date) " ==> IP : $CUR_IP pas de mise à jour"' >> /usr/local/bin/chkip    \
  && echo 'fi' 									>> /usr/local/bin/chkip    \
  && echo '\$CRONDELAY     *       *       *       *       /usr/local/bin/chkip' >> /etc/crontabs/root \
  && echo '00     1       *       *       sun       /usr/local/bin/updtPkg' >> /etc/crontabs/root \  
  && echo "#! /bin/sh" > /usr/local/bin/entrypoint.sh \
  && echo "resolvconf -u" >> /usr/local/bin/entrypoint.sh  \
  && echo "if [ -e  \$CONFFILE ]  " >> /usr/local/bin/entrypoint.sh  \ 
  && echo "then "   >> /usr/local/bin/entrypoint.sh  \ 
  && echo "        crond -f"  >> /usr/local/bin/entrypoint.sh  \  
  && echo "else "   >> /usr/local/bin/entrypoint.sh  \ 
  && echo "        echo 'Le fichier $CONFFILE n existe pas Domaine : $DOMAIN '"  >> /usr/local/bin/entrypoint.sh  \ 
  && echo "        domain-connect-dyndns setup --domain \$DOMAIN --config \$CONFFILE "  >> /usr/local/bin/entrypoint.sh  \
  && echo "        crond -f " >> /usr/local/entrypoint.sh  \ 
  && echo "fi "   >> /usr/local/bin/entrypoint.sh  \
  && chmod a+x /usr/local/bin/*

# Lancement du daemon cron
#CMD /usr/local/bin/entrypoint.sh
CMD /bin/sh
