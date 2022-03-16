package com.tellexperience.jsonhelper;

import android.util.Log;
import android.util.Pair;

import org.json.JSONArray;
import org.json.JSONObject;

//import java.lang.annotation.Annotation;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
//

/**
 * Created by Aidin on 1/22/2017.
 */

public class JsonMapper {
    public static <T> JSONArray toJSONArray(List<T> obj, Class<T> type){
        JSONArray result=new JSONArray();
        try{
            for (T o:obj) {
                result.put(toJSON(o,type));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return result;
    }
    public static <T> JSONObject toJSON(T obj, Class<T> type){
        JSONObject jSonObj=new JSONObject();
        try{

            Pair<List<NameType>, List<NameType>> availables=getAvailableFieldAndMethodsForGet(type);
            List<NameType> availableFieldNames =  availables.first;
            List<NameType> availableMethodNames =  availables.second;

            for (NameType nt :availableFieldNames){
                jSonObj.put(nt.Name,nt.Field.get(obj));
            }
            for (NameType nt :availableMethodNames){
                jSonObj.put(nt.Name,nt.Method.invoke(obj));
            }

//            Field[] fields = getFields(type);
//            for (Field f : fields) {
//                if (f.toString().startsWith("public")){
//                    //Annotation[] annotation1 = f.getAnnotations();
//                    PropertyModel annotation= f.getAnnotation(PropertyModel.class);
//                    String name = f.getName();
//                    if (annotation!=null )
//                    {
//                        if (annotation.Ignore())
//                            continue;
//                        name = annotation.Name();
//                    }
//                    if (name == null || name=="")
//                        name = f.getName();
//                    jSonObj.put(name,f.get(obj));
//                }
//            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return jSonObj;
    }

    public static <T> List<T> toObjects(JSONArray arrayObj, Class<T> type) {
        try {
            List<T> result = new ArrayList<T>();
            if (arrayObj==null || arrayObj.length()<=0)
                return null;

            String typeName=type.getName();
            switch (typeName){
                case "int":
                case "byte":
                case "long":
                case "short":
                case "string":
                case "java.lang.String":
                    for (Integer i=0;i<arrayObj.length();i++){
                        T obj = (T) arrayObj.get(i);
                        result.add(obj);
                    }
                    break;
                default:
                    Pair<List<NameType>, List<NameType>> availables=getAvailableFieldAndMethodsForSet(arrayObj.getJSONObject(0),type);
                    List<NameType> availableFieldNames =  availables.first;
                    List<NameType> availableMethodNames =  availables.second;

                    for (Integer i=0;i<arrayObj.length();i++){
                        JSONObject obj = arrayObj.getJSONObject(i);
                        result.add(createObject(obj,availableFieldNames,availableMethodNames, type));
                    }
            }
            return result;
        }
        catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    public static <T> T toObject(String objStr, Class<T> type){
        try{
            JSONObject obj=new JSONObject(objStr);
            return toObject(obj, type);
        }
        catch(Exception ex){
            Log.e("toObject from string",ex.getMessage());
            ex.printStackTrace();
            return null;
        }
    }
    public static <T> T toObject(JSONObject jsonObj, Class<T> type) {
        try {
            T result = type.newInstance();
            if (jsonObj==null)
                return null;


            Pair<List<NameType>, List<NameType>> availables=getAvailableFieldAndMethodsForSet(jsonObj,type);
            List<NameType> availableFieldNames =  availables.first;
            List<NameType> availableMethodNames =  availables.second;

            return createObject(jsonObj,availableFieldNames,availableMethodNames, type);
        }
        catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    private static <T> T createObject(JSONObject obj, List<NameType> fieldNames,List<NameType> methodNames, Class<T> type) {
        try{
            T result= type.newInstance();
            for (NameType nameType : fieldNames) {
                Object value=obj.get(nameType.Name);

                if (value instanceof JSONObject){
                    //.contains(MyApp.getAppContext().getPackageName()) &&  nameType.FieldType.getClass().getSuperclass() instanceof Object
                    String className=((Class) nameType.FieldType).getName();
                    Class<?> clazz=Class.forName(className);
                    //nameType.Field.set(result,BaseModl(nameType.FieldType));
                    Object newVal=toObject((JSONObject) value,clazz);
                    nameType.Field.set(result,newVal);
                }
                else if (value instanceof JSONArray){

                    //String className=((Class) nameType.FieldType).getComponentType().getName();
                    Class<?> clazz=((Class) nameType.FieldType).getComponentType();
//                    switch (className){
//                        case "int":
//                            clazz=int.class;
//                            break;
//                        case "byte":
//                            clazz=byte.class;
//                            break;
//                        case "long":
//                            clazz=long.class;
//                            break;
//                        case "short":
//                            clazz=short.class;
//                            break;
//                        default:
//                            clazz=Class.forName(className);
//                    }
                    List<?> newVal=toObjects((JSONArray) value,clazz);
                    Class<?> arrayType=Class.forName(((Class) nameType.FieldType).getName());

                    //nameType.Field.set(result,newVal);
                    setArray(nameType,newVal,result,arrayType,clazz);


//                    nameType=Arrays.copyOf(newVal.toArray(),newVal.size(),clazz[]);
//                    T[] test= (T[])newVal.toArray();
//                    newVal.toArray((T[]) result);

//                    clazz[] test;
//                    newVal.toArray(nameType.Field);

//                    nameType.Field.set(result,Arrays.copyOf(newVal.toArray(),newVal.size(),clazz);
                    //nameType.Field.set(result,(clazz1)newVal.toArray());
                }
                else if (value!=null && !value.equals(null)){
                    nameType.Field.set(result,value);
                }
                else {
                    nameType.Field.set(result,null);
                }

                //type.getDeclaredField(nameType.Name).set(result,obj.get(nameType.Name));
            }
            for (NameType nameType : methodNames) {
                Object value= obj.get(nameType.Name);
                value = value.equals(null)?null:value;

                if (value instanceof JSONObject){
                    String className=nameType.Method.getReturnType().getName();
                    Class<?> clazz=Class.forName(className);
                    Object newVal=toObject((JSONObject) value,clazz);
                    nameType.Method.invoke(result,newVal);
                }
                else if (value instanceof JSONArray){
                    Class<?> clazz=nameType.Method.getReturnType().getComponentType();
                    List<?> newVal=toObjects((JSONArray) value,clazz);
                    Object[] args=null;
                    if (newVal!=null)
                        args=newVal.toArray();
                    nameType.Method.invoke(result,(Object) args);
                }
                else{
                    nameType.Method.invoke(result,value);
                }

            }
            return result;
        }
        catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    private static <T,T1,T2> void setArray(NameType nameType,List<?> array, T container, Class<T1> arrayType, Class<T2> componentType){
        try{
            String typeName=componentType.getName();
            switch (typeName){
                case "int":
                    Integer[] intArray=new Integer[array.size()];
                    //int[] intArray=Arrays.copyOf(array, array.length, int[].class);
                    nameType.Field.set(container,intArray);
                    break;
                case "byte":
                    Byte[] byteArray=new Byte[array.size()];
                    array.toArray(byteArray);

                    //byte[] byteArray=Arrays.copyOf(array.toArray(), array.size(), byte[].class);
                    nameType.Field.set(container,byteArray);
                    break;
                case "long":
                    Long[] longArray=new Long[array.size()];
                    array.toArray(longArray);
                    //long[] longArray=Arrays.copyOf(array.toArray(), array.size(), long[].class);
                    nameType.Field.set(container,longArray);
                    break;
                case "short":
                    Short[] shortArray=new Short[array.size()];
                    array.toArray(shortArray);

                    //short[] shortArray=Arrays.copyOf(array.toArray(), array.size(), short[].class);
                    nameType.Field.set(container,shortArray);
                    break;
                case "string":
                    String[] string1Array=new String[array.size()];
                    array.toArray(string1Array);

                    //string[] string1Array=Arrays.copyOf(array.toArray(), array.size(), int[].class);
                    nameType.Field.set(container,string1Array);
                    break;
                case "java.lang.String":
                    String[] stringArray=new String[array.size()];
                    array.toArray(stringArray);

                    //String[] stringArray=Arrays.copyOf(array.toArray(), array.size(), String[].class);
                    nameType.Field.set(container,stringArray);
                    break;
                default:
                    throw new UnsupportedOperationException("Can not set an array for custom class!");

            }
        }
        catch(Exception e){
            Log.e("------",e.getMessage());
        }
    }
    private static <T> Pair<List<NameType>,List<NameType>> getAvailableFieldAndMethodsForSet(JSONObject jsonObj, Class<T> type) {
        try {
            Field[] fields = getFields(type);
            Method[] methods = getMethods(type);
            //List<NameType> names = new ArrayList<>();
            Hashtable<String, Field> fieldNames = new Hashtable<>();
            Hashtable<String, Method> methodNames = new Hashtable<>();
            for (Field f : fields) {
                if (f.toString().startsWith("public")) {
                    PropertyModel annotation = f.getAnnotation(PropertyModel.class);
                    String name = f.getName();
                    if (annotation != null) {
                        if (annotation.Ignore() || annotation.PropertyType() == PropertyModel.PropertyTypeEnum.Get)
                            continue;
                        name = annotation.Name();
                    }
                    if (name == null || name == "")
                        name = f.getName();
                    fieldNames.put(name, f);
                }
            }
            for (Method m : methods) {
                if (m.toString().startsWith("public")) {
                    PropertyModel annotation = m.getAnnotation(PropertyModel.class);
                    if (annotation != null && annotation.PropertyType() != PropertyModel.PropertyTypeEnum.Get) {
                        Type[] types = m.getGenericParameterTypes();
                        if (types.length != 1) {
                            Log.w("--------", "getAvailableFieldAndMethods: PropertyModel Annotation on wrong method! Method does not have right input parameter.");
                        } else {
                            String name = annotation.Name();
                            if (name == null || name == "")
                                name = m.getName();
                            methodNames.put(name, m);
                        }
                    }
                }
            }


            JSONArray jsonNames = jsonObj.names();
            List<NameType> availableFieldNames = new ArrayList<>();
            List<NameType> availableMethodNames = new ArrayList<>();

            for (Integer i = 0; i < jsonNames.length(); i++) {
                String name = jsonNames.get(i).toString();
                if (fieldNames.containsKey(name)) {
                    Field f = fieldNames.get(name);
                    availableFieldNames.add(new NameType(name, f.getGenericType(), f));
                }
                if (methodNames.containsKey(name)) {
                    Method m = methodNames.get(name);
                    availableMethodNames.add(new NameType(name, m.getParameterTypes()[0], m));
                }
            }

            return new Pair<>(availableFieldNames,availableMethodNames);
        } catch (Exception e) {
            Log.e("--------", "getAvailableFieldAndMethodsForSet:" + e.getMessage());
        }
        return null;
    }
    private static <T> Pair<List<NameType>,List<NameType>> getAvailableFieldAndMethodsForGet(Class<T> type) {
        try {
            Field[] fields = getFields(type);
            Method[] methods = getMethods(type);
            List<NameType> availableFieldNames = new ArrayList<>();
            List<NameType> availableMethodNames = new ArrayList<>();
            for (Field f : fields) {
                if (f.toString().startsWith("public")) {
                    PropertyModel annotation = f.getAnnotation(PropertyModel.class);
                    String name = f.getName();
                    if (annotation != null) {
                        if (annotation.Ignore() || annotation.PropertyType() == PropertyModel.PropertyTypeEnum.Set)
                            continue;
                        name = annotation.Name();
                    }
                    if (name == null || name == "")
                        name = f.getName();
                    availableFieldNames.add(new NameType(name, f.getGenericType(), f));
                }
            }
            for (Method m : methods) {
                if (m.toString().startsWith("public")) {
                    PropertyModel annotation = m.getAnnotation(PropertyModel.class);
                    if (annotation != null && annotation.PropertyType() != PropertyModel.PropertyTypeEnum.Set) {
                        Type[] types = m.getGenericParameterTypes();
                        if (types.length != 1) {
                            Log.w("--------", "getAvailableFieldAndMethods: PropertyModel Annotation on wrong method! Method does not have right input parameter.");
                        } else {
                            String name = annotation.Name();
                            if (name == null || name == "")
                                name = m.getName();
                            availableMethodNames.add(new NameType(name, m.getParameterTypes()[0], m));
                        }
                    }
                }
            }

            return new Pair<>(availableFieldNames,availableMethodNames);
        } catch (Exception e) {
            Log.e("--------", "getAvailableFieldAndMethodsForGet:" + e.getMessage());
        }
        return null;
    }
    private static <T> Field[] getFields(Class<T> type){
        if (type==null)
            return null;
        Field[] f = getFields(type.getSuperclass());
        if (f!=null)
            return concatenate(type.getDeclaredFields(), f);
        return type.getDeclaredFields();
    }
    private static <T> Method[] getMethods(Class<T> type){
        if (type==null || type.getSuperclass()==null)
            return null;
        Method[] f = null;//getMethods(type.getSuperclass());
        if (f!=null)
            return concatenate(type.getDeclaredMethods(), f);
        return type.getDeclaredMethods();
    }


    private static <T> T[] concatenate (T[] a, T[] b) {
        int aLen = a.length;
        int bLen = b.length;

        @SuppressWarnings("unchecked")
        T[] c = (T[]) Array.newInstance(a.getClass().getComponentType(), aLen+bLen);
        System.arraycopy(a, 0, c, 0, aLen);
        System.arraycopy(b, 0, c, aLen, bLen);

        return c;
    }

}

class NameType {
    public NameType() {}
    public NameType(String name, Type fieldType) {
        this.Name = name;
        this.FieldType = fieldType;
    }

    public NameType(String name, Type fieldType, Field field) {
        this.Name = name;
        this.FieldType = fieldType;
        this.Field = field;
    }

    public NameType(String name, Type fieldType, Method method) {
        this.Name = name;
        this.FieldType = fieldType;
        this.Method = method;
    }

    public String Name;
    public Type FieldType;
    public Method Method;
    public Field Field;
}
