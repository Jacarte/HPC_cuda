#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define N 1 << 30 + 1 // 1 << 20
#define ERROR 0.001

// The same code from lecture1 :)
double mysecond(){  
	struct timeval tp;  
	struct timezone tzp;  
	int i;  i = gettimeofday(&tp,&tzp);  
	return ( 
		(double) tp.tv_sec + (double) tp.tv_usec * 1.e-6 );}
	

void cpu_vector_add( float * x, float * y, int n, float A) {
    for(int i = 0; i < n; i++){
        y[i] = A*x[i] + y[i];
    }
}


__global__ void gpu_vector_add(float * __restrict__ x, float * __restrict__  y, int n, float A){
   
   // Each thread calculates its own index
   int i = blockIdx.x*blockDim.x + threadIdx.x;
   if (i < n) y[i] = A*x[i] + y[i];
	
}

int main(){
    float *a, *b, *cudaOut; 
    double t1, t2;  


    // Allocate memory
    a   = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    cudaOut = (float*)malloc(sizeof(float)*N);
    // Initialize array
    for(int i = 0; i < N; i++){
        a[i] = 1.0f; b[i] = 2.0f;
        cudaOut[i] = 2.0f;
    }
    // Allocate GPU memory
    float *aCuda, *bCuda;
    cudaMalloc((void **)&aCuda, sizeof(float)*N);
    cudaMalloc((void **)&bCuda, sizeof(float)*N); 



    t1 = mysecond();  
    // Copy data to GPU
    cudaMemcpy(aCuda, a, sizeof(float)*N, cudaMemcpyHostToDevice);
    cudaMemcpy(bCuda, b, sizeof(float)*N, cudaMemcpyHostToDevice);
    // Operating


    // Have a fixed number of threads
    int threads = 256;
    // Always an extra group in case of non multiple of threads N
    int groups = N/threads + 1; 
 
    gpu_vector_add<<<groups, threads>>>(aCuda, bCuda, N, 1.0); 
    

    // Coying back
    cudaMemcpy(cudaOut, bCuda, sizeof(float)*N, cudaMemcpyDeviceToHost);
    t2 = mysecond();  
    printf("Computing SAXPY on the GPU in %f s (taking  into account memcpy)... Done!\n", (t2 - t1));

    // Freeing cuda resources

    cudaFree(aCuda);
    cudaFree(bCuda);    

    t1 = mysecond();  
    cpu_vector_add(a, b, N, 1.0);
    t2 = mysecond();  
    printf("Computing SAXPY on the CPU in %f s… Done!\n", (t2 - t1));
   
    for(int i = 0; i < N; i++){
        if(abs(b[i] - cudaOut[i]) > ERROR)
        {
            printf("Comparing the output for each implementation, it is incorrect at index %d, %f != %f\n",i,b[i], cudaOut[i]); 
            exit(1);
        }
    }

}
