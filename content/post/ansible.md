---
title: "Ansible"
date: 2017-09-11T15:48:07+08:00
tags: [ "Automation", "Devops" ]
draft: true
---

# Concept
- 功能：IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments or zero downtime rolling updates.
- 管理方式：**push-based** Ansible manages machines in an **agent-less** manner. Ansible by default manages machines **over the SSH protocol**. Because OpenSSH is one of the most peer-reviewed open source components, security exposure is greatly reduced.


# Requirement
- Control Machine: SSH client and Linux system
- Managed Node: Python 2.5+ and SSH service, or windows supprt w


# Nameing
- Control Machine
- Managed Node
- inventory
 - 定義Managed Node主機位址與群組
 - 設定SSH 連線資訊、SSH金鑰、使用者名稱....等
- Ad-Hoc command: 簡短一次性的指令
- PlayBook: 使用YAML格式撰寫的腳本，可使用Jinja(template系統)
 - 一個PlayBook可有多個Play跟Task
 - Play: 要跑的大項目標，與Managed Node
 - Task: 要做的工作細項
 - module: 已寫好的自動化模組
 - Roles: 是一種分類 & 重用的概念，透過將 vars, tasks, files, templates, handler … 等等根據不同的目的(例如：web server、db server)，規劃後至於獨立目錄中，後續便可以利用 include 的概念來使用。
- Galayx:  是一個搜尋、分享與下載 roles的網站
- facts: 實際上是ansible的setup module功能，用來取得Managed Node的系統變數資訊


# SSH connection issue
- 關閉SSH key host 檢查：在ansible.cfg內 host_key_checking = False
- 關閉gathering facts: 所有playbook不管有沒有設定gathering facts tasks，都會執行，可以在playbook中加入 gather_facts: no
- SSH PIPElinING: 預設為關閉，所以關閉的原因是要相容不同的 sudo設定，若不使用sudo可以在ansible.cfg內開啟 pipelining=True
- ControlPersist: 即持久化socket一次驗證，多次通信，只需要修改SSH client也就是Ansible Control Machine本身的SSH 設定
 - ~/.ssh/config
```
Host *
Compression yes
TCPKeepAlive yes
ServerAliveInterval 120
ServerAliveCountMax 5
ControlMaster auto
ControlPath ~/.ssh/sockets/%r@%h-%p
ControlPersist 1200

```


# module
## module_name   module arguments
```
ping            無參數
comand          -a 'ifconfig'
user            -a 'name= state={present(創建)|absent(刪除)} force=(是否強制操作刪除傢目錄) system= uid= shell= home='
group           -a 'name= state={present|absent} gid= system=(系統組)'
cron            -a 'name= state= minute= hour= day= month= weekday= job='
file            -a 'path= mode= owner= group= state={file|directory|link|hard|touch|absent} src=(link，鏈接至何處)'
copy            -a 'dest=(遠程主機上路徑) src=(本地主機路徑) content=(直接指明內容) owner= group= mode='
yum             -a 'name= state={present(已安裝)|latest(最新版)|absent(未安裝)}'
service         -a 'name= state=started|restarted|stopped|reloaded'
unarchive       -a 'src= dest= remote_src={True|False}'
lineinfile      -a ''
setup           無參數
```

## inventory for all hosts ssh settings
```
[all:vars]
ansible_connection=ssh
ansible_ssh_user='{{ user }}'
ansible_ssh_pass='{{ password }}'
ansible_become_pass='{{ password }}'
```

## inventory for Differentiate Staging vs Production
```
# file: production

[atlanta-webservers]
www-atl-1.example.com
www-atl-2.example.com

[boston-webservers]
www-bos-1.example.com
www-bos-2.example.com

[atlanta-dbservers]
db-atl-1.example.com
db-atl-2.example.com

[boston-dbservers]
db-bos-1.example.com

# webservers in all geos
[webservers:children]
atlanta-webservers
boston-webservers

# dbservers in all geos
[dbservers:children]
atlanta-dbservers
boston-dbservers

# everything in the atlanta geo
[atlanta:children]
atlanta-webservers
atlanta-dbservers

# everything in the boston geo
[boston:children]
boston-webservers
boston-dbservers
```


# syntax
## ansible syntax
```
ansible <Patterns> -m <module_name> -a <arguments> <Options>

Options:
--list-hosts        outputs a list of matching hosts
--module-name       module name to execute (default=command)
--args              module arguments
--user              connect as this user
--ask-pass          Prompt for the connection password
--become            Use privilege escalation
--ask-become-pass   Ask for privilege escalation password
--inventory         The PATH to the inventory, which defaults to /etc/ansible/hosts
--limit             further limit selected hosts to an additional pattern or comma separated host list.
--check             Check mode is just a simulation it will not make any changes on remote systems
--verbose           verbose mode (-vvv for more, -vvvv to enable connection debugging)
--background=       run asynchronously, failing after X seconds(default=N/A)
--poll              set the poll interval if using -B (default=15)
--forks             specify number of parallel processes to use(default=5)
--extra-vars        Extra variables to inject into a playbook, in key=value key=value format or as quoted YAML/JSON (hashes and arrays). To load variables from a file, specify the file preceded by @ (e.g. @vars.yml).
```

## example
```
ansible localhost -m ping #連本機自己,無須驗證
ansible localhost -m ping -i "localhost," -u 帳號 -k 密碼 --key-file=私鑰檔案
```

## ansible-playbook syntax
```
ansible-playbook playbook.yml <Options>

Options:
--check             Check mode is just a simulation it will not make any changes on remote systems
--inventory         The PATH to the inventory, which defaults to /etc/ansible/hosts
--limit             further limit selected hosts to an additional pattern
--list-hosts        outputs a list of matching hosts
--syntax-check      perform a syntax check on the playbook, but do not execute it
--tags=TAGS         only run plays and tasks tagged with these values
--flush-cache       clear the fact cache
```


## ansible-vault syntax
```
ansible-vault [create|decrypt|edit|encrypt|rekey|view] [--help] [options] vaultfile.yml

Options:
create foo.yml      建立加密 (Encrypted) 檔案。
edit foo.yml        編輯加密檔案內容。
rekey foo.yml       更換加密金鑰 (密碼)。
encrypt foo.yml     對已存在的明文檔案進行加密
decrypt foo.yml     解開 (Decrypt) 已加密檔案。
view foo.yml        檢視已加密的檔案內容。
```

## ansible playboox examples
### service
```
---
- hosts: all
  gather_facts: no
  tasks:
  - name: ensure enable_twrd is running
    service: name=enable_twrd state=started
```

### shell
```
---
- hosts: all
  gather_facts: no
  tasks:
  - name: enable twrd account
    shell: /etc/init.d/enable_twrd start
  - name: check twrd status
    shell: /etc/init.d/enable_twrd status
    register: ps
  - debug: var=ps.stdout_lines
```

### copy, unzip, file
```
---
- hosts: all
  gather_facts: no
  tasks:
  - name: copy news archive file to target news path
    copy:
      src: /root/news.zip
      dest: /mydlink/portal/web/_news/news.zip
  - name: unzip news archive file to target news path
    unarchive:
      src: /mydlink/portal/web/_news/news.zip
      dest: /mydlink/portal/web/_news/
      remote_src: True
  - name: change owner and permission to news files
    file:
      path: /mydlink/portal/web/_news/
      owner: webuser
      group: daemon
      mode: 0750
      recurse: yes
```

### Handlers,  If nothing notifies a handler, it will not run
```
- name: template configuration file
  template: src=template.j2 dest=/etc/foo.conf
  notify:
     - restart memcached
     - restart apache

  handlers:
    - name: restart memcached
      service: name=memcached state=restarted
    - name: restart apache
      service: name=apache state=restarted
```

### retry task
- Retry task 10 times with interval 1 second until return code of the command will not be 0. Ignore if even all tries will fail.
```
---
- hosts: all
  connection: local
  tasks:
      - shell: exit 1
        register: task_result
        until: task_result.rc == 0
        retries: 10
        delay: 1
        ignore_errors: yes

```

### Delegation, Rolling Updates, and Local Actions
- By default, Ansible will try to manage all of the machines referenced in a play in parallel. For a rolling updates use case, you can define how many hosts Ansible should manage at a single time by using the ‘’serial’’ keyword:
- examples:

```
---
- name: test play
  hosts: webservers
  service: name=httpd state=started
  serial: "30%"
---
- name: test play
  hosts: webservers
  service: name=httpd state=started
  serial: 3
---
- name: test play
  hosts: webservers
  serial:
  - 1
  - 5
  - "20%"
```

## ansible-playbook with sudo and vaults
- hosts
```
[all:vars]
ansible_connection=ssh
ansible_ssh_user='{{ ansible_ssh_user }}'
ansible_ssh_pass='{{ ansible_ssh_pass }}'
ansible_become_pass='{{ ansible_become_pass }}'
```

- yml
```
  ---
  - hosts: all
    gather_facts: no
    tasks:
    - name: restart sshd service
      shell: /etc/init.d/sshd restart
    - name: check sshd status
```

- vaults
 - ansible-vault edit YOUR-VAULT-FILE
```
ansible_ssh_user: YOUR_USER_NAME
ansible_ssh_pass: 'YOUR_PASSWORD'
ansible_become_pass: 'YOUR_SUDO_PASSWORD'
```

- run playbook with log output
```
echo "`ansible-playbook YOUR_PLAYBOOK.yml --inventory "localhost," --user --ask-ssh-pass --become --ask-become-pass --ask-vault-pass -e@YOUR_VAULT_FILE -vvv`" | tee -a LOG-FILE-PATH
```
