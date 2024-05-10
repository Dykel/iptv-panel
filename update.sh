#!/bin/bash
clear
apt install vnstat -y
pip3 install pycryptodome
pip3 install flask_cors
pip3 install Flask[async]
[[ ! -d /root/iptv-panel/templates ]] && {
    mkdir /root/iptv-panel/templates
}
curl -s "https://raw.githubusercontent.com/syfqsamvpn/iptv-panel/main/templates/reseller_users.html" >/root/iptv-panel/templates/reseller_users.html
curl -s "https://raw.githubusercontent.com/syfqsamvpn/iptv-panel/main/menu.sh" >/usr/bin/menu && chmod +x /usr/bin/menu
curl -s "https://raw.githubusercontent.com/syfqsamvpn/iptv-panel/main/start_bot.sh" >/usr/bin/start_bot.sh && chmod +x /usr/bin/start_bot.sh
#curl -s "https://raw.githubusercontent.com/syfqsamvpn/iptv-panel/main/ott_sam.sh" >/usr/bin/ott_sam.sh && chmod +x /usr/bin/ott_sam.sh
curl -s "https://raw.githubusercontent.com/syfqsamvpn/iptv-panel/main/main.py" >/root/iptv-panel/main.py
curl -s "https://raw.githubusercontent.com/syfqsamvpn/iptv-panel/main/system_ott.py" >/root/iptv-panel/system_ott.py
curl -s "https://raw.githubusercontent.com/syfqsamvpn/iptv-panel/main/reseller.py" >/root/iptv-panel/reseller.py
curl -s "https://raw.githubusercontent.com/syfqsamvpn/iptv-panel/main/pytransform/__init__.py" >/root/iptv-panel/pytransform/__init__.py
curl -s "https://raw.githubusercontent.com/syfqsamvpn/iptv-panel/main/pytransform/_pytransform.so" >/root/iptv-panel/pytransform/_pytransform.so

if [ "$(grep -wc "REFF_STAT" "/root/iptv-panel/data.txt")" == '0' ]; then
    echo 'REFF_STAT = "on"                                                                        # Should be on/off (case sensitive)' >>"/root/iptv-panel/data.txt"
fi
if [ "$(grep -wc "TELEGRAM_ADMIN_ID" "/root/iptv-panel/data.txt")" == '0' ]; then
    echo 'TELEGRAM_ADMIN_ID = "input_id_tele"                                                     # telegram admin id' >>"/root/iptv-panel/data.txt"
fi
if [ "$(grep -wc "VOD_FILE" "/root/iptv-panel/data.txt")" == '0' ]; then
    echo 'VOD_FILE = "vod.m3u"                                                                    # change this to change vod' >>"/root/iptv-panel/data.txt"
    touch "/root/iptv-panel/vod.m3u"
fi
if [ "$(grep -wc "PASSWORD_SEC" "/root/iptv-panel/data.txt")" == '0' ]; then
    echo 'PASSWORD_SEC = "on"                                                                     # Should be on/off (case sensitive)' >>"/root/iptv-panel/data.txt"
fi

if [ ! -d "/root/iptv-panel/secure/" ]; then
    mkdir -p "/root/iptv-panel/secure/"
fi
