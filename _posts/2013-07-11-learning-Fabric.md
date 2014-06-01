---
title: learning Fabric
author: zhuf
layout: post
published: true
permalink: 
category: tech, python, Fabirc
tags: python, fabric
---

[Fabric Documentation](http://docs.fabfile.org/en/1.6/index.html)

## About

Fabric is a Python (2.5 or higher) library and command-line tool for streamlining the use of SSH for application deployment or systems administration tasks.

It provides a basic suite of operations for executing local or remote shell commands (normally or via sudo) and uploading/downloading files, as well as auxiliary functionality such as prompting the running user for input, or aborting execution.

**********

### Typical use
<pre>
from fabric.api import run
def host_type():
    run('uname -a')
</pre>

> <span style="color:red">fabric.api includes almost functions.</span>

**********

<pre>
root@ubuntu:~# fab -H ubuntu-2 host_type
[ubuntu-2] Executing task 'host_type'
[ubuntu-2] run: uname -a
[ubuntu-2] Login password for 'root': 
[ubuntu-2] out: Linux ubuntu-2 3.2.0-23-generic-pae #36-Ubuntu SMP Tue Apr 10 22:19:09 UTC 2012 i686 i686 i386 GNU/Linux
[ubuntu-2] out: 


Done.
Disconnecting from ubuntu-2... done.
</pre>

> Usage: fab [options] <command>[:arg1,arg2=val2,host=foo,hosts='h1;h2',...] ...
> 
> Options:
> 
> >-H HOSTS, --hosts=HOSTS		<span style="color:red"> comma-separated list of hosts to operate on</span>
> 
> >-P, --parallel		<span style="color:red">default to parallel execution method</span>
> 
> >-R ROLES, --roles=ROLES	<span style="color:red">comma-separated list of roles to operate on</span>
> 
> >-l, --list            <span style="color:red">print list of possible commands and exit</span>
> 
> >-f PATH, --fabfile=PATH	<span style="color:red">config the path of  fabfile.py</span>


<pre>
def mysql_install():
    with lcd('/root'):
        put('mysql-5.6.12-linux-glibc2.5-i686.tar.gz', '/root')
        put('my.cnf', '/root/mysql')
    with cd('/root'):
        run('tar zxf mysql-5.6.12-linux-glibc2.5-i686.tar.gz')
        run('/root/mysql-5.6.12-linux-glibc2.5-i686/scripts/mysql_install_db --defaults-file=/root/mysql/my.cnf --basedir=/root/mysql-5.6.12-linux-glibc2.5-i686')
        run('nohup /root/mysql-5.6.12-linux-glibc2.5-i686/bin/mysqld_safe --defaults-file=/root/mysql/my.cnf >& /dev/null < /dev/null &')
 </pre>

# it doesn't work!!!
### The reason is:
>Because Fabric executes a shell on the remote end for each invocation of run or sudo (see also), backgrounding a process via the shell will not work as expected. Backgrounded processes may still prevent the calling shell from exiting until they stop running, and this in turn prevents Fabric from continuing on with its own execution.

**********

## the solution
<pre>
def mysql_install():
    with lcd('/root'):
        put('mysql-5.6.12-linux-glibc2.5-i686.tar.gz', '/root')
        put('my.cnf', '/root/mysql')
    with cd('/root'):
        run('tar zxf mysql-5.6.12-linux-glibc2.5-i686.tar.gz')
        run('/root/mysql-5.6.12-linux-glibc2.5-i686/scripts/mysql_install_db --defaults-file=/root/mysql/my.cnf --basedir=/root/mysql-5.6.12-linux-glibc2.5-i686')
        <span style="color:red">run("nohup /root/start.sh >& /dev/null < /dev/null &", pty=False)</span>
</pre>

<pre>
# start.sh
nohup /root/mysql-5.6.12-linux-glibc2.5-i686/bin/mysqld_safe --defaults-file=/root/mysql/my.cnf &
</pre>

**********

### .fabricrc

some default config for fabric

<pre>
# .fabricrc
port = 22
user = kevin
warn_only = True
...
</pre>

> the default fabricrc path: <span style="color:red">~/.fabricrc</span>

**********

### tasks

<pre>
local('pwd') -- exec local cmd
lcd('/tmp') --  switch to local path
cd('/tmp') --  switch to remote path
run('uname -a') --  exec remote cmd
sudo('/etc/init.d/nginx start') -- exec remote cmd as sudo privileges, <span style="color:red">shell=False</span> sometimes may usefull!
put('my.cnf', '/root/mysql') -- put the local file to remote path
</pre>

#### sub-task

<pre>
from fabric.api import task

@task
def migrate():
    pass

@task
def push():
    pass

@task
def provision():
    pass

@task
def full_deploy():
    if not provisioned:
        provision()
    push()
    migrate()
</pre>