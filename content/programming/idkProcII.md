---
title: "/proc los"
date: 2023-10-26T14:21:27+02:00
draft: false

---

# Background

This posts is a successor to [not knowing the /proc filesystem](/programming/idkproc)
The aim is to improve on at least one major shortcoming of the code
listing from the other post. The major fault with that program is that
it does not handle the case where the `/proc/$PID` disappears between
the call to `readdir` and the call to `fopen` with the status file.
To be honest, I was aware of this possibility while writing writing
the other program, but was temporarily uninspired to search for a
solution. ("Ideenlos" is German for uninspired, hence the title; I live
in Austria, hence the German).


# Understanding the problem

In order to better understand the problem, the following script can
be used to simulate what happens if a process disappears while we are
attempting to perform a read from the associated pseudo filesystem.
One of the side effects of my "lazybastarditis" is that I rarely have
spent time trying to use error codes that get provided with the system.
I followed the graph of header files from `<errno.h>`, and eventually
landed at:

```c
/* excerpt from /usr/include/asm-generic/errno-base.h */
/*...*/
#define	EPERM		 1	/* Operation not permitted */
#define	ENOENT		 2	/* No such file or directory */
#define	ESRCH		 3	/* No such process */
/*...*/
```

## Test runner

In order to simulate the program running into an issue where the process
it is trying to gather info about dies while attempting the read, it's
possible to use the following shell script. It basically sets two
timers `TOUTER` and `TINNER`, the former is passed as an argument to
the `sleep` command in the shell, which runs in the background while
`proclos` is started with the pid (output of `$!`) and the `TINNER`
timer. Within the c program below, the `sleep` function is called with
the larger time interval, to make sure that the process we are trying to
observe has enough time to die.

```sh
#!/usr/bin/sh

TOUTER=1
TINNER=2
sleep $TOUTER &
./proclos $! $TINNER
```

The following listing [sha 187e96](https://github.com/adammccartney/cscratch/commit/187e96075943c4cad36c1b94134f6b99409e1591)
is intentionally buggy and used to demonstrate what happens by running the test
above. The `fopen` manpage describes the return value as a `FILE` pointer on
successful completion, otherwise `NULL`. Furthermore, the errno is set to
indicate the error.

```c
/* proclos: test what happens if a process disappears between the call to
 *
 * program will attempt to read /proc/$PID/status file, but the process with
 * $PID will be killed between the call to readdir and the call to fopen on the 
 * /proc/$PID/status file.
 */
#include <dirent.h>
#include <stdarg.h>
#include <sys/stat.h>

#include "adio.h"
#include "cscratch_common.h"

#define MAXLINE 512
#define MAXFNAME 128
#define LPID 5
#define PROC "/proc"

/* check that string s contains only contiguous integer characters */
bool s_isinteger(const char* s) {
    bool result = (*s != '\0');
    while (*s != '\0') {
        if ((*s < '0') || (*s > '9')) {
            return false;
        }
        s++;
    }
    return result;
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        printf("usage: proclos <pid> <t>\n");
        exit(EPERM);
    }
    char* pid;
    pid = argv[1];
    if (!s_isinteger(pid)) {
        fprintf(stderr, "Error: invalid pid %s\n", pid);
        exit(EPERM);
    } 
    /* Otherwise set up the path we want to read */
    char fname[MAXFNAME];
    sprintf(fname, "/proc/%s/status", pid);

    int time;
    time = atoi(argv[2]);
    if (!time) {
        fprintf(stderr, "Error: %s not positive integer\n", argv[2]);
        exit(EPERM);
    }

    DIR* dirp;
    struct dirent* dp;
    FILE* fp;
    int fd;
    char* lone;
    struct stat sb;
    int size = 0;

    dirp = opendir(PROC);
    if (dirp) {
        errno = 0;
        if ((dp = readdir(dirp)) != NULL) {
            printf("e1: %d\n", errno);
            sleep(time); /* Sleep while the process gets killed */
            fp = fopen(fname, "r");
            printf("e2: %d\n", errno);
            fd = fileno(fp);
            if (fstat(fd, &sb) == -1) {
                return -1; /* just cheese it! */
            }
            lone = fgetLine(MAXLINE, fp);
            printf("%-24s pid:%-30.30s\n", lone, pid);
        }
        closedir(dirp);
    }
    return 0;
}
```

Compiling and running this version using the test runner, we can see
that `fopen` sets `errno` to 2 or `ENOENT`. Furthermore, we know from
the output that the attempted call to `fileno` causes the program to
segfault.

```sh
proc % ./proclos-runner.sh                                                                                                                   (proclos◆◆) ~/Code/cscratch/proc
e1: 0
e2: 2
./proclos-runner.sh: line 6: 369159 Segmentation fault      (core dumped) ./proclos $! $TINNER
zsh: exit 139   ./proclos-runner.sh
```

# Cleaning up the code

The minimal viable solution might look something like the following. As soon as
`fopen` returns `NULL`, the program is in a bad state and we have to act. In the
case of this example, we can just print an error message and exit.

```c
...
            fp = fopen(fname, "r");
            if (fp == NULL) {
                fprintf(stderr, "Error: fopen failed to complete with code %d\n", errno);
                exit(ESRCH); /* Process not found */
            }
...
```

Running the test again:

```sh
proc % ./proclos-runner.sh                                                                                                                    (proclos◆) ~/Code/cscratch/proc
Error: fopen failed to complete with code 2
zsh: exit 3     ./proclos-runner.sh
```

Commit [sha 95cf741](https://github.com/adammccartney/cscratch/commit/95cf741186daf8ccc2359113746c794945686e1f)
reflects the updated code.

# Digression:

> "Die Lage in Österreich ist hoffnungslos, aber nicht ernst."
>                                       - Alfred Polger, 1922

The situation in Austria is hopeless, but not serious.
