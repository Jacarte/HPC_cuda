#include <stdio.h>
#include <cuda.h>

__global__ void cuda_hello(){
    int myId = blockIdx.x*blockDim.x +  threadIdx.x; // thread indexing
    printf("Hello World! My thread is %d\n", myId);
}

int main() {
  cuda_hello<<<1,256>>>();

  cudaError_t cudaerr = cudaDeviceSynchronize();
  if (cudaerr != cudaSuccess)
    printf("kernel launch failed with error \"%s\".\n",cudaGetErrorString(cudaerr));

  return 0;
}