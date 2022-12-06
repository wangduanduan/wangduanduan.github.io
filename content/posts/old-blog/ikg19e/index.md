---
title: "Jenkins 全局变量参考"
date: "2019-10-15 22:34:01"
draft: false
---

# docker

The docker variable offers convenient access to Docker-related functions from a Pipeline script.

Methods needing a slave will implicitly run a node {…} block if you have not wrapped them in one. It is a good idea to enclose a block of steps which should all run on the same node in such a block yourself. (If using a Swarm server, or any other specific Docker server, this probably does not matter, but if you are using the default server on localhost it likely will.)

Some methods return instances of auxiliary classes which serve as holders for an ID and which have their own methods and properties. Methods taking a body return any value returned by the body itself. Some method parameters are optional and are enclosed with []. Reference:

- **withRegistry(url[, credentialsId]) {…}**<br />
Specifies a registry URL such as [https://docker.mycorp.com/](https://docker.mycorp.com/), plus an optional credentials ID to connect to it.
- **withServer(uri[, credentialsId]) {…}**<br />
Specifies a server URI such as tcp://swarm.mycorp.com:2376, plus an optional credentials ID to connect to it.
- **withTool(toolName) {…}**<br />
Specifies the name of a Docker installation to use, if any are defined in Jenkins global configuration. If unspecified, docker is assumed to be in the $PATH of the slave agent.
- **image(id)**<br />
Creates an Image object with a specified name or ID. See below.
- **build(image[, args])**<br />
Runs docker build to create and tag the specified image from a Dockerfile in the current directory. Additional args may be added, such as '-f Dockerfile.other --pull --build-arg http_proxy=http://192.168.1.1:3128 .'. Like docker build, args must end with the build context. Returns the resulting Image object. Records a FROM fingerprint in the build.
- **Image.id**<br />
The image name with optional tag (mycorp/myapp, mycorp/myapp:latest) or ID (hexadecimal hash).
- **Image.run([args, command])**<br />
Uses docker run to run the image, and returns a Container which you could stop later. Additional args may be added, such as '-p 8080:8080 --memory-swap=-1'. Optional command is equivalent to Docker command specified after the image. Records a run fingerprint in the build.
- **Image.withRun[(args[, command])] {…}**<br />
Like run but stops the container as soon as its body exits, so you do not need a try-finally block.
- **Image.inside[(args)] {…}**<br />
Like withRun this starts a container for the duration of the body, but all external commands (sh) launched by the body run inside the container rather than on the host. These commands run in the same working directory (normally a slave workspace), which means that the Docker server must be on localhost.
- **Image.tag([tagname])**<br />
Runs docker tag to record a tag of this image (defaulting to the tag it already has). Will rewrite an existing tag if one exists.
- **Image.push([tagname])**<br />
Pushes an image to the registry after tagging it as with the tag method. For example, you can use image.push 'latest' to publish it as the latest version in its repository.
- **Image.pull()**<br />
Runs docker pull. Not necessary before run, withRun, or inside.
- **Image.imageName()**<br />
The id prefixed as needed with registry information, such as docker.mycorp.com/mycorp/myapp. May be used if running your own Docker commands using sh.
- **Container.id**<br />
Hexadecimal ID of a running container.
- **Container.stop**<br />
Runs docker stop and docker rm to shut down a container and remove its storage.
- **Container.port(port)**<br />
Runs docker port on the container to reveal how the port port is mapped on the host.


# env

Environment variables are accessible from Groovy code as env.VARNAME or simply as VARNAME. You can write to such properties as well (only using the env. prefix):

```
env.MYTOOL_VERSION = '1.33'
node {
  sh '/usr/local/mytool-$MYTOOL_VERSION/bin/start'
}
```

These definitions will also be available via the REST API during the build or after its completion, and from upstream Pipeline builds using the build step.

However any variables set this way are global to the Pipeline build. For variables with node-specific content (such as file paths), you should instead use the withEnv step, to bind the variable only within a node block.

A set of environment variables are made available to all Jenkins projects, including Pipelines. The following is a general list of variables (by name) that are available; see the notes below the list for Pipeline-specific details.

- **BRANCH_NAME**<br />
For a multibranch project, this will be set to the name of the branch being built, for example in case you wish to deploy to production from master but not from feature branches.
- **CHANGE_ID**<br />
For a multibranch project corresponding to some kind of change request, this will be set to the change ID, such as a pull request number.
- **CHANGE_URL**<br />
For a multibranch project corresponding to some kind of change request, this will be set to the change URL.
- **CHANGE_TITLE**<br />
For a multibranch project corresponding to some kind of change request, this will be set to the title of the change.
- **CHANGE_AUTHOR**<br />
For a multibranch project corresponding to some kind of change request, this will be set to the username of the author of the proposed change.
- **CHANGE_AUTHOR_DISPLAY_NAME**<br />
For a multibranch project corresponding to some kind of change request, this will be set to the human name of the author.
- **CHANGE_AUTHOR_EMAIL**<br />
For a multibranch project corresponding to some kind of change request, this will be set to the email address of the author.
- **CHANGE_TARGET**<br />
For a multibranch project corresponding to some kind of change request, this will be set to the target or base branch to which the change could be merged.
- **BUILD_NUMBER**<br />
The current build number, such as "153"
- **BUILD_ID**<br />
The current build ID, identical to BUILD_NUMBER for builds created in 1.597+, but a YYYY-MM-DD_hh-mm-ss timestamp for older builds
- **BUILD_DISPLAY_NAME<br />
The display name of the current build, which is something like "#153" by default.
- **JOB_NAME**<br />
Name of the project of this build, such as "foo" or "foo/bar". (To strip off folder paths from a Bourne shell script, try: ${JOB_NAME##*/})
- **BUILD_TAG**<br />
String of "jenkins-${JOB_NAME}-${BUILD_NUMBER}". Convenient to put into a resource file, a jar file, etc for easier identification.
- **EXECUTOR_NUMBER**<br />
The unique number that identifies the current executor (among executors of the same machine) that’s carrying out this build. This is the number you see in the "build executor status", except that the number starts from 0, not 1.
- **NODE_NAME**<br />
Name of the slave if the build is on a slave, or "master" if run on master
- **NODE_LABELS**<br />
Whitespace-separated list of labels that the node is assigned.
- **WORKSPACE**<br />
The absolute path of the directory assigned to the build as a workspace.
- **JENKINS_HOME**<br />
The absolute path of the directory assigned on the master node for Jenkins to store data.
- **JENKINS_URL**<br />
Full URL of Jenkins, like [http://server](http://server):port/jenkins/ (note: only available if Jenkins URL set in system configuration)
- **BUILD_URL**<br />
Full URL of this build, like [http://server](http://server):port/jenkins/job/foo/15/ (Jenkins URL must be set)
- **JOB_URL**<br />
Full URL of this job, like [http://server](http://server):port/jenkins/job/foo/ (Jenkins URL must be set)<br />
The following variables are currently unavailable inside a Pipeline script:

SCM-specific variables such as SVN_REVISION<br />As an example of loading variable values from Groovy:

```
mail to: 'devops@acme.com',
    subject: "Job '${JOB_NAME}' (${BUILD_NUMBER}) is waiting for input",
    body: "Please go to ${BUILD_URL} and verify the build"
```


# params

Exposes all parameters defined in the build as a read-only map with variously typed values. Example:

```
if (params.BOOLEAN_PARAM_NAME) {doSomething()}
```

Note for multibranch (Jenkinsfile) usage: the properties step allows you to define job properties, but these take effect when the step is run, whereas build parameter definitions are generally consulted before the build begins. As a convenience, any parameters currently defined in the job which have default values will also be listed in this map. That allows you to write, for example:

properties([parameters([string(name: 'BRANCH', defaultValue: 'master')])])

```
git url: '…', branch: params.BRANCH
```

and be assured that the master branch will be checked out even in the initial build of a branch project, or if the previous build did not specify parameters or used a different parameter name.


# currentBuild

The currentBuild variable may be used to refer to the currently running build. It has the following readable properties:

- **number**<br />
build number (integer)
- **result**<br />
typically SUCCESS, UNSTABLE, or FAILURE (may be null for an ongoing build)
- **currentResult**<br />
typically SUCCESS, UNSTABLE, or FAILURE. Will never be null.
- **resultIsBetterOrEqualTo(String)**<br />
Compares the current build result to the provided result string (SUCCESS, UNSTABLE, or FAILURE) and returns true if the current build result is better than or equal to the provided result.
- **resultIsWorseOrEqualTo(String)**<br />
Compares the current build result to the provided result string (SUCCESS, UNSTABLE, or FAILURE) and returns true if the current build result is worse than or equal to the provided result.
- **displayName**<br />
normally #123 but sometimes set to, e.g., an SCM commit identifier
- **description**<br />
additional information about the build
- **id**<br />
normally number as a string
- **timeInMillis**<br />
time since the epoch when the build was scheduled
- **startTimeInMillis**<br />
time since the epoch when the build started running
- **duration**<br />
duration of the build in milliseconds
- **durationString**<br />
a human-readable representation of the build duration
- **previousBuild**<br />
another similar object, or null
- **nextBuild**<br />
similarly
- **absoluteUrl**<br />
URL of build index page
- **buildVariables**<br />
for a non-Pipeline downstream build, offers access to a map of defined build variables; for a Pipeline downstream build, any variables set globally on env
- **changeSets**<br />
a list of changesets coming from distinct SCM checkouts; each has a kind and is a list of commits; each commit has a commitId, timestamp, msg, author, and affectedFiles each of which has an editType and path; the value will not generally be Serializable so you may only access it inside a method marked [@NonCPS ]()
- **rawBuild**<br />
a hudson.model.Run with further APIs, only for trusted libraries or administrator-approved scripts outside the sandbox; the value will not be Serializable so you may only access it inside a method marked [@NonCPS ]() <br />
Additionally, for this build only (but not for other builds), the following properties are writable:<br />
result<br />
displayName<br />
description


# scm

Represents the SCM configuration in a multibranch project build. Use checkout scm to check out sources matching Jenkinsfile.<br />You may also use this in a standalone project configured with Pipeline script from SCM, though in that case the checkout will just be of the latest revision in the branch, possibly newer than the revision from which the Pipeline script was loaded.


# 参考

- [Global Variable Reference](https://qa.nuxeo.org/jenkins/pipeline-syntax/globals)

