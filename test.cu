#include "util.cuh"

// Continent Layer 1: 3107951898966440229
//Scale Layer 2000: -8774101820360152064
//Land Layer 1: 3107951898966440229
//Scale Layer 2001: 229918546094678885
//Land Layer 2: -5014677998924433960
//Scale Layer 2002: 837738509879401688
//Land Layer 3: 7590731853067264053
//Scale Layer 2003: 3006835321906069877
//Land Layer 3: 7590731853067264053
//Scale Layer 2004: -501908431691485536
//Land Layer 4: 5360640171528462240
//Biome Layer 200: 3038466749335869312
//Biome zoom1 1000: Layer 5692911206796425088
//Biome zoom2 1001: Layer 5852781679691581125
//Noise Layer 100: 5723240131506253216
//River zoom1 Layer 1000: 5692911206796425088
//River zoom2 Layer 1001: 5852781679691581125
//River zoom3 Layer 1002: 1827289100522298840
//River zoom4 Layer 1003: -4039966243449460139
//River zoom5 Layer 1004: -1816691421893595488
//River zoom6 Layer 1005: -6132030474114107403
//Noise to river Layer 1: 3107951898966440229
//Smooth Scale Layer 1000: 5692911206796425088
//Scale Layer 1000: 5692911206796425088
//Land Layer 3: 7590731853067264053
//Scale Layer 1001: 5852781679691581125
//Scale Layer 1002: 1827289100522298840
//Scale Layer 1003: -4039966243449460139
//Smooth Scale Layer 1000: 5692911206796425088
//River Mix Layer 100: 5723240131506253216
//Voronoi Layer 10: -8738471090773341224
void get_salts() {
    printf("Continent Layer 1: %lld\n", mix_salt(1));
    printf("Scale Layer 2000: %lld\n", mix_salt(2000));
    printf("Land Layer 1: %lld\n", mix_salt(1));
    printf("Scale Layer 2001: %lld\n", mix_salt(2001));
    printf("Land Layer 2: %lld\n", mix_salt(2));
    printf("Scale Layer 2002: %lld\n", mix_salt(2002));
    printf("Land Layer 3: %lld\n", mix_salt(3));
    printf("Scale Layer 2003: %lld\n", mix_salt(2003));
    printf("Land Layer 3: %lld\n", mix_salt(3));
    printf("Scale Layer 2004: %lld\n", mix_salt(2004));
    printf("Land Layer 4: %lld\n", mix_salt(4));

    printf("Biome Layer 200: %lld\n", mix_salt(200));
    printf("Biome zoom1 1000: Layer %lld\n", mix_salt(1000));
    printf("Biome zoom2 1001: Layer %lld\n", mix_salt(1001));

    printf("Noise Layer 100: %lld\n", mix_salt(100));

    printf("River zoom1 Layer 1000: %lld\n", mix_salt(1000));
    printf("River zoom2 Layer 1001: %lld\n", mix_salt(1001));
    printf("River zoom3 Layer 1002: %lld\n", mix_salt(1002));
    printf("River zoom4 Layer 1003: %lld\n", mix_salt(1003));
    printf("River zoom5 Layer 1004: %lld\n", mix_salt(1004));
    printf("River zoom6 Layer 1005: %lld\n", mix_salt(1005));
    printf("Noise to river Layer 1: %lld\n", mix_salt(1));
    printf("Smooth Scale Layer 1000: %lld\n", mix_salt(1000));

    printf("Scale Layer 1000: %lld\n", mix_salt(1000));
    printf("Land Layer 3: %lld\n", mix_salt(3));
    printf("Scale Layer 1001: %lld\n", mix_salt(1001));
    printf("Scale Layer 1002: %lld\n", mix_salt(1002));
    printf("Scale Layer 1003: %lld\n", mix_salt(1003));

    printf("Smooth Scale Layer 1000: %lld\n", mix_salt(1000));

    printf("River Mix Layer 100: %lld\n", mix_salt(100));
    printf("Voronoi Layer 10: %lld\n", mix_salt(10));
}


void verify_salts(){
    assert(mix_salt(1) ==SALT_1);
    assert(mix_salt(2) ==SALT_2);
    assert(mix_salt(3) ==SALT_3);
    assert(mix_salt(4) ==SALT_4);
    assert(mix_salt(10) ==SALT_10);
    assert(mix_salt(100) ==SALT_100);
    assert(mix_salt(200) ==SALT_200);
    assert(mix_salt(1000) ==SALT_1000);
    assert(mix_salt(1001) ==SALT_1001);
    assert(mix_salt(1002) ==SALT_1002);
    assert(mix_salt(1003) ==SALT_1003);
    assert(mix_salt(1004) ==SALT_1004);
    assert(mix_salt(1005) ==SALT_1005);
    assert(mix_salt(2000) ==SALT_2000);
    assert(mix_salt(2001) ==SALT_2001);
    assert(mix_salt(2002) ==SALT_2002);
    assert(mix_salt(2003) ==SALT_2003);
    assert(mix_salt(2004) ==SALT_2004);
}

//0 256
//1 256
//2 256
//3 256
//4 256
//5 256
//6 256
//7 256
//8 400
//9 400
//10 400
//11 400
//12 576
//13 576
//14 576
//15 576
//16 784
//17 784
//18 784
//19 784
//20 1024
//21 1024
//22 1024
//23 1024
//24 1296
//25 1296
//26 1296
//27 1296
//28 1600
//29 1600
//30 1600
//31 1600
//32 1936
//33 1936
//34 1936
//35 1936
//36 2304
//37 2304
//38 2304
//39 2304
//40 2704
//41 2704
//42 2704
//43 2704
//44 3136
//45 3136
//46 3136
//47 3136
//48 3600
//49 3600
//50 3600
//51 3600
//52 4096
//53 4096
//54 4096
//55 4096
//56 4624
//57 4624
//58 4624
//59 4624
//60 5184
//61 5184
//62 5184
//63 5184
//64 5776
//65 5776
//66 5776
//67 5776
//68 6400
//69 6400
//70 6400
//71 6400
//72 7056
//73 7056
//74 7056
//75 7056
//76 7744
//77 7744
//78 7744
//79 7744
//80 8464
//81 8464
//82 8464
//83 8464
//84 9216
//85 9216
//86 9216
//87 9216
//88 10000
//89 10000
//90 10000
//91 10000
//92 10816
//93 10816
//94 10816
//95 10816
//96 11664
//97 11664
//98 11664
//99 11664
//100 12544
//101 12544
//102 12544
//103 12544
//104 13456
//105 13456
//106 13456
//107 13456
//108 14400
//109 14400
//110 14400
//111 14400
//112 15376
//113 15376
//114 15376
//115 15376
//116 16384
//117 16384
//118 16384
//119 16384
//120 17424
//121 17424
//122 17424
//123 17424
//124 18496
//125 18496
//126 18496
//127 18496
//128 19600
//129 19600
//130 19600
//131 19600
//132 20736
//133 20736
//134 20736
//135 20736
//136 21904
//137 21904
//138 21904
//139 21904
//140 23104
//141 23104
//142 23104
//143 23104
//144 24336
//145 24336
//146 24336
//147 24336
//148 25600
//149 25600
//150 25600
//151 25600
//152 26896
//153 26896
//154 26896
//155 26896
//156 28224
//157 28224
//158 28224
//159 28224
//160 29584
//161 29584
//162 29584
//163 29584
//164 30976
//165 30976
//166 30976
//167 30976
//168 32400
//169 32400
//170 32400
//171 32400
//172 33856
//173 33856
//174 33856
//175 33856
//176 35344
//177 35344
//178 35344
//179 35344
//180 36864
//181 36864
//182 36864
//183 36864
//184 38416
//185 38416
//186 38416
//187 38416
//188 40000
//189 40000
//190 40000
//191 40000
//192 41616
//193 41616
//194 41616
//195 41616
//196 43264
//197 43264
//198 43264
//199 43264
//200 44944
//201 44944
//202 44944
//203 44944
//204 46656
//205 46656
//206 46656
//207 46656
//208 48400
//209 48400
//210 48400
//211 48400
//212 50176
//213 50176
//214 50176
//215 50176
//216 51984
//217 51984
//218 51984
//219 51984
//220 53824
//221 53824
//222 53824
//223 53824
//224 55696
//225 55696
//226 55696
//227 55696
//228 57600
//229 57600
//230 57600
//231 57600
//232 59536
//233 59536
//234 59536
//235 59536
//236 61504
//237 61504
//238 61504
//239 61504
//240 63504
//241 63504
//242 63504
//243 63504
//244 65536
//245 65536
//246 65536
//247 65536
void test_cache_size(){
    for (uint8_t i=0;i<=247;i++)
        printf("%d %u\n",i, get_max_size(i));
}
//1992,-1
//
//1991,-2
//995,-1
//497,-1
//248,-1
//247,-2
//123,-1
//61,-1
//30,-1
//30,-1
//29,-2
//14,-1
//13,-2
//6,-1
//5,-2
//2,-1
//1,-2
//0,-1
//-1,-2
//-1,-1
//
//1991,-2
//1990,-3
//995,-2
//497,-1
//248,-1
//124,-1
//62,-1
//31,-1
//31,-1
//30,-2
//15,-1
//14,-2
//7,-1
//6,-2
//3,-1
//2,-2
//1,-1
//0,-2
//0,-1
void test_position(){
    int32_t* pos_arr=get_pos(7973,0);
    printf("%d,%d\n\n",pos_arr[0],pos_arr[1]);
    for (uint32_t i = 2; i < SIZE_LAYER*2+2; i+=2)
        printf("%d,%d\n", pos_arr[i],pos_arr[i+1]);
    printf("\n");
    for (uint32_t i = SIZE_LAYER*2+2; i < SIZE_LAYER*2*2+2; i+=2)
        printf("%d,%d\n", pos_arr[i],pos_arr[i+1]);
    printf("\n");
}

// 2503,2503
//
//2505,2505
//1255,1255
//630,630
//318,318
//320,320
//163,163
//84,84
//45,45
//45,45
//47,47
//26,26
//28,28
//17,17
//19,19
//12,12
//14,14
//10,10
//12,12
//9,9
//
//2505,2505
//2507,2507
//1256,1256
//631,631
//318,318
//162,162
//84,84
//45,45
//45,45
//47,47
//26,26
//28,28
//17,17
//19,19
//12,12
//14,14
//10,10
//12,12
//9,9

void test_size(){
    int32_t* size_arr=get_size(10000, 10000);
    printf("%d,%d\n\n",size_arr[0],size_arr[1]);
    for (uint32_t i = 2; i < SIZE_LAYER*2+2; i+=2)
        printf("%d,%d\n", size_arr[i], size_arr[i + 1]);
    printf("\n");
    for (uint32_t i = SIZE_LAYER*2+2; i < SIZE_LAYER*2*2+2; i+=2)
        printf("%d,%d\n", size_arr[i], size_arr[i + 1]);
    printf("\n");
}

int main() {
    get_salts();
    verify_salts();
    test_cache_size();
    test_position();
    test_size();
    return 0;
}
