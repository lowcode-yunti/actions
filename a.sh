#!/bin/bash
# 启动前运行的脚本
export PATH='/etc/storage/bin:/tmp/script:/etc/storage/script:/opt/usr/sbin:/opt/usr/bin:/opt/sbin:/opt/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin'
export LD_LIBRARY_PATH=/lib:/opt/lib

# 解压到 /opt/bin 目录
unzip /tmp/v2ray.zip -d /opt/bin
# 清理安装包
rm /tmp/v2ray.zip
# 设定执行权限
chmod +x /opt/bin/v2ray
echo "v2ray 安装完成。"
else
echo "v2ray 已安装。"
fi

# 配置 V2Ray
server_addresses=$(cat /etc/storage/v2ray_config_script.sh | tr -d ' ' | grep -Eo '"address":.+' | grep -v 8.8.8.8 | grep -v google.com | grep -v 114.114.114.114 | grep -v 119.29.29.29 | grep -v 223.5.5.5 | sed -n '1p' | cut -d':' -f2 | cut -d'"' -f2)
v2ray_door=`nvram get v2ray_door`
[ -z $v2ray_door ] && v2ray_door=1099 && nvram set v2ray_door=1099
lan_ipaddr=`nvram get lan_ipaddr`
