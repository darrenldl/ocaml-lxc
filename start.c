#include <stdio.h>
#include <lxc/lxccontainer.h>

int main() {
    struct lxc_container *c;
    int ret = 1;
    /* Setup container struct */
    c = lxc_container_new("playtime2", NULL);

    if (!c) {
        fprintf(stderr, "Failed to setup lxc_container struct\n");
        goto out;
    }

    /* Start the container */

    if (!c->start(c, 0, (char**)NULL)) {
        fprintf(stderr, "Failed to start the container\n");
        goto out;
    }

out:
    return 0;
}
