app:
  hosts:
    gitlab_core:
      ansible_host: ${app_ext_ip}
  vars:
db:
  hosts:
    dbserver: