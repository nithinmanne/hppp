#include <stdio.h>

__device__
int geti() {
  int i = blockIdx.z;
  i = i*gridDim.y + blockIdx.y;
  i = i*gridDim.x + blockIdx.x;
  i = i*blockDim.z + threadIdx.z;
  i = i*blockDim.y + threadIdx.y;
  i = i*blockDim.x + threadIdx.x;
  return i;
}

__global__
void process_kernel1(const float *A, const float *B, float *C, const int numElements)
{
    int i = geti();

    if (i < numElements)
    {
        C[i] = sin(A[i]) + cos(B[i]);
    }
}

__global__
void process_kernel2(const float *A, float *C, const int numElements)
{
    int i = geti();

    if (i < numElements)
    {
        C[i] = log(A[i]);
    }
}

__global__
void process_kernel3(const float *A, float *C, const int numElements)
{
    int i = geti();

    if (i < numElements)
    {
        C[i] = sqrt(A[i]);
    }
}
