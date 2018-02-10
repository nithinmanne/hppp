#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
__global__ void d1conv(const float*, const float*, float*, const int);
__global__ void d2conv(const float*, const float*, float*, const int);
