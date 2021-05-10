#include "util.cuh"


DEVICEABLE LayerStack* get_layer_stack(int64_t world_seed){
    auto* layerStack=new LayerStack;

}

DEVICEABLE int get_biome(int64_t world_seed, int32_t pos_x, int32_t pos_z) {

}


int main() {
    uint64_t seed = 1LL;
    //biome_gen<<<1, 1>>>(seed);
    get_biome(1, 7973,0);
    return 0;
}
