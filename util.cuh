#ifndef UTIL_CUH
#define UTIL_CUH

#ifdef _MSVC_LANG
#define CPP_VER _MSVC_LANG
#else
#define CPP_VER __cplusplus
#endif

#if defined(__CUDACC__)
#define FORCEINLINE __forceinline__
#elif defined(__GNUC__)
#define FORCEINLINE __attribute__((always_inline))
#elif defined(_MSC_VER)
#define FORCEINLINE __forceinline
#else
#warning Using unknown compiler, various optimizations may not be enabled
#define FORCEINLINE
#endif

#ifdef __CUDACC__
#define DEVICEABLE __host__ __device__
#else
#define DEVICEABLE
#endif

#ifdef __CUDA_ARCH__
#define DEVICE_FORCEINLINE FORCEINLINE
#define HOST_FORCEINLINE
#define DEVICEABLE_CONST __constant__ __device__
#else
#define DEVICE_FORCEINLINE
#define HOST_FORCEINLINE FORCEINLINE
#define DEVICEABLE_CONST const
#endif
#define SIZE_LAYER 19 // non deterministic + smooth + river mix
#define NUMBER_LAYER SIZE_LAYER+1+1+1 // + voronoi

#include <iostream>
#include <cmath>
#include <vector>
#include <sstream>
#include <string>
#include <fstream>
#include <cassert>

#include <chrono>
#include <thread>

#define SALT_1 3107951898966440229LL
#define SALT_2 -5014677998924433960LL
#define SALT_3 7590731853067264053LL
#define SALT_4 5360640171528462240LL
#define SALT_10 -8738471090773341224LL
#define SALT_100 5723240131506253216LL
#define SALT_200 3038466749335869312LL
#define SALT_1000 5692911206796425088LL
#define SALT_1001 5852781679691581125LL
#define SALT_1002 1827289100522298840LL
#define SALT_1003 -4039966243449460139LL
#define SALT_1004 -1816691421893595488LL
#define SALT_1005 -6132030474114107403LL
#define SALT_2000 -8774101820360152064LL
#define SALT_2001 229918546094678885LL
#define SALT_2002 837738509879401688LL
#define SALT_2003 3006835321906069877LL
#define SALT_2004 -501908431691485536LL

#define OCEAN 0
#define PLAINS 1
#define DESERT 2
#define MOUNTAINS 3
#define FOREST 4
#define TAIGA 5
#define SWAMP 6
#define RIVER 7
#define NETHER_WASTES 8
#define THE_END 9
#define NEG_RIVER_OPTI 7
#define NEG_RIVER 255

#define CHECK_GPU_ERR(code) gpuAssert((code), __FILE__, __LINE__)

inline void gpuAssert(cudaError_t code, const char *file, int line) {
    if (code != cudaSuccess) {
        fprintf(stderr, "GPUassert: %s (code %d) %s %d\n", cudaGetErrorString(code), code, file, line);
        exit(code);
    }
}

FORCEINLINE DEVICEABLE uint32_t get_max_size(uint8_t size) {
    if (size > 247) {
        // you should never have a cache that high
        assert(false);
    }
    uint32_t voronoi_size = ((size >> 2u) + 3) << 2u;
    return size < 4 ? 7 * 7 * 2 * 2 : voronoi_size * voronoi_size;
}

FORCEINLINE DEVICEABLE int64_t mix_seed(int64_t world_seed, int64_t salt) {
    return world_seed * (world_seed * 6364136223846793005LL + 1442695040888963407LL) + salt;
}

FORCEINLINE DEVICEABLE int64_t mix_salt(int64_t salt) {
    int64_t mid_salt = mix_seed(salt, salt);
    mid_salt = mix_seed(mid_salt, salt);
    mid_salt = mix_seed(mid_salt, salt);
    return mid_salt;
}

FORCEINLINE DEVICEABLE int64_t get_layer_seed(int64_t world_seed, int64_t salt) {
    salt = mix_salt(salt);
    world_seed = mix_seed(world_seed, salt);
    world_seed = mix_seed(world_seed, salt);
    world_seed = mix_seed(world_seed, salt);
    return world_seed;
}

FORCEINLINE DEVICEABLE int64_t get_layer_seed_precomputed(int64_t world_seed, int64_t salt) {
    world_seed = mix_seed(world_seed, salt);
    world_seed = mix_seed(world_seed, salt);
    world_seed = mix_seed(world_seed, salt);
    return world_seed;
}

FORCEINLINE DEVICEABLE int64_t get_local_seed(int64_t local_seed, int32_t x, int32_t z) {
    local_seed = mix_seed(local_seed, x);
    local_seed = mix_seed(local_seed, z);
    local_seed = mix_seed(local_seed, x);
    local_seed = mix_seed(local_seed, z);
    return local_seed;
}

FORCEINLINE DEVICEABLE int32_t next_int_without(const int64_t seed, uint8_t bound) {
    uint64_t seed_bits = (((uint64_t) seed) >> 24u); // logical bit shift (this is correct as long as the bound is not above 2^39
    return (int32_t) (seed_bits % ((uint64_t) bound));
}

// technically could return uint8_t (we don't do that because we want to use 1.6+ later on
FORCEINLINE DEVICEABLE int32_t next_int(int64_t *local_seed, uint8_t bound, const int64_t *layer_seed) {
    int32_t res = next_int_without(*local_seed, bound);
    *local_seed = mix_seed(*local_seed, *layer_seed);
    return res;
}

FORCEINLINE DEVICEABLE int add_first_stack_pos(int32_t x, int32_t z, int32_t *pos_arr, int i) {
    // biome (from zoom)
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // base (from biomes)
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // zoom (from island)
    x -= 1;
    z -= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // island (from zoom) (3<=2004)
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // zoom (from island)
    x -= 1;
    z -= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // island (from zoom) (3<=2003)
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // zoom (from island)
    x -= 1;
    z -= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // island (from zoom) (2<=2002)
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // zoom (from island)
    x -= 1;
    z -= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // island (from zoom) (1<=2001)
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // zoomfuzzy (from island)
    x -= 1;
    z -= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // island (from fuzzy)
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    return i;
}

FORCEINLINE DEVICEABLE int32_t *get_pos(int32_t x, int32_t z) {
    auto *pos_arr = new int32_t[2 * SIZE_LAYER * 2 + 2]; // we add one time the river mix/smooth pos
    uint8_t i = 0;
    // voronoi is known so we don't care
    // river mix layer too (x-2)>>2 (z-2)>>2
    x -= 2;
    z -= 2;
    x >>= 2;
    z >>= 2;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // GenLayerSmooth is river mix layer for both
    int32_t smooth_x = x;
    int32_t smooth_z = z;
    // remember we offset by the parent so no shock
    // biome stack
    // 3 zoom
    // zoom (from smooth)
    x -= 1;
    z -= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // island (from zoom)
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // zoom (from island)
    x -= 1;
    z -= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // zoom (from zoom)
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    i = add_first_stack_pos(x, z, pos_arr, i);

    // river stack (notice how the first 6 calls make it different due to an off by one in the for biomesize loop)
    // zoom (from river)
    x = smooth_x;
    z = smooth_z;
    // river from smooth
    x -= 1;
    z -= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // 6 zoom
    x -= 1;
    z -= 1; //(from river)
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    // here we have our first and only change
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    x >>= 1;
    z >>= 1;
    pos_arr[i++] = x;
    pos_arr[i++] = z;
    add_first_stack_pos(x, z, pos_arr, i);

    return pos_arr;
}


FORCEINLINE DEVICEABLE int add_first_stack_size(int32_t size_x, int32_t size_z, int32_t *size_arr, int i) {
    // biome (from zoom)
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // base (from biomes)
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // zoom (from island)
    size_x += 2;
    size_z += 2;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // island (from zoom) (3<=2004)
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // zoom (from island)
    size_x += 2;
    size_z += 2;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // island (from zoom) (3<=2003)
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // zoom (from island)
    size_x += 2;
    size_z += 2;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // island (from zoom) (2<=2002)
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // zoom (from island)
    size_x += 2;
    size_z += 2;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // island (from zoom) (1<=2001)
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // zoomfuzzy (from island)
    size_x += 2;
    size_z += 2;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // island (from fuzzy)
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    return i;
}

FORCEINLINE DEVICEABLE int32_t *get_size(int32_t size_x, int32_t size_z) {
    auto *size_arr = new int32_t[2 * SIZE_LAYER * 2 + 2];
    uint8_t i = 0;
    // voronoi is known so we don't care
    size_x >>= 2;
    size_z >>= 2;
    size_x += 3;
    size_z += 3;
    // river mix layer too (size_x>>2)+3 (size_z>>2)+3
    // GenLayerSmooth is river mix layer for both
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    int32_t smooth_x = size_x;
    int32_t smooth_z = size_z;

    // remember we offset by the parent so no shock
    // biome stack
    // 3 zoom
    // zoom (from smooth)
    size_x += 2;
    size_z += 2;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // island (from zoom)
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // zoom (from island)
    size_x += 2;
    size_z += 2;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // zoom (from zoom)
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    i = add_first_stack_size(size_x, size_z, size_arr, i);

    // river stack (notice how the first 6 calls make it different due to an off by one in the for biomesize loop)
    // zoom (from river)
    size_x = smooth_x;
    size_z = smooth_z;
    // river from smooth
    size_x += 2;
    size_z += 2;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // 6 zoom
    size_x += 2;
    size_z += 2; //(from river)
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    // here we have our first and only change
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    size_x >>= 1;
    size_z >>= 1;
    size_x += 3;
    size_z += 3;
    size_arr[i++] = size_x;
    size_arr[i++] = size_z;
    add_first_stack_size(size_x, size_z, size_arr, i);

    return size_arr;
}

FORCEINLINE DEVICEABLE int32_t *get_for_layer(const int32_t *layers, uint8_t layer_id) {
    return new int32_t[]{layers[2 + SIZE_LAYER * 2 - layer_id * 2 -1],
                         layers[2 + SIZE_LAYER * 2 - layer_id * 2],
                         layers[2 + SIZE_LAYER * 4 - layer_id * 2 -1],
                         layers[2 + SIZE_LAYER * 4 - layer_id * 2 ]};
}

#endif //UTIL_CUH