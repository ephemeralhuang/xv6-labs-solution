#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define READ 0
#define WRITE 1


int main(void)
{
    int pid, p2c[2], c2p[2];

    pipe(p2c);
    pipe(c2p);

    char buf[512];

    if((pid = fork()) < 0) {
        fprintf(2, "Usage: fork failed...\n");
        exit(1);
    }
    else if (pid == 0)
    {
        /* child proccess */
        close(c2p[READ]);
        close(p2c[WRITE]);

        char* pong = "pong";

        read(p2c[READ], buf, sizeof(buf));
        close(p2c[READ]);
        printf("%d: received %s\n", getpid(), buf);

        write(c2p[WRITE], pong, strlen(pong));

        close(c2p[WRITE]);

        exit(0);
    }
    else
    {
        close(p2c[READ]);
        close(c2p[WRITE]);

        char* ping = "ping";

        write(p2c[WRITE], ping, strlen(ping));

        close(p2c[WRITE]);

        read(c2p[READ], buf, sizeof(buf));

        close(c2p[READ]);

        printf("%d: received %s\n", getpid(), buf);

        exit(0);

    }
    

}
