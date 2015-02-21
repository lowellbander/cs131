
nthreads=20
ntransitions=100
maxval=10

javac UnsafeMemory.java && (
echo "Running Null test"
java UnsafeMemory Null $nthreads $ntransitions 10 1 2 3 4 5
echo "Running Synchronized test"
java UnsafeMemory Synchronized $nthreads $ntransitions 10 1 2 3 4 5
echo "Running Unsynchronized test"
java UnsafeMemory Unsynchronized $nthreads $ntransitions 10 1 2 3 4 5
echo "Running GetNSet test"
java UnsafeMemory GetNSet $nthreads $ntransitions 10 1 2 3 4 5
) && bash clean.sh
