#include <stdio.h>
#include <stdlib.h>

#define N 1000000000 // 1 << 20
#define ERROR 0.001

void cpu_vector_add( float * x, float * y, int n, float A) {
    for(int i = 0; i < n; i++){
        y[i] = A*x[i] + y[i];
    }
}


// The main idea is to make this fails
void cpu_vector2_add(float *x, float *y, int n, float A){
	for(int i = 0; i < n; i++){
		y[i] = A*x[i] + y[i];
	}

}

__global__ void gpu_vector_add(float * __restrict__ x, float * __restrict__  y, int n, float A){
   
   int i = blockIdx.x*blockDim.x + threadIdx.x;
   if (i < n) y[i] = A*x[i] + y[i];
	
}

int main(){
    float *a, *b, *cudaOut; 

    // Allocate memory
    a   = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    cudaOut = (float*)malloc(sizeof(float)*N);
    // Initialize array
    for(int i = 0; i < N; i++){
        a[i] = 1.0f; b[i] = 2.0f;
        cudaOut[i] = 2.0f;
    }

    // Main function
    cpu_vector_add(a, b, N, 1.0);
    
    // Allocate GPU memory
    float *aCuda, *bCuda;
    cudaMalloc((void **)&aCuda, sizeof(float)*N);
    cudaMalloc((void **)&bCuda, sizeof(float)*N); 



    // Copy data to GPU
    cudaMemcpy(aCuda, a, sizeof(float)*N, cudaMemcpyHostToDevice);
    cudaMemcpy(bCuda, cudaOut, sizeof(float)*N, cudaMemcpyHostToDevice);
    // Operating

    int threads = 256;
    int groups = N/threads + 1; 
    printf("groups %d, threads %d, N %d, G*T %d \n", groups, threads, N, groups*threads);
 
    gpu_vector_add<<<groups, threads>>>(aCuda, bCuda, N, 1.0); 


cudaError_t cudaerr = cudaDeviceSynchronize();
    if (cudaerr != cudaSuccess)
        printf("kernel launch failed with error \"%s\".\n",
               cudaGetErrorString(cudaerr));

    // Coying back
    cudaMemcpy(cudaOut, bCuda, sizeof(float)*N, cudaMemcpyDeviceToHost);

   // Freeing cuda resources

  cudaFree(aCuda);
  cudaFree(bCuda);    

    //cpu_vector2_add(a, b2, N, 1.0);
   
    for(int i = 0; i < N; i++){
	if(abs(b[i] - cudaOut[i]) > ERROR)
	{
		printf("Comparing the output for each implementation, it is incorrect at index %d, %f != %f\n",i,b[i], cudaOut[i]); 
                exit(1);
	}
    }

}
