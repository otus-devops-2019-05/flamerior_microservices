core:
  hosts:
    gitlab_core:
      ansible_host: ${core_ext_ip}
stages:
  hosts:
    dev_stage:
      ansible_host: ${dev_ext_ip}
runners:
  hosts:
${runners_hosts}
  vars:
