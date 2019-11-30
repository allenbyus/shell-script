CentOS 7 的 SELinux 及 Firewalld 防火牆都是安全相關的套件, RHEL 及 CentOS 均預設開啟, 但如果在開發或測試的機器上, 將它們關閉對除錯方便不少。

關閉 SELinux:

開啟檔案 /etc/selinux/config:
```# vi /etc/selinux/config```

找到以下一行:

```SELINUX=enforce```

改成:

```SELINUX=disabled```

另外將 “`SELINUXTYPE=targeted`” 加上註釋, 改成這樣:

```# SELINUXTYPE=targeted```

儲存後離開編輯器, 需要重新開機設定才會生效。

要檢查 SELinux 的狀態, 執行 sestatus 指令便可以看到:
```sestatus```

關閉 Firewalld 防火牆:

關閉 Firewalld 防火牆指令:
```systemctl stop firewalld.service```

設定下次開機不會啟動 Firewalld 防火牆
```systemctl disable firewalld.service```
