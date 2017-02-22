#include <stdio.h>
#include <cuda.h>
#include <math.h>
#include <cufft.h> 


#define NX 2
#define NY 2
#define LX (2*M_PI)
#define LY (2*M_PI)




int main(void) {

float *x = new float[NX*NY];
float *y = new float[NX*NY];
float *vx = new float[NX*NY];

 


for(int j = 0; j < NY; j++){
    for(int i = 0; i < NX; i++){
        x[j*NX + i] = i * LX/NX;
        y[j*NX + i] = j * LY/NY;
        vx[j*NX + i] = cos(x[j*NX + i]);
    }
}
float *d_vx;
cudaMalloc(&d_vx, NX*NY*sizeof(float));
cudaMemcpy(d_vx, vx, NX*NY*sizeof(float), cudaMemcpyHostToDevice);
cufftHandle planr2c;
cufftHandle planc2r;
cufftPlan2d(&planr2c, NY, NX, CUFFT_R2C);
cufftPlan2d(&planc2r, NY, NX, CUFFT_C2R);
cufftSetCompatibilityMode(planr2c, CUFFT_COMPATIBILITY_NATIVE);
cufftSetCompatibilityMode(planc2r, CUFFT_COMPATIBILITY_NATIVE);
cufftExecR2C(planr2c, (cufftReal *)d_vx, (cufftComplex *)d_vx);
cufftExecC2R(planc2r, (cufftComplex *)d_vx, (cufftReal *)d_vx);
cudaMemcpy(vx, d_vx, NX*NY*sizeof(cufftReal), cudaMemcpyDeviceToHost);
for (int j = 0; j < NY; j++){
    for (int i = 0; i < NX; i++){
        printf("%.3f ", vx[j*NX + i]/(NX*NY));
    }
    printf("\n");
} 

return 0;

}