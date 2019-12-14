/* System-dependent timing definitions.  FreeBSD version.
   Copyright (C) 1996-2017 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

/*
 * Never include this file directly; use <time.h> instead.
 */

#ifndef _BITS_TIME_H
#define _BITS_TIME_H	1

#include <bits/types.h>

/* ISO/IEC 9899:1999 7.23.1: Components of time
   The macro `CLOCKS_PER_SEC' is an expression with type `clock_t' that is
   the number per second of the value returned by the `clock' function.  */
/* CAE XSH, Issue 4, Version 2: <time.h>
   The value of CLOCKS_PER_SEC is required to be 1 million on all
   XSI-conformant systems. */
#define CLOCKS_PER_SEC  ((__clock_t) 1000000)

#if (!defined __STRICT_ANSI__ || defined __USE_POSIX) \
   && !defined __USE_XOPEN2K
/* Even though CLOCKS_PER_SEC has such a strange value CLK_TCK
   presents the real value for clock ticks per second for the system.  */
extern long int __sysconf (int);
# define CLK_TCK ((__clock_t) __sysconf (2))	/* 2 is _SC_CLK_TCK */
#endif

#ifdef __USE_POSIX199309
/* Identifier for system-wide realtime clock.  */
# define CLOCK_REALTIME			0
/* Monotonic system-wide clock.  */
# define CLOCK_MONOTONIC		4
/* These are BSD specific clocks.  */
# ifdef __USE_MISC
#  define CLOCK_VIRTUAL			1
#  define CLOCK_PROF			2
#  define CLOCK_UPTIME 			5  /* FreeBSD-specific. */
#  define CLOCK_UPTIME_PRECISE		7  /* FreeBSD-specific. */
#  define CLOCK_UPTIME_FAST		8  /* FreeBSD-specific. */
#  define CLOCK_REALTIME_PRECISE	9  /* FreeBSD-specific. */
#  define CLOCK_REALTIME_FAST		10 /* FreeBSD-specific. */
#  define CLOCK_MONOTONIC_PRECISE	11 /* FreeBSD-specific. */
#  define CLOCK_MONOTONIC_FAST		12 /* FreeBSD-specific. */
#  define CLOCK_SECOND			13 /* FreeBSD-specific. */
# endif
/* Thread-specific CPU-time clock.  */
# define CLOCK_THREAD_CPUTIME_ID	14
/* High-resolution timer from the CPU.  */
# define CLOCK_PROCESS_CPUTIME_ID	15
# ifdef __USE_MISC
#  define CPUCLOCK_WHICH_PID		0
#  define CPUCLOCK_WHICH_TID		1
# endif

/* Flag to indicate time is absolute.  */
# define TIMER_RELTIME			0 /* relative timer */
# define TIMER_ABSTIME			1 /* absolute timer */
#endif


/* Getkerninfo clock information structure */
struct clockinfo
  {
    int hz;		/* clock frequency */
    int tick;		/* micro-seconds per hz tick */
    int spare;
    int stathz;		/* statistics clock frequency */
    int profhz;		/* profiling clock frequency */
  };

#endif	/* bits/time.h */
