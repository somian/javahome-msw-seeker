Many Java software installations (Ant, Groovy, etc) require an environment variable `JAVA_HOME` to be predefined in the system (or per-user) environment in order to run. Such installations often include startup scripts that check for `JAVA_HOME` and won't proceed unless `JAVA_HOME` is set.

`JAVA_HOME` is expected to have a value which is a path to the top of a Java installation tree (and would for example have a subdirectory `bin/` under it).

**javahome-msw-seeker** provides a .bat file (interpreted and executed by the MS Windows NT native command ‘shell’) which can be used to determine the path to assign as `JAVA_HOME` based on Windows Registry entries which record the presence of Sun Java™ **Software Development Kit** or **Java runtime environment™** (**JRE**) installations. This .bat script will `SET JAVA_HOME=` with the most recent Java top-level directory path found (and actually existing in the filesystem).

Because its only action is to _SET_ an variable in the current process ENV, the .bat script is intended as one that should be _CALL_ ‍–ed from another Windows .bat (or .cmd) script.

If the statements in the paragraph above this one are not clear to the reader, the reader is probably someone who should not attempt to use this software. This software (.bat script) is not supported for beginners. The author/maintainer won't reply to queries asking what _CALL_ or _SET_, for example, mean in the context of MS Windows CMD.exe interpreter syntax.


---


# Implementation Notes #

**javahome-msw-seeker** actually uses an obscure feature of the **perl** interpreter in order to lead a double life as both a .bat script and a Perl script. So **javahome-msw-seeker** is implemented in Perl even though the first line of the file does not resemble the typical
```
     #! perl
```
shebang line that one expects to see.

The Perl part does its Windows Registry sniffing with the [Win32::TieRegistry](http://cpan.uwinnipeg.ca/dist/Win32-TieRegistry) Perl module. This CPAN module must be installed before **javahome-msw-seeker** can work.


---


# Tested On #

So far the script has been tested on variants of NT-decendents including:
  * **Vista** (Home)
  * **XP** w/ **SP3** (Home)
  * **XP** w/ **SP3** (Professional)

_Important_:
I don't intend this software to be used on obsolete lines of MS Windows releases,
so please don't attempt to run it on Windows 9x or ME.


---


> _Sun, Sun Microsystems, Sun Java, Sun Java runtime environment, etc. are trademarks
> or registered trademarks of Sun Microsystems, Inc. in the United States and other
> countries. Mention of these trademarked phrases on this website is not intended
> as any claim of ownership of these phrases by the author of the software featured
> here._