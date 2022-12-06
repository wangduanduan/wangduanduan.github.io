---
title: "pjsip"
date: "2019-09-08 13:02:46"
draft: false
---

# 环境说明
- centos7.6 docker 容器

# 过程

```bash
wget https://www.pjsip.org/release/2.9/pjproject-2.9.zip
unzip pjproject-2.9.zip
cd pjproject-2.9
chmod +x configure aconfigure
yum install gcc gcc-c++ make -y
make dep
make
make install
```


```bash
yum install centos-release-scl
yum install rh-python36
```


# 参考

- [https://www.pjsip.org/download.htm](https://www.pjsip.org/download.htm)
- [https://trac.pjsip.org/repos/wiki/Getting-Started](https://trac.pjsip.org/repos/wiki/Getting-Started)
- [https://trac.pjsip.org/repos/wiki/Getting-Started/Autoconf](https://trac.pjsip.org/repos/wiki/Getting-Started/Autoconf)
- [https://linuxize.com/post/how-to-install-python-3-on-centos-7/](https://linuxize.com/post/how-to-install-python-3-on-centos-7/)

