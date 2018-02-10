#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

#define M 3
#define N 3
#define O 3

int main() {
    FILE *fa, *fb;
    fa = fopen("A.txt", "r");
    fb = fopen("B.txt", "r");
    if(fa==NULL || fb==NULL) {
        fprintf(stderr, "File Open Error\n");
        exit(1);
    }
    int **a, **b, **c;
    a = malloc(M*sizeof(int*));
    b = malloc(N*sizeof(int*));
    c = malloc(M*sizeof(int*));
    for(int i=0;i<M;i++)
        a[i] = malloc(N*sizeof(int));
    for(int i=0;i<N;i++)
        b[i] = malloc(O*sizeof(int));
    for(int i=0;i<M;i++)
        c[i] = malloc(O*sizeof(int));

    for(int i=0;i<M;i++) {
        for(int j=0;j<N;j++)
            fscanf(fa, "%d ", &a[i][j]);
        fscanf(fa, "\n");
    }
    for(int i=0;i<N;i++) {
        for(int j=0;j<O;j++)
            fscanf(fb, "%d ", &b[i][j]);
        fscanf(fb, "\n");
    }

    double start;

    start = omp_get_wtime();
    #pragma omp parallel
    {
        #pragma omp for schedule(static)
            for(int i=0;i<M;i++)
                #pragma omp for schedule(static)
                    for(int j=0;j<O;j++) {
                        int s = 0;
                        for(int k=0;k<N;k++)
                            s += a[i][k]*b[k][j];
                        c[i][j] = s;
                    }
    }
    double static_time = omp_get_wtime() - start;
    printf("Time Taken: %lf\n", static_time);
    for(int i=0;i<M;i++)
        for(int j=0;j<O;j++)
            printf("C[%d][%d] = %d\n", i, j, c[i][j]);

}
