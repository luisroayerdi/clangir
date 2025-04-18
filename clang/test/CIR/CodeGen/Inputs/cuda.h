/* Minimal declarations for CUDA support.  Testing purposes only. */
/* From test/CodeGenCUDA/Inputs/cuda.h. */
#include <stddef.h>

#if __HIP__ || __CUDA__
#define __constant__ __attribute__((constant))
#define __device__ __attribute__((device))
#define __global__ __attribute__((global))
#define __host__ __attribute__((host))
#define __shared__ __attribute__((shared))
#if __HIP__
#define __managed__ __attribute__((managed))
#endif
#define __launch_bounds__(...) __attribute__((launch_bounds(__VA_ARGS__)))
#define __grid_constant__ __attribute__((grid_constant))
#else
#define __constant__
#define __device__
#define __global__
#define __host__
#define __shared__
#define __managed__
#define __launch_bounds__(...)
#define __grid_constant__
#endif

struct dim3 {
  unsigned x, y, z;
  __host__ __device__ dim3(unsigned x, unsigned y = 1, unsigned z = 1) : x(x), y(y), z(z) {}
};

#if __HIP__ || HIP_PLATFORM
typedef struct hipStream *hipStream_t;
typedef enum hipError {} hipError_t;
int hipConfigureCall(dim3 gridSize, dim3 blockSize, size_t sharedSize = 0,
                     hipStream_t stream = 0);
extern "C" hipError_t __hipPushCallConfiguration(dim3 gridSize, dim3 blockSize,
                                                 size_t sharedSize = 0,
                                                 hipStream_t stream = 0);
#ifndef __HIP_API_PER_THREAD_DEFAULT_STREAM__
extern "C" hipError_t hipLaunchKernel(const void *func, dim3 gridDim,
                                      dim3 blockDim, void **args,
                                      size_t sharedMem,
                                      hipStream_t stream);
#else
extern "C" hipError_t hipLaunchKernel_spt(const void *func, dim3 gridDim,
                                      dim3 blockDim, void **args,
                                      size_t sharedMem,
                                      hipStream_t stream);
#endif // __HIP_API_PER_THREAD_DEFAULT_STREAM__
#elif __OFFLOAD_VIA_LLVM__
extern "C" unsigned __llvmPushCallConfiguration(dim3 gridDim, dim3 blockDim,
                                     size_t sharedMem = 0, void *stream = 0);
extern "C" unsigned llvmLaunchKernel(const void *func, dim3 gridDim, dim3 blockDim,
                          void **args, size_t sharedMem = 0, void *stream = 0);
#else
typedef struct cudaStream *cudaStream_t;
typedef enum cudaError {} cudaError_t;
extern "C" int cudaConfigureCall(dim3 gridSize, dim3 blockSize,
                                 size_t sharedSize = 0,
                                 cudaStream_t stream = 0);
extern "C" int __cudaPushCallConfiguration(dim3 gridSize, dim3 blockSize,
                                           size_t sharedSize = 0,
                                           cudaStream_t stream = 0);
extern "C" cudaError_t cudaLaunchKernel(const void *func, dim3 gridDim,
                                        dim3 blockDim, void **args,
                                        size_t sharedMem, cudaStream_t stream);
extern "C" cudaError_t cudaLaunchKernel_ptsz(const void *func, dim3 gridDim,
                                        dim3 blockDim, void **args,
                                        size_t sharedMem, cudaStream_t stream);

#endif

extern "C" __device__ int printf(const char*, ...);
