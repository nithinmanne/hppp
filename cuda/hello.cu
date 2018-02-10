#include <cuda.h>
#include <stdio.h>

__global__
void vecAddKernel(float *A, float *B, float *C, int n) {
  int i = threadIdx.x+blockDim.x*blockIdx.x;
  printf("i: %d\n", i);
  if(i<n)
    C[i] = A[i] + B[i];
}

void vecAdd(float *A, float *B, float *C, int n) {
  int s = n*sizeof(float);
  float *d_A, *d_B, *d_C;
  cudaMalloc((void**)&d_A, s);
  cudaMalloc((void**)&d_B, s);
  cudaMalloc((void**)&d_C, s);
  cudaMemcpy(d_A, A, s, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, B, s, cudaMemcpyHostToDevice);

  vecAddKernel<<<ceil(n/2.0), 2>>>(d_A, d_B, d_C, n);

  cudaMemcpy(C, d_C, s, cudaMemcpyDeviceToHost);
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
}

int main() {
  float A[]={1,2,3,4,5};
  float B[]={2,3,4,5,6};
  float C[5];
  vecAdd(A,B,C,5);
  for(int i=0;i<5;i++) {
    printf("C[%d]=%f\n", i, C[i]);
  }
}
