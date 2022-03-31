#include <iostream>
#include <cstdlib>
#include <cmath>

extern "C"  float asm_arcsinh(float x);

int main() {
	float x;
	for (;;) {
		std::cout << "Type x: ";
		std::cin >> x;
		std::cout << std::endl << "FPU arsinh:   " << asm_arcsinh(x) << std::endl;
		std::cout << "cmath arsinh: " << asinh(x) << std::endl;
	}
	system("pause");
	return 0;
}