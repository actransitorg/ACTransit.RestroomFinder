package com.tellexperience.jsonhelper;

/**
 * Created by Aidin on 1/22/2017.
 */

import android.content.Context;
import android.util.Log;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.EventObject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

public class ServerBaseAPI {

    private Context context;
    private Context applicationContext;
    private final List<ServerAPIEventListener> listeners;
    protected HashMap<String, String> headers;
    protected int SOCKET_TIMEOUT_MS=10000;

    public ServerBaseAPI(Context applicationContext){
        //this.context=context;
        this.applicationContext=applicationContext;
        this.listeners = new CopyOnWriteArrayList<ServerAPIEventListener>();
        this.headers=new HashMap<String, String>();
    }

    public ServerBaseAPI(Context applicationContext, HashMap<String, String> headers){
        //this.context=context;
        this.applicationContext=applicationContext;
        this.listeners = new CopyOnWriteArrayList<ServerAPIEventListener>();
        this.headers=headers;
    }

    protected  <T> void Get(String url, Class<T> type,final ServerResult callBack){
        //Boolean isArray=isArrayResult(callBack);
        SendRequest(Request.Method.GET, url,(JSONArray) null,type, callBack);
    }
    protected <T> void Post(String url, JSONObject jsonObject, Class<T> type, final ServerResult callBack){
        //Boolean isArray=isArrayResult(callBack);
        SendRequest(Request.Method.POST, url,jsonObject,type, callBack);
    }

    private <T> void SendRequest(int method, String url, JSONArray jsonRequest,final Class<T> type, final ServerResult callBack ){
        showWait();
        final Boolean isArray=isArrayResult(callBack);
        Response.Listener listener = isArray? CreateJsonArrayResponseListener(type, callBack) :CreateJsonObjectResponseListener(type, callBack);
        Response.ErrorListener errorListener = CreateErrorResponseListener(callBack);
        if (isArray){
            MyJsonArrayRequest jsObjRequest =CreateArrayRequest(method, url, jsonRequest, listener, errorListener);
            jsObjRequest.setRetryPolicy(new DefaultRetryPolicy(
                    SOCKET_TIMEOUT_MS,
                    DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                    DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
            addToRequestQueue(jsObjRequest);
        }
        else{
            MyJsonObjectRequest jsObjRequest = CreateObjectRequest(method, url, jsonRequest, listener,errorListener);
            jsObjRequest.setRetryPolicy(new DefaultRetryPolicy(
                    SOCKET_TIMEOUT_MS,
                    DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                    DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
            addToRequestQueue(jsObjRequest);
        }

    }
    public void addServerAPIEventListener(ServerAPIEventListener listener) {
        listeners.add(listener);
    }
    public void removeServerAPIEventListener(ServerAPIEventListener listener) {
        listeners.remove(listener);
    }
    private <T> void SendRequest(int method, String url, JSONObject jsonRequest,final Class<T> type, final ServerResult callBack ){
        showWait();
        final Boolean isArray=isArrayResult(callBack);
        Response.Listener listener = isArray? CreateJsonArrayResponseListener(type, callBack) :CreateJsonObjectResponseListener(type, callBack);
        Response.ErrorListener errorListener = CreateErrorResponseListener(callBack);

        if (isArray){
            MyJsonArrayRequest jsObjRequest = CreateArrayRequest (method, url, jsonRequest, listener, errorListener);
            jsObjRequest.setRetryPolicy(new DefaultRetryPolicy(
                    SOCKET_TIMEOUT_MS,
                    DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                    DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
            addToRequestQueue(jsObjRequest);
        }
        else{
            MyJsonObjectRequest jsObjRequest = CreateObjectRequest(method, url, jsonRequest, listener,errorListener);
            jsObjRequest.setRetryPolicy(new DefaultRetryPolicy(
                    SOCKET_TIMEOUT_MS,
                    DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                    DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
            addToRequestQueue(jsObjRequest);
        }
    }

    private MyJsonArrayRequest CreateArrayRequest(int method, String url, JSONArray jsonRequest,
                                                       Response.Listener<JSONArray> listener, Response.ErrorListener errorListener){
        if (this.headers==null || this.headers.isEmpty())
            return new MyJsonArrayRequest(method, url, jsonRequest, listener, errorListener);
        else
            return new MyJsonArrayRequest(method, url, jsonRequest, listener, errorListener){
                @Override
                public Map<String, String> getHeaders() throws AuthFailureError {
                    return headers;
                }
            };
    }
    private MyJsonArrayRequest CreateArrayRequest(int method, String url, JSONObject jsonRequest,
                                                  Response.Listener<JSONArray> listener, Response.ErrorListener errorListener){
        if (this.headers==null || this.headers.isEmpty())
            return new MyJsonArrayRequest(method, url, jsonRequest, listener, errorListener);
        else
            return new MyJsonArrayRequest(method, url, jsonRequest, listener, errorListener){
                @Override
                public Map<String, String> getHeaders() {
                    return headers;
                }
            };
    }


    private MyJsonObjectRequest CreateObjectRequest(int method, String url, JSONArray jsonRequest,
                                                    Response.Listener<JSONObject> listener, Response.ErrorListener errorListener){
        if (this.headers==null || this.headers.isEmpty())
            return new MyJsonObjectRequest(method, url, jsonRequest, listener, errorListener);
        else
            return new MyJsonObjectRequest(method, url, jsonRequest, listener, errorListener){
                @Override
                public Map<String, String> getHeaders() {
                    return headers;
                }
            };
    }
    private MyJsonObjectRequest CreateObjectRequest(int method, String url, JSONObject jsonRequest,
                                                    Response.Listener<JSONObject> listener, Response.ErrorListener errorListener){
        if (this.headers==null || this.headers.isEmpty())
            return new MyJsonObjectRequest(method, url, jsonRequest, listener, errorListener);
        else
            return new MyJsonObjectRequest(method, url, jsonRequest, listener, errorListener){
                @Override
                public Map<String, String> getHeaders() {
                    return headers;
                }
            };
    }


    private <T> Response.Listener<JSONArray> CreateJsonArrayResponseListener(final Class<T> type,final ServerResult callBack){
        return new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {
                hideWait();
                try{
                    List<T> result= JsonMapper.toObjects(response,type);
                    callBack.Always(result,null);
                }
                catch (Exception e){
                    e.printStackTrace();
                    callBack.Always(null,e);
                }
            }
        };
    }
    private <T> Response.Listener<JSONObject>  CreateJsonObjectResponseListener(final Class<T> type,final ServerResult callBack){
        return new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                hideWait();
                try{
                    T result= JsonMapper.toObject(response,type);
                    callBack.Always(result,null);
                }
                catch (Exception e){
                    e.printStackTrace();
                    callBack.Always(null,e);
                }
            }
        };
    }
    private <T> Response.ErrorListener  CreateErrorResponseListener(final ServerResult callBack){
        return  new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                hideWait();
                error.printStackTrace();
                String errorMessage=error.getMessage();
                if (errorMessage!=null)
                    Log.d("Error",errorMessage );
                callBack.Always(null,error);
                // TODO Auto-generated method stub

            }
        };
    }

    private boolean isArrayResult(ServerResult callBack){
        Type[] genericInterfaces = callBack.getClass().getGenericInterfaces();
        for (Type genericInterface : genericInterfaces) {
            if (genericInterface instanceof ParameterizedType) {
                Type[] genericTypes = ((ParameterizedType) genericInterface).getActualTypeArguments();
                for (Type genericType : genericTypes) {
                    if (genericType instanceof ParameterizedType && (((ParameterizedType) genericType).getRawType().equals(List.class) || ((ParameterizedType) genericType).getRawType().equals(ArrayList.class))){
                        return true;
                    }
                }
            }
        }
        Type superClass = callBack.getClass().getGenericSuperclass();
        if (superClass != null){
            if (superClass instanceof ParameterizedType) {
                Type[] genericTypes = ((ParameterizedType) superClass).getActualTypeArguments();
                for (Type genericType : genericTypes) {
                    if (genericType instanceof ParameterizedType && (((ParameterizedType) genericType).getRawType().equals(List.class) || ((ParameterizedType) genericType).getRawType().equals(ArrayList.class))){
                        return true;
                    }
                }
            }
        }

        return false;
    }
    private Integer waitCount=0;
    public void showWait(){
        waitCount++;
        ServerAPIEvent event=new ServerAPIEvent(this,waitCount);
        for(ServerAPIEventListener listener : listeners){
            listener.started(event);
        }
    }
    public void hideWait(){
        waitCount--;
        if (waitCount<0)
            waitCount=0;
        ServerAPIEvent event=new ServerAPIEvent(this,waitCount);
        for(ServerAPIEventListener listener : listeners){
            listener.finished(event);
        }
    }

    private static RequestQueue mRequestQueue;
    public RequestQueue getRequestQueue() {
        if (mRequestQueue == null) {
            // getApplicationContext() is key, it keeps you from leaking the
            // Activity or BroadcastReceiver if someone passes one in.
            mRequestQueue = Volley.newRequestQueue(applicationContext);
        }
        return mRequestQueue;
    }

    public <T> void addToRequestQueue(Request<T> req) {
        getRequestQueue().add(req);
    }


    public interface ServerResult<T>{
        public void Always(T data, Exception error);
    }

    public interface ServerAPIEventListener
    {
        void started(ServerAPIEvent event);
        void finished(ServerAPIEvent event);
    }

    public class ServerAPIEvent extends EventObject {
        public ServerAPIEvent(Object source) {super(source);}
        public ServerAPIEvent(Object source,int numberOfRequests) {
            super(source);
            this.numberOfRequests=numberOfRequests;
        }
        public int numberOfRequests;
    }
}
