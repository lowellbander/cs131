
nthreads=20
ntransitions=100
maxval=10

echo "Running Null test"
javac UnsafeMemory.java && java UnsafeMemory Null $nthreads $ntransitions 10 1 2 3 4 5
echo "Running Synchronized test"
javac UnsafeMemory.java && java UnsafeMemory Synchronized $nthreads $ntransitions 10 1 2 3 4 5
echo "Running Unsynchronized test"
javac UnsafeMemory.java && java UnsafeMemory Unsynchronized $nthreads $ntransitions 10 1 2 3 4 5
