---
title: "编译FS"
date: "2019-12-10 11:25:04"
draft: false
---
- make clean - Cleans the build environment
- make current - Cleans build environment, performs an git update, then does a make install
- make core_install (or make install_core) - Recompiles and installs just the core files. Handy if you are working on a core file and want to recompile without doing the whole shebang.
- make mod_XXXX-install - Recompiles and installs just a single module. Here are some examples:
   - make mod_openzap-install
   - make mod_sofia-install
   - make mod_lcr-install
- make samples - This will not replace your configuration. This will instead make the default extensions and dialplan to run the basic configuration of FreeSWITCH.

