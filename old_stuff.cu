#include "util.cuh"

// we only do square size (easier to manage)

// optimized for large area
DEVICEABLE int get_biome_area(int64_t world_seed, int32_t x, int32_t z, uint8_t size) {
    uint32_t cache_size = get_max_size(size);
    // technically I need 16 values, I might make it like so
    auto *cache1 = new uint8_t[cache_size];
    auto *cache2 = new uint8_t[cache_size];
    int64_t layerSeed, localSeed;
    // Continent layer
    layerSeed = get_layer_seed_precomputed(world_seed, SALT_1);
    printf("%lld %lld\n", layerSeed, SALT_1);

    return 0;
}



// optimized for single point
DEVICEABLE int get_biome(int64_t world_seed, int32_t pos_x, int32_t pos_z, int32_t width, int32_t height) {
    int32_t * layer_sizes= get_size(width,height);
    int32_t * layer_positions= get_pos(pos_x,pos_z);
    int64_t layer_seed, local_seed;
    int32_t current_x, current_z;
    int32_t size_x, size_z;
    int32_t * coords,*sizes;
    uint32_t cache_size = get_max_size(1);
    auto *cache1 = new uint8_t[cache_size];
    auto *cache2 = new uint8_t[cache_size];
    // Continent layer
    layer_seed = get_layer_seed_precomputed(world_seed, SALT_1);
    coords= get_for_layer(layer_positions,0);
    print_array_i32(coords,4);
    current_x = min(coords[0],coords[2]);
    current_z = min(coords[1],coords[3]);
    sizes= get_for_layer(layer_sizes,0);
    size_x= abs(coords[0]-coords[2])+ max(sizes[0],sizes[2]);
    size_z= abs(coords[1]-coords[3])+ max(sizes[1],sizes[3]);
    printf("%d %d %d %d\n", current_x, current_z, size_x,size_z);
    for (int32_t z = 0; z < size_z; z++) {
        for (int32_t x = 0; x < size_x; x++) {
            local_seed = get_local_seed(layer_seed, current_x + x, current_z + z);
            cache1[x + z * size_x] = next_int_without(local_seed, 10) != 0 ? OCEAN : PLAINS;
        }
    }
    // make spawn a bit more liveable
    if (-size_x < current_x && current_x <= 0 && -size_z < current_z && current_z <= 0) {
        cache1[-current_x + -current_z * size_x] = 1;
    }
    print_array_u8(cache1, cache_size);
    // scale layer
    layer_seed = get_layer_seed_precomputed(world_seed, SALT_2000);
    coords= get_for_layer(layer_positions,1);
    print_array_i32(coords,4);
    current_x = min(coords[0],coords[2]);
    current_z = min(coords[1],coords[3]);
    sizes= get_for_layer(layer_sizes,1);
    size_x= abs(coords[0]-coords[2])+ max(sizes[0],sizes[2]);
    size_z= abs(coords[1]-coords[3])+ max(sizes[1],sizes[3]);
    printf("%d %d %d %d\n", current_x, current_z, size_x,size_z);

    return 0;
}


DEVICEABLE int get_single_biome(int64_t world_seed, int32_t pos_x, int32_t pos_z) {
    return get_biome(world_seed, pos_x, pos_z, 1, 1);
}

__global__  void biome_gen(uint64_t world_seed) {
    printf("%lld %lld\n", mix_salt(1), get_layer_seed(1, 1));
}


void biome_gen_d(uint64_t world_seed) {
    printf("%lld %lld\n", mix_salt(1), get_layer_seed(1, 1));
}


int main() {
    uint64_t seed = 1LL;
    //biome_gen<<<1, 1>>>(seed);
    get_biome(1, 7973,0,10000,10000);
    return 0;
}
