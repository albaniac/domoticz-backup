#!/bin/bash
    # LOCAL/FTP/SCP/MAIL PARAMETERS
    SERVER=""  	# IP of Synology NAS, used for ftp
    USERNAME=""         	# FTP username of Network disk used for ftp
    PASSWORD=""     # FTP password of Network disk used for ftp
    DESTDIR="/opt/backup"   		# used for temorarily storage
    DESTDIRNAS="/home/" 		# Path to your Synology NAS backup folder
    DOMO_IP="127.0.0.1"   		# Domoticz IP 
    DOMO_PORT="8080"        		# Domoticz port 
    ### END OF USER CONFIGURABLE PARAMETERS
    TIMESTAMP=`/bin/date +%Y%m%d%H%M%S`
    BACKUPFILE="domoticz.db" # backups will be named "domoticz_YYYYMMDDHHMMSS.db.gz"
    BACKUPFILEGZ="$BACKUPFILE".gz
    ### Create backup and ZIP it
    /usr/bin/curl -s http://$DOMO_IP:$DOMO_PORT/backupdatabase.php > /tmp/$BACKUPFILE
    gzip -5 /tmp/$BACKUPFILE
    tar -zcvf /tmp/domoticz_scripts.tar.gz /home/pi/domoticz/scripts/
    #tar -zcvf /tmp/telegram_scripts.tar.gz /home/pi/tg/scripts/
    ### Send to Network disk through FTP
    curl -s --disable-epsv -v -T"/tmp/$BACKUPFILEGZ" -u"$USERNAME:$PASSWORD" "ftp://$SERVER/$DESTDIRNAS"
    curl -s --disable-epsv -v -T"/tmp/domoticz_scripts.tar.gz" -u"$USERNAME:$PASSWORD" "ftp://$SERVER/$DESTDIRNAS"
    #curl -s --disable-epsv -v -T"/tmp/telegram_scripts.tar.gz" -u"$USERNAME:$PASSWORD" "ftp://$SERVER/$DESTDIRNAS"
    ### Remove temp backup file
    /bin/rm /tmp/$BACKUPFILEGZ
    /bin/rm /tmp/domoticz_scripts.tar.gz
    #/bin/rm /tmp/telegram_scripts.tar.gz
    ### Done!
