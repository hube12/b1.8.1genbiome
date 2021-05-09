cmake_minimum_required(VERSION 3.17)
project(biomeGen CUDA)

set(CMAKE_CUDA_STANDARD 14)


add_executable(biomeGen main.cu)

set_target_properties(
        biomeGen
        PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON
        CUDA_ARCHITECTURES OFF
)

add_executable(test test.cu)

set_target_properties(
        test
        PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON
        CUDA_ARCHITECTURES OFF
)