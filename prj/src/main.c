#include <stdint.h>
#include "main.h"

volatile const uint32_t i1 = 0;
volatile const int i2 = 1;
volatile const char hello[] = "Hello";

__attribute__((section(".my_special_section")))
int main(void) {
	if (hello[0])
		return 2;

	if (i1 < i2)
		return i2;

	char *local1 = "Hello";
	char *local2 = "Hello";

	return local1[0] + local2[0];
}
