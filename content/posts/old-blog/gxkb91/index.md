---
title: "手工安装git最新版"
date: "2019-10-12 11:25:20"
draft: false
---
**Step 1:** Install Required Packages<br />Firstly we need to make sure that we have installed required packages on your system. Use following command to install required packages before compiling Git source.
```
# yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
# yum install  gcc perl-ExtUtils-MakeMaker
```
**Step 2:** Uninstall old Git RPM<br />Now remove any prior installation of Git through RPM file or Yum package manager. If your older version is also compiled through source, then skip this step.
```
# yum remove git
```
**Step 3:** Download and Compile Git Source<br />Download git source code from kernel git or simply use following command to download Git 2.5.3.
```
# cd /usr/src
# wget https://www.kernel.org/pub/software/scm/git/git-2.5.3.tar.gz
# tar xzf git-2.5.3.tar.gz
```
After downloading and extracting Git source code, Use following command to compile source code.
```
# cd git-2.5.3
# make prefix=/usr/local/git all
# make prefix=/usr/local/git install
# echo 'pathmunge /usr/local/git/bin/' > /etc/profile.d/git.sh 
# chmod +x /etc/profile.d/git.sh
# source /etc/bashrc
```
**Step 4.** Check Git Version<br />On completion of above steps, you have successfully install Git in your system. Use the following command to check the git version
```
# git --version
git version 2.5.3
```
I also wanted to add that the "Getting Started" guide at the GIT website also includes instructions on how to download and compile it yourself:

