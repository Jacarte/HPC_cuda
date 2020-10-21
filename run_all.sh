
N="10 100 1000 10000 100000 1000000 2000000 3000000 5000000"
Os="-O0 -O1 -O2 -O3"

for o in $Os 
do
    echo "1" > time$o.txt
	for i in $N 
	do
		nvcc saxpy.cu $o -DTHREADS=256 -DN=$i -o saxpy.out
		srun -n 1 ./saxpy.out >> time$o.txt
	done
done