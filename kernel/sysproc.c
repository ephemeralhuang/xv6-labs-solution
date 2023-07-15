#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  backtrace();

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#ifdef LAB_PGTBL
#define MAXSCANNEDPAGES 64
int
sys_pgaccess(void)
{
  uint64 va;
  argaddr(0,&va);

  int npages;
  argint(1, &npages);

  uint64 mask_addr;

  argaddr(2, &mask_addr);

  struct proc* p = myproc();
  pagetable_t pagetable = p->pagetable;

  va = PGROUNDDOWN(va);
  uint64 bits = 0;
  for (int j =0; j < npages; j++)
  {
    /* code */
    pte_t *pte = walk(pagetable, va+j*PGSIZE, 0);
    if(pte == 0)
      panic("page not exist.");
    if (PTE_FLAGS(*pte) & PTE_A)
    {
      /* code */
      bits = bits | (1L << j);
    }
    *pte = *pte & ~PTE_A;
  }
  
  copyout(pagetable,mask_addr, (char *)&bits, sizeof(bits));
  return 0;

}
#endif

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64 sys_sigalarm()
{
  int ticks;
  uint64 handler_va;

  argint(0, &ticks);
  argaddr(1, &handler_va);
  struct proc* proc = myproc();

  proc->alarm_interval = ticks;
  proc->handler_va = handler_va;
  proc->have_return = 1;
  return 0;
}

uint64 sys_sigreturn()
{
  struct proc* proc = myproc();

  *proc->trapframe = proc->saved_trapframe;
  proc->have_return = 1;
  return proc->trapframe->a0;
}
