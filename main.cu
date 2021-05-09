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

DEVICEABLE void print_array(uint8_t *arr, uint32_t size) {
    for (uint32_t i = 0; i < size; i++)
        printf("%d,", arr[i]);
    printf("\n");
}

// optimized for single point
DEVICEABLE int get_biome(int64_t world_seed, int32_t pos_x, int32_t pos_z, uint8_t start_layer_size, uint32_t start_scale) {
    int32_t * layer_sizes= get_size(1,1);
    int32_t * layer_positions= get_pos(pos_x,pos_z);
    uint32_t scale = start_scale;
    int64_t layer_seed, local_seed;
    int32_t current_x, current_z;
    int32_t * coords;
    uint32_t cache_size = get_max_size(1);
    auto *cache1 = new uint8_t[cache_size];
    auto *cache2 = new uint8_t[cache_size];
    // Continent layer
    layer_seed = get_layer_seed_precomputed(world_seed, SALT_1);
    coords= get_for_layer(layer_positions,0);
    current_x = layer_sizes[2+]
    current_z = (pos_z - 7974) / (int32_t) scale;
    printf("%d %d %d\n", current_x, current_z, layer_size);
    for (uint8_t z = 0; z < layer_size; z++) {
        for (uint8_t x = 0; x < layer_size; x++) {
            local_seed = get_local_seed(layer_seed, current_x + x, current_z + z);
            cache1[x + z * layer_size] = next_int_without(local_seed, 10) != 0 ? OCEAN : PLAINS;
        }
    }
    // make spawn a bit more liveable
    if (-layer_size < current_x && current_x <= 0 && -layer_size < current_z && current_z <= 0) {
        cache1[-current_x + -current_z * layer_size] = 1;
    }
    print_array(cache1, cache_size);
    return 0;
}


DEVICEABLE int get_single_biome(int64_t world_seed, int32_t pos_x, int32_t pos_z) {
    return get_biome(world_seed, pos_x, pos_z, 7, 8192);
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
    get_single_biome(1, 0, 0);
    return 0;
}
