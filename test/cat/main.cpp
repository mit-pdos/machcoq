#include <iostream>
#include "benchmark.h"
#include "Cat.cpp"
#include "proc.cpp"

using namespace proc;

int main(int argc, char** argv) {
    for(int i = 1; i < argc; ++i) {
    	tic();
		cat(".", argv[i]);
    	toc();
	}
    return 0;
}

