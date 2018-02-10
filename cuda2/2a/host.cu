#include "headers.h"
/**
 * Host main routine
 */

#define SIZE 32
#define NUM_MAX 100000

int main() {
    srand(time(NULL));
    int *h_A, *d_A;
    size_t size = SIZE*SIZE*sizeof(int);
    h_A = (int*)malloc(size);
    cudaMalloc((void**)&d_A, size);
    printf("Original Array\n");
    for(int i=0;i<SIZE;i++) {
        for(int j=0;j<SIZE;j++) {
            h_A[i*SIZE+j] = rand()%NUM_MAX;
            printf("%d\t", h_A[i*SIZE+j]);
        }
        printf("\n");
    }
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    matrixSync<<<1, 1024>>>(d_A, SIZE);
    cudaMemcpy(h_A, d_A, size, cudaMemcpyDeviceToHost);
    printf("Modified Array\n");
    for(int i=0;i<SIZE;i++) {
        for(int j=0;j<SIZE;j++)
            printf("%d\t", h_A[i*SIZE+j]);
        printf("\n");
    }
}
