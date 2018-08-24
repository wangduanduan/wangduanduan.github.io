---
title: GitLab JenKins 自动化构建
date: 2018-07-03 17:56:05
tags:
---

# 1. jenkins项目配置

## 1.1. 构建触发器设置

- 方框位置打钩
- 注意：椭圆圈住的位置的URL在下文中会用到, 该URL是JenKins自动生成的

如果你的项目中看不到这一项，那么你需要安装[Gitlab Plugin](https://wiki.jenkins.io/display/JENKINS/GitLab+Plugin)

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180703175934_fhIT2T_Jietu20180703-175910.jpeg)


## 1.2. 构建

注意：`$BUILD_NUMBER`是JenKins自带的一个环境变量，表示当前构建的次数。加上这个之后，每次构建产生的tag都不一样。

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180703180154_3EBgJo_Jietu20180703-180138.jpeg)

构建生成的项目名称如下图所示。

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180703180601_uyMlkh_Jietu20180703-180546.jpeg)

**Docker Build and Publish 高级设置**

`Skip Push` 默认情况该值处于选中状态，如果需要push到私有仓库，那么该项目要取消勾选。`如果你构建的项目没有push到私有仓库，那么就是该值引起的问题`


其他参数可以自行设置。

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180705162021_Nr0P43_Jietu20180705-161956.jpeg)


# 2. gitlab配置

## 2.1. 配置WebHooks

找到项目的 `projectX > Settings > Integrations`页面。

- 在椭圆中填入1.1章节中的URL
- 选中Push events
- 点击Add webhook

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180703180947_EvLieQ_Jietu20180703-180934.jpeg)

添加成功后，会在Add webhook按钮下出现 Webhooks列表，你可以点击某一个webhook后的Test按钮进行测试。

如果测试成功，jenkins那边会新建构建任务。

如果测试失败，gitlab这边会给出具体的错误信息。

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180703181150_q5E49m_Jietu20180703-181139.jpeg)


# 3. 高级技巧

## 3.2 构建节流

在使用GitLab CI自动构建项目时。正常情况GitLab项目的每次push，JenKins都会自动打包。

如果一样项目一分钟收到30次push, JenKins做30次打包是非常浪费资源的。通过设置构建节流，可以限制单位时间内JenKins的构建次数。

下图设置Throttle Builds每小时只能构建一次，但是允许用户手动构建时，跳过构建节流的限制。

![](https://wdd-images.oss-cn-shanghai.aliyuncs.com/20180704094538_Uf1RrX_Jietu20180704-094526.jpeg)


## 3.1. JenKins环境变量

jenkins还有更多的环境变量，可以在构建时读取出来，方便参数化构建。

例如你想获取当前构建的累积次数，可以用`$BUILD_NUMBER`

环境变量 | 描述
--- | ---
BUILD_URL | The URL where the results of this build can be found (e.g. http://buildserver/jenkins/job/MyJobName/666/)
EXECUTOR_NUMBER | The unique number that identifies the current executor (among executors of the same machine) that's carrying out this build. This is the number you see in the "build executor status", except that the number starts from 0, not 1.
NODE_NAME | The name of the node the current build is running on. Equals 'master' for master node.
BUILD_NUMBER | The current build number, such as "153"
BUILD_ID| The current build id, such as "2005-08-22_23-59-59" (YYYY-MM-DD_hh-mm-ss, defunct since version 1.597)
WORKSPACE| The absolute path of the workspace.
BUILD_TAG| String of jenkins-${JOB_NAME}-${BUILD_NUMBER}. Convenient to put into a resource file, a jar file, etc for easier identification.
JENKINS_URL|Set to the URL of the Jenkins master that's running the build. This value is used by Jenkins CLI for example
JOB_NAME|Name of the project of this build. This is the name you gave your job when you first set it up. It's the third column of the Jenkins Dashboard main page.
JAVA_HOME|If your job is configured to use a specific JDK, this variable is set to the JAVA_HOME of the specified JDK. When this variable is set, PATH is also updated to have $JAVA_HOME/bin.
SVN_REVISION | For Subversion-based projects, this variable contains the revision number of the module. If you have more than one module specified, this won't be set.
GIT_URL | For Git-based projects, this variable contains the Git url (like git@github.com:user/repo.git or [https://github.com/user/repo.git])
GIT_COMMIT | For Git-based projects, this variable contains the Git hash of the commit checked out for the build (like ce9a3c1404e8c91be604088670e93434c4253f03) (all the GIT_* variables require git plugin)    
GIT_BRANCH | For Git-based projects, this variable contains the Git branch that was checked out for the build (normally origin/master)
CVS_BRANCH | For CVS-based projects, this variable contains the branch of the module. If CVS is configured to check out the trunk, this environment variable will not be set.


# 参考
- [Building a software project](https://wiki.jenkins.io/display/JENKINS/Building+a+software+project)