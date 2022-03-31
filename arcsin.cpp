#include <iostream>
#include <cstdlib>
#include <cmath>
#include <clocale>

extern "C"  float asm_arcsin(float x);

int main() {
	setlocale(LC_ALL, "");
	float x;
	for (;;) {
		std::cout << "Type x: ";
		std::cin >> x;
		std::cout << "Maclaurin polynomal asin via FPU:     " << asm_arcsin(x) << std::endl;
		std::cout << "Standard cmath asin:                  " << asin(x) << std::endl;
	}
	system("pause");
	return 0;
}