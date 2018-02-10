#include <stdio.h>
/**
 * Kernel routine
 */
__global__
void matrixSync(int* a, int size) {

    int id = threadIdx.x;

    if(id<size*size/2) {
        int i = id%size;
        int j = 2*(id/size);
        if(j+1!=size) {
            int tmp = a[i*size+j+1];
            a[i*size+j+1]=a[i*size+j];
            a[i*size+j]=tmp;
        }
    }
    __syncthreads();
    if(id<size*size) {
        int i = id%size;
        int j = id/size;
        if(i>j) {
            a[j*size+i] = a[i*size+j];
        }
    }

}
