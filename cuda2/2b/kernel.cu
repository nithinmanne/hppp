#include <stdio.h>
/**
 * Kernel routine
 */
__global__
void d1conv(const float* a, const float *c, float *o, const int size) {
    int id = blockDim.x * blockIdx.x + threadIdx.x;
    if(id<size) {
        float co = 0;
        for(int i=id-2;i<=id+2;i++)
            if(i>=0&&i<size)
                co += a[i]*c[i-id+2];
        o[id] = co;
    }
}

__global__
void d2conv(const float* a, const float *c, float *o, const int size) {
    int id = blockDim.x * blockIdx.x + threadIdx.x;
    if(id<size*size) {
        int idi = id/size;
        int idj = id%size;
        float co = 0;
        for(int i=idi-1;i<=idi+1;i++)
            if(i>=0&&i<size)
                for(int j=idj-1;j<=idj+1;j++)
                    if(j>=0&&j<size)
                        co += a[i*size+j]*c[(i-idi+1)*size+(j-idj+1)];
        o[idi*size+idj] = co;
    }
}
