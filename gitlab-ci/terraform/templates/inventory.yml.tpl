app:
  hosts:
    appserver:
      ansible_host: ${app_ext_ip}
  vars:
    db_int_ip: ${db_int_ip}
db:
  hosts:
    dbserver:
      ansible_host: ${db_ext_ip}
