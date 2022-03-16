//package org.actransit.restroomfinder.Infrastructure;
//
//import android.app.ProgressDialog;
//import android.net.ConnectivityManager;
//import android.net.NetworkInfo;
//import android.os.AsyncTask;
//import android.util.Log;
//
//import com.android.volley.AuthFailureError;
//import com.android.volley.DefaultRetryPolicy;
//import com.android.volley.Request;
//import com.android.volley.Response;
//import com.android.volley.TimeoutError;
//import com.android.volley.VolleyError;
//import com.android.volley.toolbox.JsonArrayRequest;
//import com.google.android.gms.maps.model.BitmapDescriptorFactory;
//import com.google.android.gms.maps.model.LatLng;
//import com.google.android.gms.maps.model.Marker;
//import com.google.android.gms.maps.model.MarkerOptions;
//
//import org.actransit.restroomfinder.Adapter.CustomRestroomArrayAdapter;
//import org.actransit.restroomfinder.MapviewActivity;
//import org.actransit.restroomfinder.Model.RestroomModel;
//import org.json.JSONArray;
//import org.json.JSONObject;
//
//import java.io.BufferedInputStream;
//import java.io.IOException;
//import java.io.InputStream;
//import java.lang.reflect.ParameterizedType;
//import java.lang.reflect.Type;
//import java.net.HttpURLConnection;
//import java.net.MalformedURLException;
//import java.net.URL;
//import java.net.URLConnection;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//import java.util.Scanner;
//
//import javax.net.ssl.HttpsURLConnection;
//import android.content.ComponentName;
//import android.app.ActivityManager;
//import android.content.Context;
//import com.android.volley.toolbox.JsonObjectRequest;
//import com.google.gson.Gson;
//import com.google.gson.reflect.TypeToken;
//
///**
// * Created by atajadod on 5/16/2016.
// */
//public class ServerBaseAPI { //extends AsyncTask<String,Void, String> {
//    private static final int SOCKET_TIMEOUT_MS=15000;
//    private Context context;
//    private String sessionId;
//
//    public ServerBaseAPI(Context context, String sessionId){
//        this.context=context;
//        this.sessionId=sessionId;
//    }
//    ProgressDialog mDialog;
//    protected  <T> void Get(String url, Class<T> type,final ServerResult callBack){
//        Boolean isArray=false;
//        Type[] genericInterfaces = callBack.getClass().getGenericInterfaces();
//        for (Type genericInterface : genericInterfaces) {
//            if (genericInterface instanceof ParameterizedType) {
//                Type[] genericTypes = ((ParameterizedType) genericInterface).getActualTypeArguments();
//                for (Type genericType : genericTypes) {
//                    if (genericType instanceof ParameterizedType && (((ParameterizedType) genericType).getRawType().equals(List.class) || ((ParameterizedType) genericType).getRawType().equals(ArrayList.class))){
//                        isArray=true;
//                        break;
//                    }
//                }
//            }
//        }
//
//        if (isArray)
//            SendRequest(Request.Method.GET, url,(JSONArray) null,type, callBack);
//        else
//            SendRequest(Request.Method.GET, url,(JSONObject) null,type, callBack);
//
//    }
//    protected <T> void Post(String url, JSONObject jsonObject, Class<T> type, final ServerResult callBack){
//        SendRequest(Request.Method.POST, url,jsonObject,type, callBack);
//    }
//
//    private <T> void SendRequest(int method, String url, JSONArray jsonRequest,final Class<T> type, final ServerResult callBack ){
//
//        showWait();
//        JsonArrayRequest jsObjRequest = new JsonArrayRequest(method, url, jsonRequest, new Response.Listener<JSONArray>() {
//                    @Override
//                    public void onResponse(JSONArray response) {
//                        hideWait();
//                        try{
//                            //Gson gson = new Gson();
//                            //Type collectionType = new TypeToken<List<T>>(){}.getType();
//                            //Type collectionType = type;
//                            //List<T> result=(List<T>)gson.fromJson(response.toString(),collectionType);
//                            //List<T> result= JSONMapper.toObjects(response,List<T>);
//                            callBack.Always(result,null);
//                        }
//                        catch (Exception e){
//                            e.printStackTrace();
//                            callBack.Always(null,e);
//                        }
//                    }
//                }, new Response.ErrorListener() {
//                    @Override
//                    public void onErrorResponse(VolleyError error) {
//                        hideWait();
//                        error.printStackTrace();
//                        String errorMessage=error.getMessage();
//                        if (errorMessage!=null)
//                            Log.d("Error",errorMessage );
//                        callBack.Always(null,error);
//                        // TODO Auto-generated method stub
//
//                    }
//                })
//        {
//            @Override
//            public Map<String, String> getHeaders() throws AuthFailureError {
//                HashMap<String, String> headers = new HashMap<String, String>();
//                //headers.put("Content-Type", "application/json");
//                headers.put("sessionId", sessionId);
//                return headers;
//            }
//        };
//        jsObjRequest.setRetryPolicy(new DefaultRetryPolicy(
//                SOCKET_TIMEOUT_MS,
//                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
//                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
//        MySingleton.getInstance(MyApplication.getAppContext()).addToRequestQueue(jsObjRequest);
//    }
//    private <T> void SendRequest(int method, String url, JSONObject jsonRequest,final Class<T> type, final ServerResult callBack ){
//        showWait();
//        JsonObjectRequest jsObjRequest = new JsonObjectRequest(method, url, jsonRequest, new Response.Listener<JSONObject>() {
//                    @Override
//                    public void onResponse(JSONObject response) {
//                        hideWait();
//                        try{
//                            T result= JSONMapper.toObject(response,type);
//                            callBack.Always(result,null);
//                        }
//                        catch (Exception e){
//                            e.printStackTrace();
//                            callBack.Always(null,e);
//                      }
//                    }
//                }, new Response.ErrorListener() {
//                    @Override
//                    public void onErrorResponse(VolleyError error) {
//                        hideWait();
//                        error.printStackTrace();
//                        String errorMessage=error.getMessage();
//                        if (errorMessage!=null)
//                            Log.e("Error",errorMessage );
//                        else if (error instanceof TimeoutError)
//                            Log.e("Error","Network Timeout. Please try again." );
//
//                        callBack.Always(null,error);
//                        // TODO Auto-generated method stub
//
//                    }
//                })
//        {
//            @Override
//            public Map<String, String> getHeaders() throws AuthFailureError {
//                HashMap<String, String> headers = new HashMap<String, String>();
//                //headers.put("Content-Type", "application/json");
//                headers.put("sessionId", sessionId);
//                return headers;
//            }
//        };
//        jsObjRequest.setRetryPolicy(new DefaultRetryPolicy(
//                SOCKET_TIMEOUT_MS,
//                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
//                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
//
//        MySingleton.getInstance(MyApplication.getAppContext()).addToRequestQueue(jsObjRequest);
//
//    }
//
//
//    Integer waitCount=0;
//    public void showWait(){
//        waitCount++;
//        if (mDialog==null || !mDialog.isShowing())
//            showWaitDialog();
//    }
//    public void hideWait(){
//        waitCount--;
//        if (waitCount<0)
//            waitCount=0;
//        if (mDialog!=null && waitCount==0)
//            mDialog.dismiss();
//    }
//
//    public ProgressDialog showWaitDialog(){
//        //Context context=MyApplication.getAppContext();
//        //ActivityManager am = (ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
//        //ComponentName cn = am.getRunningTasks(1).get(0).topActivity;
//
//        mDialog = new ProgressDialog(context);
//        mDialog.setMessage("Please wait...");
//        mDialog.setCancelable(false);
//        mDialog.show();
//        return mDialog;
////        return null;
//    }
//
//
////    String charset = "UTF-8";
////    String contentType="application/json";
////    public String Get(String urlString) {
////        HttpURLConnection urlConnection = (HttpURLConnection)GetConnection(urlString);
////
////        try {
////            Log.d("input stream: ","here we are");
////            InputStream response = urlConnection.getInputStream();
////            try (Scanner scanner = new Scanner(response)) {
////                String responseBody = scanner.useDelimiter("\\A").next();
////                System.out.println(responseBody);
////                Log.d("Response", responseBody);
////            }
////
////        }
////        catch(MalformedURLException e){
////            e.printStackTrace();
////        }
////        catch (IOException e){
////            e.printStackTrace();
////        }
////        catch(Exception e){
////            e.printStackTrace();
////        }
////        finally{
////            Log.d("input stream: ","finally here we are");
////            if (urlConnection!=null) urlConnection.disconnect();
////        }
////        return "";
////    }
////
////    public URLConnection GetConnection(String urlString) {
////        URL url= null;
////        try{
////            url=new URL(urlString);
////            Log.d("GetConnection func", "GetConnection: " + url.getProtocol());
////        }
////        catch(MalformedURLException e)
////        {
////            e.printStackTrace();
////            return null;
////        }
////        try {
////            URLConnection urlConnection = url.openConnection();
////            urlConnection.setRequestProperty("Accept-Charset", charset);
////            urlConnection.setRequestProperty("Content-Type", contentType);
////            return urlConnection;
////        }
////        catch (IOException e){
////            e.printStackTrace();
////            return null;
////        }
////        catch (Exception e){
////            e.printStackTrace();
////            return null;
////        }
////        finally{
////        }
////    }
//
////    private HttpsURLConnection GetHttpsConnection(URL url){
////        HttpsURLConnection urlConnection = null;
////        try {
////            urlConnection = (HttpsURLConnection) url.openConnection();
////        }
////        catch(MalformedURLException e){
////            e.printStackTrace();
////        }
////        catch (IOException e){
////            e.printStackTrace();
////        }
////        finally{
////            if (urlConnection!=null) urlConnection.disconnect();
////        }
////    }
////    private HttpsURLConnection GetHttpConnection(URL url){
////        HttpURLConnection urlConnection = null;
////        try {
////            urlConnection = (HttpURLConnection) url.openConnection();
////        }
////        catch(MalformedURLException e){
////            e.printStackTrace();
////        }
////        catch (IOException e){
////            e.printStackTrace();
////        }
////        finally{
////            if (urlConnection!=null) urlConnection.disconnect();
////        }
////    }
//
//
//    public interface ServerResult<T>{
//        public void Always(T data, Exception error);
//    }
//
//}
//
