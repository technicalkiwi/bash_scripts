for IP in $(cat ./fws.txt)
do
echo "sshpass -f ~/.ssh/fwpass.conf -v ssh -o '"StrictHostKeyChecking no"' briadmin@$IP show inventory | tee ssh-session.log" > ./fw.sh
chmod +x ./fw.sh

  /usr/bin/expect <(cat << EOF
spawn ./fw.sh
expect "show inventory"
send -- "\r"
send -- "exit\r"
expect eof
interact
EOF
)

cat ssh-session.log >> log
done

