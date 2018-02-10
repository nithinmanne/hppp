#include "headers.h"
/**
 * Host main routine
 */

#define D1SIZE 1024
#define D2SIZE 128
const float D1CONVMASK[] = { 1, 1, 0, 1, 1 };
const float D2CONVMASK[] = { 1./8, 1./8, 1./8, 1./8, 0, 1./8, 1./8, 1./8, 1./8 };
#define MAX 100

int main() {
    srand(time(NULL));

    // 1D
    printf("1D\n");
    size_t d1size = D1SIZE*sizeof(float);
    float *d1h_A, *d1d_A, *d1d_C, *d1h_O, *d1d_O;
    d1h_A = (float*)malloc(d1size);
    for(int i=0;i<D1SIZE;i++) d1h_A[i] = rand()%MAX;
    d1h_O = (float*)malloc(d1size);
    cudaMalloc((void**)&d1d_A, d1size);
    cudaMalloc((void**)&d1d_C, 5*sizeof(float));
    cudaMalloc((void**)&d1d_O, d1size);
    cudaMemcpy(d1d_A, d1h_A, d1size, cudaMemcpyHostToDevice);
    cudaMemcpy(d1d_C, D1CONVMASK, 5*sizeof(float), cudaMemcpyHostToDevice);
    int d1b = (int)ceil(D1SIZE/1024.);
    d1conv<<<d1b, 1024>>>(d1d_A, d1d_C, d1d_O, D1SIZE);
    cudaMemcpy(d1h_O, d1d_O, d1size, cudaMemcpyDeviceToHost);
    printf("Original Array\n");
    for(int i=0;i<D1SIZE;i++) printf("%f\n", d1h_A[i]);
    printf("Modified Array\n");
    for(int i=0;i<D1SIZE;i++) printf("%f\n", d1h_O[i]);

    //2D
    printf("2D\n");
    size_t d2size = D2SIZE*D2SIZE*sizeof(float);
    float *d2h_A, *d2d_A, *d2d_C, *d2h_O, *d2d_O;
    d2h_A = (float*)malloc(d2size);
    for(int i=0;i<D2SIZE*D2SIZE;i++) d2h_A[i] = rand()%MAX;
    d2h_O = (float*)malloc(d2size);
    cudaMalloc((void**)&d2d_A, d2size);
    cudaMalloc((void**)&d2d_C, 9*sizeof(float));
    cudaMalloc((void**)&d2d_O, d2size);
    cudaMemcpy(d2d_A, d2h_A, d2size, cudaMemcpyHostToDevice);
    cudaMemcpy(d2d_C, D2CONVMASK, 9*sizeof(float), cudaMemcpyHostToDevice);
    int d2b = (int)ceil(D2SIZE*D2SIZE/1024.);
    d2conv<<<d2b, 1024>>>(d2d_A, d2d_C, d2d_O, D2SIZE);
    cudaMemcpy(d2h_O, d2d_O, d2size, cudaMemcpyDeviceToHost);
    printf("Original Array\n");
    for(int i=0;i<D2SIZE;i++,printf("\n"))
        for(int j=0;j<D2SIZE;j++)
            printf("%f\t", d2h_A[i*D2SIZE+j]);
    printf("Modified Array\n");
    for(int i=0;i<D2SIZE;i++,printf("\n"))
        for(int j=0;j<D2SIZE;j++)
            printf("%f\t", d2h_O[i*D2SIZE+j]);
}
