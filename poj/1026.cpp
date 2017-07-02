#include <stdio.h>
#include <string.h>

int n, k;


void encode(char *msg, int *pos) {
    char tmp[n];
    for (int i = 0; i < n; i++) tmp[pos[i]-1] = msg[i];
    memcpy(msg, tmp, n);
}


int step(int *pos) {
    char test[n+1], original[n+1];
    for (int i = 0; i < n; i++) test[i] = i+1;
    test[n] = '\0'; memcpy(original, test, n+1);

    encode(test, pos); int ret = 1;
    while (strcmp(test, original)) { encode(test, pos); ret++; }
    return ret;
}


int main() {
    while (scanf("%d", &n) && n > 0) {
        char msg[n+1]; int pos[n];
        for (int i = 0; i < n; i++) scanf("%d", &pos[i]);
        int s = step(pos);

        while (scanf("%d", &k) && k > 0) {
            scanf(" %[^\n]s", &msg);
            for (int i = strlen(msg); i < n; i++) msg[i] = ' ';
            msg[n] = '\0';
            for (int i = 0; i < (k % s); i++) encode(msg, pos);
            printf("%s\n", msg);
        }

        printf("\n");
    }

    return 0;
}
