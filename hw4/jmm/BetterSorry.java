import java.util.concurrent.atomic.AtomicIntegerArray;

class BetterSorry implements State {
    private AtomicIntegerArray atomic_value;
    private byte maxval;

    /* given an array of bytes, returns an AtomicIntegerArray */
    private AtomicIntegerArray aiaFromBytes(byte[] v) {
        AtomicIntegerArray a = new AtomicIntegerArray(v.length);
        for (int i = 0; i < v.length; ++i) a.set(i, (int)v[i]);
        return a;
    }

    BetterSorry(byte[] v) { 
        atomic_value = aiaFromBytes(v);
        maxval = 127; 
    }

    BetterSorry(byte[] v, byte m) { 
        atomic_value = aiaFromBytes(v);
        maxval = m; 
    }

    public int size() { return atomic_value.length(); }

    public byte[] current() { 
        byte[] b = new byte[size()];
        for (int i = 0; i < size(); ++i) b[i] = (byte)atomic_value.get(i);
        return b;  
    }

    public boolean swap(int i, int j) {

        if (atomic_value.get(i) <= 0 || atomic_value.get(j) >= maxval)
            return false;

        atomic_value.getAndDecrement(i);
        atomic_value.getAndIncrement(j);

	    return true;
    }
}
