#include <iostream>
#include <cstdlib>
#include <cmath>

using namespace std;

extern "C" float asm_sinh(float k);

int main() {
	float k;
	float rslt = 0;
	for (;;) {
		cout << "I need k: ";
		cin >> k;
		rslt = asm_sinh(k);
		cout << endl;
		cout << "sinh = " << rslt;
		cout << " | cmath function: " << sinh(k) << endl;
	}
	return 0;
}