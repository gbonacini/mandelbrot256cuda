OPTS = -O3 -I. -std=c++20 

all: mandelbrotcuda

parseCmdLine.o: parseCmdLine.cu parseCmdLine.hpp
	nvcc -c $(OPTS)   -o $@ $<

mandelbrot256cuda.o: mandelbrot256cuda.cu  mandelbrot256cuda.hpp
	nvcc -c $(OPTS)   -o $@  $<

mandelbrotcuda.o: mandelbrotcuda.cu
	nvcc -c $(OPTS)   -o $@  $<

mandelbrotcuda: mandelbrotcuda.o mandelbrot256cuda.o parseCmdLine.o
	nvcc $(OPTS)   $ -o $@  $?

clean:
	rm -f *.o mandelbrotcuda

