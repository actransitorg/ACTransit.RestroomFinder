package org.actransit.restroomfinder.Infrastructure;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.support.v4.app.ActivityCompat;
import android.util.Log;

import org.actransit.restroomfinder.StartupActivity;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.jar.Manifest;

/**
 * Created by DevTeam on 7/5/16.
 */
public class UpdateApp extends AsyncTask<String,Void,Void> {


    private IProcess process;
    private Context context;


    public UpdateApp(IProcess process){
        this.process=process;
    }

    public void setContext(Context contextf){
        context = contextf;
    }


    @Override
    protected Void doInBackground(String... arg0) {
        try {
            URL url = new URL(arg0[0]);
            String fileName=arg0[1];
            HttpURLConnection c = (HttpURLConnection) url.openConnection();
            c.setRequestMethod("GET");
            //c.setDoOutput(true);
            c.connect();
            int len=c.getContentLength();
            int downloaded=0;

            if (process!=null)
                process.percent(0);

            String PATH = "/mnt/sdcard/Download/";
            File file = new File(PATH);
            file.mkdirs();
            File outputFile = new File(file, fileName);
            if(outputFile.exists()){
                outputFile.delete();
            }
             FileOutputStream fos = new FileOutputStream(outputFile);

            InputStream is = c.getInputStream();

            byte[] buffer = new byte[1024];
            int len1 = 0;
            while ((len1 = is.read(buffer)) != -1) {
                downloaded +=len1;
                fos.write(buffer, 0, len1);
                if (process!=null) process.percent((int)Math.floor(downloaded* 100/len));
            }
            fos.close();
            is.close();


            if (process!=null) process.finished("/mnt/sdcard/Download/" + fileName);

        } catch (Exception e) {
            if (process!=null)
                process.error(e);
            Log.e("UpdateAPP", "Update error! " + e.getMessage());
        }
        return null;
    }

    public interface IProcess{
        public void percent(int percent);
        public void finished(String fileName);
        public void error(Exception e);
    }
}