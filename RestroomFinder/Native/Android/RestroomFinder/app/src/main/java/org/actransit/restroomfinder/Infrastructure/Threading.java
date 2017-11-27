package org.actransit.restroomfinder.Infrastructure;

import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.Lock;


/**
 * Created by atajadod on 5/17/2016.
 */
public class Threading {
    public static void lock(Lock lock,Runnable run){
        try{
            lock.lock();
            run.run();
        }
        finally {
            lock.unlock();
        }
    }
}
