#include <math.h>
#include <time.h>
#include "headers.h"
/**
 * Host main routine
 */
int main(void) {

    srand(time(NULL));

    dim3 grid1(4, 2, 2);
    dim3 block1(32, 32, 1);
    int maxNumElements = 4*2*2*32*32*1;

    int remaining2 = maxNumElements/(2*1*8*8), missing2grid = 0;
    while(missing2grid==0) {
      int tmp = 1 + rand()%remaining2;
      if(remaining2%tmp!=0) continue;
      if(2*tmp*1>1024||8*8*remaining2/tmp>1024) continue;
      missing2grid = tmp;
    }
    dim3 grid2(2, missing2grid, 1);
    dim3 block2(8, 8, remaining2/missing2grid);

    int remaining3 = maxNumElements/(1*1*128*1), missing3grid = 0;
    while(missing3grid==0) {
      int tmp = 1 + rand()%remaining3;
      if(remaining3%tmp!=0) continue;
      if(tmp*1*1>1024||128*remaining3/tmp*1>1024) continue;
      missing3grid = tmp;
    }
    dim3 grid3(missing3grid, 1, 1);
    dim3 block3(128, remaining3/missing3grid, 1);

    int numElements = 1 + rand()%maxNumElements;
    printf("[Linear Transformations on arrays of %d elements]\n", numElements);
    printf("CUDA kernel 1 launch with (%d,%d,%d) blocks of (%d,%d,%d) threads\n", 4, 2, 2, 32, 32, 1);
    printf("CUDA kernel 2 launch with (%d,%d,%d) blocks of (%d,%d,%d) threads\n", 2, missing2grid, 1, 8, 8, remaining2/missing2grid);
    printf("CUDA kernel 3 launch with (%d,%d,%d) blocks of (%d,%d,%d) threads\n", missing3grid, 1, 1, 128, remaining3/missing3grid, 1);


    size_t size = numElements * sizeof(float);
    float *h_A = (float*)malloc(size);
    float *h_B = (float*)malloc(size);
    float *h_C = (float*)malloc(size);
    float *h_aC = (float*)malloc(size);

    for (int i = 0; i < numElements; ++i) {
        h_A[i] = rand()/(float)RAND_MAX;
        h_B[i] = rand()/(float)RAND_MAX;
        if(log(sin(h_A[i])+cos(h_B[i]))<0)
          i--;
        else
          h_aC[i] = sqrt(log(sin(h_A[i])+cos(h_B[i])));
    }

    float *d_A, *d_B, *d_C1, *d_C2, *d_C;
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C1, size);
    cudaMalloc((void**)&d_C2, size);
    cudaMalloc((void**)&d_C, size);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    process_kernel1<<<grid1, block1>>>(d_A, d_B, d_C1, numElements);
    process_kernel2<<<grid2, block2>>>(d_C1, d_C2, numElements);
    process_kernel3<<<grid3, block3>>>(d_C2, d_C, numElements);

    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    for (int i = 0; i < numElements; ++i)
    {
      if (fabs(h_aC[i] - h_C[i]) > 1e-5)
      {
          fprintf(stderr, "Result verification failed at element %d!\n", i);
          fprintf(stderr, "%f\t%f\tActual %f, Calculated %f!\n", h_A[i], h_B[i], h_aC[i], h_C[i]);
          exit(EXIT_FAILURE);
      }
    }

    printf("Test PASSED\n");

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C1);
    cudaFree(d_C2);
    cudaFree(d_C);

    free(h_A);
    free(h_B);
    free(h_C);

    struct cudaDeviceProp test;
    cudaGetDeviceProperties(&test, 0);
    printf("Device Name: %s\n", test.name);





    cudaDeviceReset();
    return 0;
}
