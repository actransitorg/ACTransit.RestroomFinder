package org.actransit.restroomfinder.Infrastructure;

/**
 * Created by DevTeam on 7/14/16.
 */

import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;

/**
 * Created by DevTeam on 7/14/16.
 */
public class DoubleRingBuffer {

    private Queue<Double> buffer;

    private int maxSize;
    public DoubleRingBuffer(int maxSize) {
        this.maxSize = maxSize;
        clear();
    }

    public void add(Double toAdd) {
        if(buffer.size()>=maxSize)
            buffer.remove();
        buffer.add(toAdd);

    }
    public Double remove() {
        return buffer.remove();
    }
    public Double peed() {
        return buffer.peek();
    }

    public Double average(){
        double average=0;
        Double[] res=buffer.toArray(new Double[0]);

        for(int i=0;i<res.length;i++){
            average+=res[i];
        }
        return average/res.length;
    }

    public void clear(){
        buffer=new ArrayBlockingQueue<Double>(maxSize);
    }
}
