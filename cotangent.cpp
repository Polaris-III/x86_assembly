#include <iostream>
#include <cstdlib>
#include <cmath>

extern "C"  float asm_cot(float k), cos_div_sin(float k);

int main() {
	float k;
	float rslt = 0;
	for (;;) {
		std::cout << "Type x: ";
		std::cin >> k;
		rslt = asm_cot(k);
		std::cout << "Maclaurin cotangent:   " << rslt << std::endl;
		rslt = cos_div_sin(k);
		std::cout << "FPU fsincos procedure: " << rslt << std::endl;
	}
	return 0;
}