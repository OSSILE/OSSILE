#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "sha256.h"

int main( ){
    char* input  = "OSSILE repo";

    sha256hash_t result = sha256sum((unsigned char*)input);
    unsigned char* result_str = sha256_to_string(result);
    printf("Result: %s\n", (char*)result_str);

    return 0;
}