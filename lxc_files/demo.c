#include <stdio.h>

#include <lxc/lxccontainer.h>

int main() {
    struct lxc_container *c;
    int ret = 1;

    /* Setup container struct */
    c = lxc_container_new("apicontainer", NULL);
    if (!c) {
        fprintf(stderr, "Failed to setup lxc_container struct\n");
        goto out;
    }

    if (c->is_defined(c)) {
        fprintf(stderr, "Container already exists\n");
        goto out;
    }

    /* Create the container */
    if (!c->createl(c, "download", NULL, NULL, LXC_CREATE_QUIET,
                    "-d", "ubuntu", "-r", "trusty", "-a", "i386", NULL)) {
        fprintf(stderr, "Failed to create container rootfs\n");
        goto out;
    }

    /* Start the container */
    if (!c->start(c, 0, NULL)) {
        fprintf(stderr, "Failed to start the container\n");
        goto out;
    }

    /* Query some information */
    printf("Container state: %s\n", c->state(c));
    printf("Container PID: %d\n", c->init_pid(c));

    /* Stop the container */
    if (!c->shutdown(c, 30)) {
        printf("Failed to cleanly shutdown the container, forcing.\n");
        if (!c->stop(c)) {
            fprintf(stderr, "Failed to kill the container.\n");
            goto out;
        }
    }

    /* Destroy the container */
    if (!c->destroy(c)) {
        fprintf(stderr, "Failed to destroy the container.\n");
        goto out;
    }

    ret = 0;
out:
    lxc_container_put(c);
    return ret;
}
