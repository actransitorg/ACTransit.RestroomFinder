package org.actransit.restroomfinder.Infrastructure;

import android.os.AsyncTask;
import org.actransit.restroomfinder.Interface.TaskInterface;

/**
 * Created by atajadod on 5/17/2016.
 */
public class Task extends AsyncTask<Object, Void, Object>{

    final TaskInterface task;
    Task(TaskInterface callBack){
        this.task = callBack;
    }
    @Override
    protected Object doInBackground(Object... params) {
        try{
            return task.Task(params);
        }
        catch (Exception ex){
            task.onError(ex);
        }
        return null;
    }

    @Override
    protected void onPostExecute(Object o) {
        super.onPostExecute(o);
        task.onTaskFinished(o);
    }
}

