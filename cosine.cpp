#include <iostream>
#include <cstdlib>
#include <cmath>

extern "C"  float asm_cos(float k), simplest_cos(float k);

int main() {
	float k;
	float rslt = 0;
	for (;;) {
		std::cout << "Type x: ";
		std::cin >> k;
		rslt = asm_cos(k);
		std::cout << "Maclaurin cosine:   " << rslt << std::endl;
		rslt = simplest_cos(k);
		std::cout << "FPU fcos procedure: " << rslt << std::endl;
	}
	return 0;
}