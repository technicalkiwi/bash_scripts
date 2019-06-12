#!/bin/bash
TOKEN="##############"
CHATID="#########"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
SERVER="###########"
TIME="10"
TEXT="
A SSH login was successful, so here are some information for security:
  	User:        $PAM_USER
	Date:        `date`
	Server:      `uname -a`
"
if [ ${PAM_TYPE} = "open_session" ]; then
	
    curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT" $URL >/dev/null

    fi
exit 0
