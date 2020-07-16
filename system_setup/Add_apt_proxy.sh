touch /etc/apt/apt.conf.d/10proxy.conf

echo 'Acquire::http::Proxy "http://192.168.10.206:3980";' >> /etc/apt/apt.conf.d/10proxy.conf
echo 'Acquire::https::Proxy "https://192.168.10.206:3980";'' >> /etc/apt/apt.conf.d/10proxy.conf
