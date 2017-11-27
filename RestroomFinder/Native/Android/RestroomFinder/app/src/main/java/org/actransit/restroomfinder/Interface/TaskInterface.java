package org.actransit.restroomfinder.Interface;

/**
 * Created by atajadod on 5/18/2016.
 */
public interface TaskInterface{
    Object Task(Object... params);
    void onTaskFinished(Object result);
    void onError(Exception ex);
}
