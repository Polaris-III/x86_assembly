//	Программа содержит бесконечный цикл; выход из программы не предусмотрен; "защиты от дурака" нет
//	Программа запрашивает значение, которое использует для расчета гиперболического косинуса
//	Предоставляет два варианта результата
#include <iostream>
#include <cstdlib>
#include <cmath>

extern "C"  float asm_cosh(float x);

int main() {
	float x;
	for (;;) {
		std::cout << "Type x: ";
		std::cin >> x;
		std::cout << std::endl << "FPU cosh:   " << asm_cosh(x) << std::endl << "cmath cosh: " << cosh(x) << std::endl;
	}
	system("pause");
	return 0;
}