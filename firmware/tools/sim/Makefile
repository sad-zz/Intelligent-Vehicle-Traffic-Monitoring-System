# Host-side regression test for the W25Q64JVS storage layer and the
# activation-code logic.  It compiles firmware/Main/W25Q64.h and License.h
# against a behavioural model of the flash chip, so the parts of the firmware
# that are hard to observe on the board can be exercised on a PC.
#
#   make && ./sim
#
# It does NOT replace a test on real hardware; it only proves the logic.

CXX      ?= g++
CXXFLAGS ?= -std=c++11 -Wall -O1
INC      := -I. -I../../Main

sim: sim_main.cpp mikroc_stub.h ../../Main/W25Q64.h ../../Main/License.h
	$(CXX) $(CXXFLAGS) $(INC) -o $@ sim_main.cpp

.PHONY: check clean
check: sim
	./sim

clean:
	rm -f sim
