[MSG] Starting build for 'perl5.004'
[MSG] Fetching 'http://cpan.hexten.net/src/5.0/perl5.004.tar.gz'
[MSG] Extracting '/home/chris/dev/perlmods/git/smoke-brew/build/perl5.004.tar.gz'
Running [./Configure -des -Dprefix=/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004 -Dusemallocwrap=y -Dusemymalloc=n]...
 
First let's make sure your kit is complete.  Checking...
Looks good...
Locating common programs...
Checking compatibility between /bin/echo and builtin echo (if any)...
Symbolic links are supported.
Good, your tr supports [:lower:] and [:upper:] to convert case.
3b1             dynixptx        isc             opus            svr4   
aix             epix            isc_2           os2             ti1500   
altos486        esix4           linux           powerux         titanos   
amigaos         fps             lynxos          qnx             ultrix_4   
apollo          freebsd         machten         sco             umips   
aux_3           genix           machten_2       sco_2_3_0       unicos   
bsdos           greenhills      mips            sco_2_3_1       unicosmk   
convexos        hpux            mpc             sco_2_3_2       unisysdynix   
cxux            i386            mpeix           sco_2_3_3       utekv   
cygwin32        irix_4          ncr_tower       sco_2_3_4       uts   
dcosx           irix_5          netbsd          solaris_2   
dec_osf         irix_6          next_3          stellar   
dgux            irix_6_0        next_3_0        sunos_4_0   
dynix           irix_6_1        next_4          sunos_4_1   
Which of these apply, if any? [netbsd]  
Operating system name? [netbsd]  
Operating system version? [3.1]  
What is your architecture name [i386-netbsd]  
AFS does not seem to be running...
Installation prefix to use? (~name ok)
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004]  
Pathname where the private library files will reside? (~name ok)
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004/lib]  
Getting the current patchlevel...
Where do you want to put the public architecture-dependent libraries? (~name ok)
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004/lib/i386-netbsd/5.004]  
Binary compatibility with Perl 5.003? [y]  
Other username to test security of setuid scripts with? [none]  
I'll assume setuid scripts are *not* secure.
Does your kernel have *secure* setuid scripts? [n]  
Do you want to do setuid/setgid emulation? [n]  
Pathname for the site-specific library files? (~name ok)
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004/lib/site_perl]  
Pathname for the site-specific architecture-dependent library files? (~name ok)
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004/lib/site_perl/i386-netbsd]  
Directory for your old 5.001 architecture-dependent libraries? (~name ok)
[none]  
Pathname where the public executables will reside? (~name ok)
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004/bin]  
System manual is in /usr/share/man/man1.
Which memory models are supported? [none]  
Use which C compiler? [cc]  
Checking for GNU cc in disguise and/or its version number...
Directories to use for library searches? [/usr/local/lib /lib /usr/lib]  
What is the file extension used for shared libraries? [so]  
Checking for optional libraries...
Any additional libraries? [-lm -lc -lposix -lcrypt]  
Now, how can we feed standard input to your C preprocessor...
What optimizer/debugger flag should be used? [-O]  
Any additional cc flags? [-I/usr/local/include]  
Let me guess what the preprocessor flags are...
Any additional ld flags (NOT including libraries)? [ -L/usr/local/lib]  
Checking your choice of C compiler, libs, and flags for coherency...
Checking for GNU C Library...
Shall I use nm to extract C symbols from the libraries? [y]  
Where is your C library? [/lib/libc.so]  
Extracting names from the following files for later perusal:
	/lib/libc.so
	/lib/libcrypt.so.0.2
	/lib/libm.so.0.2
	/usr/lib/libposix.so.0.1
This may take a while....done
Computing filename position in cpp output for #include directives...
<dld.h> NOT found.
dlopen() found.
Do you wish to use dynamic loading? [y]  
Source file to use for dynamic loading [ext/DynaLoader/dl_dlopen.xs]  
Any special flags to pass to cc -c to compile shared library modules?
[-DPIC -fPIC ]  
What command should be used to create dynamic libraries? [cc]  
Any special flags to pass to cc to create a dynamically loaded library?
[-Bforcearchive -Bshareable  -L/usr/local/lib]  
Any special flags to pass to cc to use dynamic loading? [none]  
Build a shared libperl.so (y/n) [no]  
Where do the main Perl5 manual pages (source) go? (~name ok)
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004/man/man1]  
What suffix should be used for the main Perl5 man pages? [1]  
You can have filenames longer than 14 characters.
Where do the Perl5 library man pages (source) go? (~name ok)
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004/man/man3]  
What suffix should be used for the Perl5 library man pages? [3]  
Figuring out host name...
Your host name appears to be "canker.bingosnet.co.uk". Right? [y]  
What is your domain name? [.bingosnet.co.uk]  
What is your e-mail address? [chris@canker.bingosnet.co.uk]  
Perl administrator e-mail address [chris@canker.bingosnet.co.uk]  
What shall I put after the #! to start up perl ("none" to not use #!)?
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004/bin/perl]  

WARNING:  Some systems limit the #! command to 32 characters.
If you experience difficulty running Perl scripts with #!, try
installing Perl in a directory with a shorter pathname.

Where do you keep publicly executable scripts? (~name ok)
[/home/chris/dev/perlmods/git/smoke-brew/prefix/perl5.004/bin]  
Use the experimental PerlIO abstraction layer? [n]  
gconvert NOT found.
gcvt NOT found.
sprintf found.
I'll use sprintf to convert floats into a string.
access() found.
<sys/file.h> defines the *_OK access constants.
alarm() found.
Checking whether your compiler can handle __attribute__ ...
bcmp() found.
bcopy() found.
<unistd.h> found.
getpgrp() found.
You have to use getpgrp() instead of getpgrp(pid).
setpgrp() found.
You have to use setpgrp(pid,pgrp) instead of setpgrp().
bzero() found.
Checking to see how big your integers are...
You have void (*signal())() instead of int.
Checking whether your C compiler can cast large floats to int32.
Checking whether your C compiler can cast negative float to unsigned.
vprintf() found.
Your vsprintf() returns (char*).
chown() found.
chroot() found.
chsize() NOT found.
Checking to see if your C compiler knows about "const"...
crypt() found.
cuserid() NOT found.
<limits.h> found.
<float.h> found.
DBL_DIG found.
difftime() found.
<dirent.h> found.
Your directory entries are struct dirent.
Good, your directory entry keeps length information in d_namlen.
dlerror() found.
<dlfcn.h> found.
What is the extension of dynamically loaded modules [so]  
Checking whether your dlsym() needs a leading underscore ...
I can't compile and run the test program.
dup2() found.
<sys/file.h> defines the O_* constants...
and you have the 3 argument form of open().
Figuring out the flag used by open() for non-blocking I/O...
Let's see what value errno gets from read() on a O_NONBLOCK file...
fchmod() found.
fchown() found.
fcntl() found.
fgetpos() found.
flock() found.
fork() found.
pathconf() found.
fpathconf() found.
fsetpos() found.
gethostent() found.
getlogin() found.
getpgid() found.
getpgrp2() NOT found.
getppid() found.
getpriority() found.
gettimeofday() found.
<netinet/in.h> found.
htonl() found.
Using <string.h> instead of <strings.h>.
strchr() found.
inet_aton() found.
isascii() found.
killpg() found.
link() found.
localeconv() found.
lockf() found.
lstat() found.
mblen() found.
mbstowcs() found.
mbtowc() found.
memcmp() found.
memcpy() found.
memmove() found.
memset() found.
mkdir() found.
mkfifo() found.
mktime() found.
msgctl() found.
msgget() found.
msgsnd() found.
msgrcv() found.
You have the full msg*(2) library.
<malloc.h> found.
<stdlib.h> found.
Do you wish to attempt to use the malloc that comes with perl5? [n]  
Your system wants malloc to return 'void *', it would seem.
Your system uses void free(), it would seem.
nice() found.
pause() found.
pipe() found.
poll() found.
<pwd.h> found.
readdir() found.
seekdir() found.
telldir() found.
rewinddir() found.
readlink() found.
rename() found.
rmdir() found.
<memory.h> found.
Checking to see if your bcopy() can do overlapping copies...
Checking to see if your memcpy() can do overlapping copies...
Checking to see if your memcmp() can compare relative magnitude...
select() found.
semctl() found.
semget() found.
semop() found.
You have the full sem*(2) library.
setegid() found.
seteuid() found.
setlinebuf() found.
setlocale() found.
setpgid() found.
setpgrp2() NOT found.
setpriority() found.
setregid() found.
setresgid() NOT found.
setreuid() found.
setresuid() NOT found.
setrgid() found.
setruid() found.
setsid() found.
<sfio.h> NOT found.
shmctl() found.
shmget() found.
shmat() found.
and it returns (void *).
shmdt() found.
You have the full shm*(2) library.
sigaction() found.
POSIX sigsetjmp found.
Hmm... Looks like you have Berkeley networking support.
socketpair() found.
Your stat() knows about block sizes.
Checking how std your stdio is...
strcoll() found.
Checking to see if your C compiler can copy structs...
strerror() found.
strtod() found.
strtol() found.
strtoul() found.
strxfrm() found.
symlink() found.
syscall() found.
sysconf() found.
system() found.
tcgetpgrp() found.
tcsetpgrp() found.
<sys/times.h> found.
times() found.
What type is returned by times() on this system? [clock_t]  
truncate() found.
tzname[] found.
umask() found.
uname() found.
vfork() found.
Some systems have problems with vfork().  Do you want to use it? [n]  
<sys/dir.h> found.
<sys/ndir.h> NOT found.
closedir() found.
Checking whether closedir() returns a status...
Checking to see if your C compiler knows about "volatile"...
wait4() found.
waitpid() found.
wcstombs() found.
wctomb() found.
Checking alignment constraints...
Doubles must be aligned on a how-many-byte boundary? [4]  
Checking to see how your cpp does stuff like catenate tokens...
<db.h> found.
Checking Berkeley DB version ...
Looks OK.  (Perl supports up to version 1.86).
Checking return type needed for hash for Berkeley DB ...
Checking return type needed for prefix for Berkeley DB ...
Checking to see how well your C compiler groks the void type...
  Support flag bits are:
    1: basic void declarations.
    2: arrays of pointers to functions returning void.
    4: operations between pointers to and addresses of void functions.
    8: generic void pointers.
What is the type for file position used by fsetpos()? [fpos_t]  
What is the type for group ids returned by getgid()? [gid_t]  
getgroups() found.
setgroups() found.
What type is the second argument to getgroups() and setgroups()? [gid_t]  
What type is lseek's offset on this system declared as? [off_t]  
Checking if your /usr/bin/make program sets $(MAKE)... Yup, it does.
What type is used for file modes? [mode_t]  
What pager is used on your system? [/usr/bin/less]  
Checking out function prototypes...
Checking to see how many bits your rand function produces...
How many bits does your rand() function produce? [31]  
Checking how to generate random libraries on your machine...
<sys/select.h> found.
Testing to see if we should include <time.h>, <sys/time.h> or both.
We'll include <sys/time.h>.
Well, your system knows about the normal fd_set typedef...
and you have the normal fd_set macros (just as I'd expect).
Your system uses fd_set * for the arguments to select.
Generating a list of signal names and numbers...
What type is used for the length parameter for string functions? [size_t]  
I'll be using ssize_t for functions returning a byte count.
Your stdio uses signed chars.
time() found.
What type is returned by time() on this system? [time_t]  
What is the type for user ids returned by getuid()? [uid_t]  
dbmclose() NOT found.
<sys/file.h> found.
We'll be including <sys/file.h>.
<fcntl.h> found.
We don't need to include <fcntl.h> if we include <sys/file.h>.
<grp.h> found.
<locale.h> found.
<math.h> found.
<ndbm.h> found.
dbm_open() found.
<net/errno.h> NOT found.
tcsetattr() found.
You have POSIX termios.h... good!
<stdarg.h> found.
<varargs.h> found.
We'll include <stdarg.h> to get va_dcl definition.
<stddef.h> found.
<sys/filio.h> found.
<sys/ioctl.h> found.
<sys/param.h> found.
<sys/resource.h> found.
<sys/stat.h> found.
<sys/types.h> found.
<sys/un.h> found.
<sys/wait.h> found.
<utime.h> found.
<values.h> NOT found.
<gdbm.h> NOT found.
Looking for extensions...
What extensions do you wish to load dynamically?
[DB_File Fcntl IO NDBM_File Opcode POSIX SDBM_File Socket]  
What extensions do you wish to load statically? [none]  
Stripping down executable paths...
Creating config.sh...
Doing variable substitutions on .SH files...
Extracting Makefile (with variable substitutions)
Extracting cflags (with variable substitutions)
Extracting config.h (with variable substitutions)
Extracting makeaperl (with variable substitutions)
Extracting makedepend (with variable substitutions)
Extracting makedir (with variable substitutions)
Extracting perl.exp
Extracting writemain (with variable substitutions)
Extracting x2p/Makefile (with variable substitutions)
Extracting x2p/cflags (with variable substitutions)
Run make depend now? [y]  
sh ./makedepend
sh writemain lib/auto/DynaLoader/DynaLoader.a  > tmp
sh mv-if-diff tmp perlmain.c
echo  av.c scope.c op.c doop.c doio.c dump.c hv.c mg.c perl.c perly.c pp.c pp_hot.c pp_ctl.c pp_sys.c regcomp.c regexec.c gv.c sv.c taint.c toke.c util.c deb.c run.c universal.c globals.c perlio.c miniperlmain.c perlmain.c | tr ' ' '\012' >.clist
Finding dependencies for av.o.
Finding dependencies for scope.o.
Finding dependencies for op.o.
Finding dependencies for doop.o.
Finding dependencies for doio.o.
Finding dependencies for dump.o.
Finding dependencies for hv.o.
Finding dependencies for mg.o.
Finding dependencies for perl.o.
Finding dependencies for perly.o.
Finding dependencies for pp.o.
Finding dependencies for pp_hot.o.
Finding dependencies for pp_ctl.o.
Finding dependencies for pp_sys.o.
Finding dependencies for regcomp.o.
Finding dependencies for regexec.o.
Finding dependencies for gv.o.
Finding dependencies for sv.o.
Finding dependencies for taint.o.
Finding dependencies for toke.o.
Finding dependencies for util.o.
Finding dependencies for deb.o.
Finding dependencies for run.o.
Finding dependencies for universal.o.
Finding dependencies for globals.o.
Finding dependencies for perlio.o.
Finding dependencies for miniperlmain.o.
Finding dependencies for perlmain.o.
echo Makefile.SH cflags.SH config_h.SH makeaperl.SH makedepend.SH  makedir.SH perl_exp.SH writemain.SH | tr ' ' '\012' >.shlist
Updating makefile...
test -s perlmain.c && touch perlmain.c
cd x2p; make depend
sh ../makedepend
echo hash.c  str.c util.c walk.c | tr ' ' '\012' >.clist
Finding dependencies for hash.o.
Finding dependencies for str.o.
Finding dependencies for util.o.
Finding dependencies for walk.o.
echo Makefile.SH cflags.SH | tr ' ' '\012' >.shlist
Updating makefile...
Now you must run a make.
Running [/usr/bin/make]...
make: don't know how to make <built-in>. Stop

make: stopped in /home/chris/dev/perlmods/git/smoke-brew/build/perl5.004
Use of uninitialized value in print at examples/buildperl.pl line 16.

