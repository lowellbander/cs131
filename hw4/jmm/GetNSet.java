import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSet implements State {
    private AtomicIntegerArray atomic_value;
    private byte maxval;

    /* given an array of bytes, returns an AtomicIntegerArray */
    private AtomicIntegerArray aiaFromBytes(byte[] v) {
        AtomicIntegerArray a = new AtomicIntegerArray(v.length);
        for (int i = 0; i < v.length; ++i) a.set(i, (int)v[i]);
        return a;
    }

    GetNSet(byte[] v) { 
        atomic_value = aiaFromBytes(v);
        maxval = 127; 
    }

    GetNSet(byte[] v, byte m) { 
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

        atomic_value.set(i, atomic_value.get(i) - 1);
        atomic_value.set(j, atomic_value.get(j) + 1);

	    return true;
    }
}
