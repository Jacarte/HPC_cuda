
N="10 100 1000 10000 100000 1000000 2000000 3000000 5000000 9000000 10000000 100000000 500000000 900000000" 
Os="-O0 -O1 -O2 -O3"

for o in $Os 
do
    echo "1" > time$o.txt
	for i in $N 
	do
		echo $i $o

		nvcc saxpy.cu $o -DTHREADS=256 -DN=$i -o saxpy.out
		srun -n 1 ./saxpy.out >> time$o.txt
	done
done