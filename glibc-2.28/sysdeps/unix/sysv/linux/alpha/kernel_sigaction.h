#ifndef _KERNEL_SIGACTION_H
# define _KERNEL_SIGACTION_H

/* This is the sigaction structure from the Linux 3.2 kernel.  */
struct kernel_sigaction
{
  __sighandler_t k_sa_handler;
  unsigned int sa_flags;
  sigset_t sa_mask;
};

#endif
