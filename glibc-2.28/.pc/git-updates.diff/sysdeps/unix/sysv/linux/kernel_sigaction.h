#ifndef _KERNEL_SIGACTION_H
# define _KERNEL_SIGACTION_H

/* This is the sigaction structure from the Linux 3.2 kernel.  */
struct kernel_sigaction
{
  __sighandler_t k_sa_handler;
  unsigned long sa_flags;
#ifdef SA_RESTORER
  void (*sa_restorer) (void);
#endif
  sigset_t sa_mask;
};

#ifndef SA_RESTORER
# define SET_SA_RESTORER(kact, act)
# define RESET_SA_RESTORER(act, kact)
#endif

#endif
