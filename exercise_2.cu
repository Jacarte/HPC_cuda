#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#ifndef N
#define N 1000000 // 1 << 20
#endif
#define ERROR 0.001
#ifndef THREADS
    #define THREADS 256
#endif
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
    double t1, t2, t3, t4, t5, t6;  

    printf("Computing SAXPY with %d elements\n", N);

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
    int threads = THREADS;
    // Always an extra group in case of non multiple of threads N
    int groups = N/threads + 1; 
 
    t3 = mysecond();  
    gpu_vector_add<<<groups, threads>>>(aCuda, bCuda, N, 1.0); 
    t4 = mysecond(); 

    // Coying back
    cudaMemcpy(cudaOut, bCuda, sizeof(float)*N, cudaMemcpyDeviceToHost);
    t2 = mysecond();  
    printf("Computing SAXPY on the GPU in %fs (taking  into account memcpy), %fs (operational)... Done!\n", (t2 - t1), (t4 -t3));

    // Freeing cuda resources

    cudaFree(aCuda);
    cudaFree(bCuda);    

    t5 = mysecond();  
    cpu_vector_add(a, b, N, 1.0);
    t6 = mysecond();  
    printf("Computing SAXPY on the CPU in %fs… Done!\n", (t6 - t5));
   
    printf("Times: %f,%f,%f\n", (t2 -t1), (t4 - t3), (t6 - t5));

    for(int i = 0; i < N; i++){
        if(abs(b[i] - cudaOut[i]) > ERROR)
        {
            printf("Comparing the output for each implementation, it is incorrect at index %d, %f != %f\n",i,b[i], cudaOut[i]); 
            exit(1);
        }
    }

}
