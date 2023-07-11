#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


#define READ 0
#define WRITE 1
#define stdin 0
#define stdout 1
#define stderr 2
#define PRIMENUMS 35

void recuit(int* left)
{
    close(left[WRITE]);
    int pid, prime, temp, right[2];
    if(read(left[READ], &prime, sizeof(int)) != 0) {
        fprintf(stdout, "prime: %d\n", prime);
    }
    else {
        fprintf(stdout, "End of the primes...\n");
        close(left[READ]);
        exit(0);
    }

    pipe(right);

    if((pid = fork()) < 0) {
        fprintf(stderr, "Usage: fork failed...\n");
        close(right[READ]);
        close(right[WRITE]);
        close(left[READ]);
        exit(1);
    }
    else if (pid > 0)
    {
        close(right[READ]);
        /* parent proccess */
        while (read(left[READ], &temp, sizeof(int)) != 0)
        {
            if(temp % prime == 0) continue;

            write(right[WRITE], &temp, sizeof(int));
        }
        close(left[READ]);
        close(right[WRITE]);

        wait((int *)0);
        exit(0);
    }
    else {
        recuit(right);
        exit(0);
    }
    
}


int main(void)
{
    int pid, left[2];
    pipe(left);

    if((pid = fork()) < 0)
    {
        fprintf(stderr, "Usage: fork failed...\n");
        exit(1);
    }
    else if (pid > 0)
    {   
        /* parent proccess */
        close(left[READ]);
        for (int i = 2; i <= PRIMENUMS; i++)
        {
            write(left[WRITE], &i, sizeof(int));
        }
        
        close(left[WRITE]);
        wait((int *)0);
        exit(0);
        
    }
    else
    {
        recuit(left);
        exit(0);
    }
    
    
}
