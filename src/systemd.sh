install_service() {
    case $1 in
    xray | v2ray)
        is_doc_site=https://xtls.github.io/
        [[ $1 == 'v2ray' ]] && is_doc_site=https://www.v2fly.org/
        echo -e "#!/sbin/openrc-run

name=\""$is_core"\"
command=\""$is_core_bin"\"
command_args=\"run -config "$is_config_json" -confdir "$is_conf_dir"\"
command_user=\"root\"

depend() {
    need net
    after firewall
}

start_pre() {
    # 这里可以添加脚本启动前的准备工作
    return 0
}

stop_pre() {
    # 这里可以添加脚本停止后的清理工作
    return 0
}
" >/etc/init.d/$is_core
        ;;
    caddy)
        echo -e "#!/sbin/openrc-run

#https://github.com/caddyserver/dist/blob/master/init/caddy.service and ChatGPT

name=\"caddy\"
command=\""$is_caddy_bin"\"
command_args=\"run --environ --config "$is_caddyfile" &\"
command_user=\"root\"

depend() {
    need net
    after firewall
}

start_pre() {
    # 这里可以添加脚本启动前的准备工作
    return 0
}

stop_pre() {
    # 这里可以添加脚本停止后的清理工作
    return 0
}
" >/etc/init.d/caddy
        ;;
    esac

    # enable, reload
    chmod a+x /etc/init.d/$is_core
    chmod a+x /etc/init.d/caddy
    rc-update add $1 default
    rc-service $is_core start
}
