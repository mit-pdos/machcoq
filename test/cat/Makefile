.PHONY=all

CXX=clang++
CXXFLAGS?=-g -O3 -fno-stack-protector -pedantic -Wno-switch-bool -std=c++17 -I../../include

all: cat

Cat.json: Cat.v
	coqc -Q ../../classes "" $<

Cat.cpp: Cat.json
	stack exec mcqc -- $<

cat: main.cpp Cat.cpp
	@echo --------------------------------------------------------------------------------
	@echo Compiling $@ ...
	${CXX} ${CXXFLAGS} $< -o $@


clean:
	-rm -rf cat Cat.cpp *.aux *.dSYM *.glob *.vo *.json *.o *.vok *.vos

