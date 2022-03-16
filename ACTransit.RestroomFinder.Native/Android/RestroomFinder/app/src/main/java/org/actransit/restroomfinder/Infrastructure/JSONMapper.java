package org.actransit.restroomfinder.Infrastructure;

import android.provider.Settings;
import android.util.Log;


import org.actransit.restroomfinder.Model.RestroomModel;
import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Objects;

///**
// * Created by atajadod on 5/18/2016.
// */
//public class JSONMapper {
//    private static Gson getGson(){
//        JsonSerializer<Date> ser = new JsonSerializer<Date>() {
//            @Override
//            public JsonElement serialize(Date src, Type typeOfSrc, JsonSerializationContext
//                    context) {
//                Long lng=src.getTime();
//                return src == null ? null : new JsonPrimitive(src.getTime());
//            }
//        };
//
//        JsonDeserializer<Date> deser = new JsonDeserializer<Date>() {
//            @Override
//            public Date deserialize(JsonElement json, Type typeOfT,
//                                    JsonDeserializationContext context) throws JsonParseException {
//                Long lng=json.getAsLong();
//                return json == null ? null : new Date(lng);
//            }
//        };
//
//        Gson gson = new GsonBuilder()
//                .registerTypeAdapter(Date.class, ser)
//                .registerTypeAdapter(Date.class, deser).create();
//        return gson;
//    }
//    public static <T> JSONArray toJSONArray(List<T> obj, Class<T> type){
//        Gson gson = getGson();
//        String objStr=gson.toJson(obj,type);
//        try{
//            return new JSONArray(objStr);
//        }catch(Exception e){
//            e.printStackTrace();
//            return null;
//        }
////        JSONArray result=new JSONArray();
////        try{
////            for (T o:obj) {
////                result.put(toJSON(o,type));
////            }
////        }
////        catch(Exception e){
////            e.printStackTrace();
////        }
////        return result;
//    }
//    public static <T> JSONObject toJSON(T obj, Class<T> type){
//        Gson gson = getGson();
//        String objStr=gson.toJson(obj,type);
//        try{
//            return new JSONObject(objStr);
//        }catch(Exception e){
//            e.printStackTrace();
//            return null;
//        }
//
////
////        JSONObject jSonObj=new JSONObject();
////        try{
////            Field[] fields = getFields(type);
////            for (Field f : fields) {
////                if (f.toString().startsWith("public")){
////                    Property annotation= f.getAnnotation(Property.class);
////                    String name = f.getName();
////                    if (annotation!=null )
////                    {
////                        if (annotation.Ignore())
////                            continue;
////                        name = annotation.Name();
////                    }
////                    if (name == null || name=="")
////                        name = f.getName();
////                    jSonObj.put(name,f.get(obj));
////                }
////            }
////        }
////        catch(Exception e){
////            e.printStackTrace();
////        }
////        return jSonObj;
//    }
//
//    //public static <T> List<T> toObjects(JSONArray arrayObj, Class<T> type) {
//    public static <T> T toObjects(JSONArray arrayObj, Class<T> type) {
//        Gson gson = getGson();
//        return gson.fromJson(arrayObj.toString(),type);
//
////        try {
////            List<T> result = new ArrayList<T>();
////            if (arrayObj==null || arrayObj.length()<=0)
////                return null;
////
////
////            Field[] fields = getFields(type);
////            Method[] methods= getMethods(type);
////            //List<NameType> names = new ArrayList<>();
////            Hashtable<String, Field> fieldNames= new Hashtable<>();
////            Hashtable<String, Method> methodNames= new Hashtable<>();
////            for (Field f : fields) {
////                if (f.toString().startsWith("public")){
////                    Property annotation= f.getAnnotation(Property.class);
////                    String name = f.getName();
////                    if (annotation!=null )
////                    {
////                        if (annotation.Ignore())
////                            continue;
////                        name = annotation.Name();
////                    }
////                    if (name == null || name=="")
////                        name = f.getName();
////                    fieldNames.put(name, f);
////                }
////            }
////            for (Method m : methods) {
////                if (m.toString().startsWith("public")){
////                    Property annotation= m.getAnnotation(Property.class);
////                    if (annotation != null && annotation.PropertyType() != Property.PropertyTypeEnum.Get){
////                        Type[] types=m.getGenericParameterTypes();
////                        if (types.length!= 1){
////                            Log.e("toObjects","Property Annotation on wrong method! Method does not have right input parameter.");
////                        }
////                        else{
////                            String name = annotation.Name();
////                            if (name== null || name=="")
////                                name= m.getName();
////                            methodNames.put(name, m);
////                        }
////                    }
////                }
////            }
////
////
////            JSONArray jsonNames = arrayObj.getJSONObject(0).names();
////            List<NameType> availableFieldNames =  new ArrayList<>();
////            List<NameType> availableMethodNames =  new ArrayList<>();
////
////            for (Integer i = 0; i < jsonNames.length(); i++) {
////                String name = jsonNames.get(i).toString();
////                if (fieldNames.containsKey(name)) {
////                    Field f= fieldNames.get(name);
////                    availableFieldNames.add(new NameType(name,f.getGenericType(),f));
////                }
////                if (methodNames.containsKey(name)) {
////                    Method m= methodNames.get(name);
////                    availableMethodNames.add(new NameType(name,m.getParameterTypes()[0],m));
////                }
////            }
////
////            for (Integer i=0;i<arrayObj.length();i++){
////                JSONObject obj = arrayObj.getJSONObject(i);
////                result.add(createObject(obj,availableFieldNames,availableMethodNames, type));
////            }
////            return result;
////        }
////        catch (Exception e){
////            e.printStackTrace();
////        }
////        return null;
//    }
//
//    public static <T> T toObject(JSONObject jsonObj, Class<T> type) {
//        Gson gson = getGson();
//        return gson.fromJson(jsonObj.toString(), type);
////        try {
////            T result = type.newInstance();
////            if (jsonObj==null)
////                return null;
////
////
////            Field[] fields = getFields(type);
////            Method[] methods= getMethods(type);
////            //List<NameType> names = new ArrayList<>();
////            Hashtable<String, Field> fieldNames= new Hashtable<>();
////            Hashtable<String, Method> methodNames= new Hashtable<>();
////            for (Field f : fields) {
////                if (f.toString().startsWith("public")){
////                    Property annotation= f.getAnnotation(Property.class);
////                    String name = f.getName();
////                    if (annotation!=null )
////                    {
////                        if (annotation.Ignore())
////                            continue;
////                        name = annotation.Name();
////                    }
////                    if (name == null || name=="")
////                        name = f.getName();
////                    fieldNames.put(name, f);
////                }
////            }
////            for (Method m : methods) {
////                if (m.toString().startsWith("public")){
////                    Property annotation= m.getAnnotation(Property.class);
////                    if (annotation != null && annotation.PropertyType() != Property.PropertyTypeEnum.Get){
////                        Type[] types=m.getGenericParameterTypes();
////                        if (types.length!= 1){
////                            Log.e("toObjects","Property Annotation on wrong method! Method does not have right input parameter.");
////                        }
////                        else{
////                            String name = annotation.Name();
////                            if (name== null || name=="")
////                                name= m.getName();
////                            methodNames.put(name, m);
////                        }
////                    }
////                }
////            }
////
////
////            JSONArray jsonNames = jsonObj.names();
////            List<NameType> availableFieldNames =  new ArrayList<>();
////            List<NameType> availableMethodNames =  new ArrayList<>();
////
////            for (Integer i = 0; i < jsonNames.length(); i++) {
////                String name = jsonNames.get(i).toString();
////                if (fieldNames.containsKey(name)) {
////                    Field f= fieldNames.get(name);
////                    availableFieldNames.add(new NameType(name,f.getGenericType(),f));
////                }
////                if (methodNames.containsKey(name)) {
////                    Method m= methodNames.get(name);
////                    availableMethodNames.add(new NameType(name,m.getParameterTypes()[0],m));
////                }
////            }
////
////            return createObject(jsonObj,availableFieldNames,availableMethodNames, type);
////        }
////        catch (Exception e){
////            e.printStackTrace();
////        }
////        return null;
//    }
//
////    private static <T> T createObject(JSONObject obj, List<NameType> fieldNames,List<NameType> methodNames, Class<T> type) {
////        try{
////            if (obj.names().get(0).equals("restroomId") && obj.getDouble("restroomId")== 2) {
////                Log.d("","");
////            }
////            T result= type.newInstance();
////            for (NameType nameType : fieldNames) {
////                Object value=obj.get(nameType.Name);
////                if (value!=null && !value.equals(null)){
////                    nameType.Field.set(result,value);
////                }
////                else {
////                    nameType.Field.set(result,null);
////                }
////
////                //type.getDeclaredField(nameType.Name).set(result,obj.get(nameType.Name));
////            }
////            for (NameType nameType : methodNames) {
////                Object value= obj.get(nameType.Name);
////                value = value.equals(null)?null:value;
////                nameType.Method.invoke(result,value);
////            }
////            return result;
////        }
////        catch (Exception e){
////            e.printStackTrace();
////        }
////        return null;
////    }
////
////
////    private static <T> Field[] getFields(Class<T> type){
////        if (type==null || type.getSuperclass()==null)
////            return null;
////        Field[] f = null;//getFields(type.getSuperclass());
////        if (f!=null)
////            return concatenate(type.getDeclaredFields(), f);
////        return type.getDeclaredFields();
////    }
////    private static <T> Method[] getMethods(Class<T> type){
////        if (type==null || type.getSuperclass()==null)
////            return null;
////        Method[] f = null;//getMethods(type.getSuperclass());
////        if (f!=null)
////            return concatenate(type.getDeclaredMethods(), f);
////        return type.getDeclaredMethods();
////    }
////
////
////    private static <T> T[] concatenate (T[] a, T[] b) {
////        int aLen = a.length;
////        int bLen = b.length;
////
////        @SuppressWarnings("unchecked")
////        T[] c = (T[]) Array.newInstance(a.getClass().getComponentType(), aLen+bLen);
////        System.arraycopy(a, 0, c, 0, aLen);
////        System.arraycopy(b, 0, c, aLen, bLen);
////
////        return c;
////    }
////
//}
////
//// class NameType {
////     public NameType() {}
////     public NameType(String name, Type fieldType) {
////         this.Name = name;
////         this.FieldType = fieldType;
////     }
////
////     public NameType(String name, Type fieldType, Field field) {
////         this.Name = name;
////         this.FieldType = fieldType;
////         this.Field = field;
////     }
////
////     public NameType(String name, Type fieldType, Method method) {
////         this.Name = name;
////         this.FieldType = fieldType;
////         this.Method = method;
////     }
////
////     public String Name;
////     public Type FieldType;
////     public Method Method;
////     public Field Field;
//// }
