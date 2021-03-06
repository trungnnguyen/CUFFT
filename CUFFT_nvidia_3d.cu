#include <stdio.h>
#include <cuda.h>
#include <math.h>
#include <cufft.h>
 
 
void generate_fake_samples(int N, float **out)
{
    int i;
    float *result = (float *)malloc(sizeof(float) * N);
    double delta = M_PI / 4.0;

    for (i = 0; i < N; i++)
    {
        result[i] = cos(i * delta);
    }

    *out = result;
}

/*
 * Convert a real-valued vector r of length Nto a complex-valued vector.
 */
void real_to_complex(float *r, cufftComplex **complx, int N)
{
    int i;
    (*complx) = (cufftComplex *)malloc(sizeof(cufftComplex) * N);

    for (i = 0; i < N; i++)
    {
        (*complx)[i].x = r[i];
        (*complx)[i].y = 0;
    }
} 
 
 
 


#define NX 128
#define NY 128
#define NZ 128
int main(void) {
 double acc_time;
    int acc_n;
    
   float elapsedTime;
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventRecord(start,0);  
    
    
printf("[simpleCUFFT] is starting...\n");


    int N = 128*128*128;
    float *samples;
    cufftComplex *complexSamples;


// Generate inputs
    generate_fake_samples(N, &samples);
    real_to_complex(samples, &complexSamples, N);
    cufftComplex *complexFreq = (cufftComplex *)malloc(
                                    sizeof(cufftComplex) * N);

  
				    
				    
				    
cufftHandle plan;
//cufftComplex *data1, *data2;

//cufftComplex *complexSamples;
cudaMalloc((void**)&complexSamples, sizeof(cufftComplex)*NX*NY*NZ);
//cudaMalloc((void**)&data2, sizeof(cufftComplex)*NX*NY*NZ);
/* Create a 3D FFT plan. */
printf("Create a 3D FFT plan\n");
cufftPlan3d(&plan, NX, NY, NZ, CUFFT_C2C);
/* Transform the first signal in place. */
printf("Transform the first signal in place\n");

 struct timespec now, tmstart;
    clock_gettime(CLOCK_REALTIME, &tmstart);
    
cufftExecC2C(plan, complexSamples, complexSamples, CUFFT_FORWARD);
/* Transform the second signal using the same plan. */
//printf("Transform the second signal using the same plan\n");
//cufftExecC2C(plan, data2, data2, CUFFT_FORWARD);

    clock_gettime(CLOCK_REALTIME, &now);
    acc_time += (now.tv_sec+now.tv_nsec*1e-9) - (tmstart.tv_sec+tmstart.tv_nsec*1e-9);
    acc_n++;

    

    printf("avg CUFFT avg time: %g total time %g\n", acc_time / acc_n, acc_time);
     cudaEventElapsedTime(&elapsedTime, start,stop);
    printf("Elapsed time : %f ms\n" ,elapsedTime); 
    
    
for (int i = 0; i < 1; ++i) {
    printf("[%d] %g  n", i,  complexSamples[0] ,complexSamples[1]);
  } 
 

/* Destroy the CUFFT plan. */
cufftDestroy(plan);
cudaFree(complexSamples);// cudaFree(data2);



return 0;


}
