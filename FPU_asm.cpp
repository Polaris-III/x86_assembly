#include <iostream>
#include <cstdlib>
#include <cmath>
#include <windows.h>

extern "C"  float asm_arth(float a);

int main() {
	float a;
	float rslt = 0;
	for (;;) {
		std::cout << "Type a: ";
		std::cin >> a;
		rslt = asm_arth(a);
		std::cout << std::endl << "FPU atanh = " << rslt << " ; cmath atanh =  " << atanh(a) << std::endl;
	}
	system("pause");
	return 0;
}