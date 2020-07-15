#include <iostream>
#include <cstdlib>
#include <cmath>
#include <windows.h>

extern "C"  float asm_chtan(float k);

int main() {
	float k;
	float rslt = 0;
	for (;;) {
		std::cout << "I need k: ";
		std::cin >> k;
		rslt = asm_chtan(k);
		std::cout << std::endl << "tanh = " << rslt << " or " << tanh(k) << std::endl;
	}
	system("pause");
	return 0;
}