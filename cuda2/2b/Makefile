NVCC = nvcc

cuda2b: headers.h kernel.cu host.cu
	PATH=/usr/local/cuda/bin:$(PATH) LD_LIBRARY_PATH=/usr/local/cuda/lib:/usr/local/cuda/lib64:$(LD_LIBRARY_PATH) $(NVCC) -I ./ kernel.cu host.cu -o cuda2b

run: cuda2b
	./cuda2b

clean:
	rm -rf cuda2b
