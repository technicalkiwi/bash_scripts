#!/bin/bash

CHATID="1234"
KEY="abcd"
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="Hello world"

curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT" $URL >/dev/null
