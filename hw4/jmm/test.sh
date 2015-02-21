
nthreads=20
ntransitions=999999
maxval=127

javac UnsafeMemory.java && (
    echo "Running Null test"
    java UnsafeMemory Null $nthreads $ntransitions $maxval 1 2 3 4 5
    echo "Running Synchronized test"
    java UnsafeMemory Synchronized $nthreads $ntransitions $maxval 1 2 3 4 5
    echo "Running Unsynchronized test"
    java UnsafeMemory Unsynchronized $nthreads $ntransitions $maxval 1 2 3 4 5
    echo "Running GetNSet test"
    java UnsafeMemory GetNSet $nthreads $ntransitions $maxval 1 2 3 4 5
    echo "Running BetterSafe test"
    java UnsafeMemory BetterSafe $nthreads $ntransitions $maxval 1 2 3 4 5
    echo "Running BetterSorry test"
    java UnsafeMemory BetterSorry $nthreads $ntransitions $maxval 1 2 3 4 5
) 
bash clean.sh
