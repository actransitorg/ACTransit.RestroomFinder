package org.actransit.restroomfinder.Model;

import android.os.Parcelable;

import java.lang.reflect.Field;
import java.util.HashMap;
import android.os.Parcel;
import java.lang.reflect.Type;
import java.util.ArrayList;


/**
 * Created by DevTeam on 6/15/16.
 */
public abstract class CustomParcelable<T> implements Parcelable {
    private Class<T> classType;
    public T value;

    protected CustomParcelable(Class<T> type, T value) {
        super();
        this.classType= type;//(Class<T>)((ParameterizedType)(new ArrayList<T>()).getClass().getGenericSuperclass()).getActualTypeArguments()[0].getClass();
        this.value = value;
    }
    protected CustomParcelable(Class<T> type, T value, Parcel in) {
        this(type, value);
        read(in);
    }

    @Override
    public int describeContents() {
        // TODO Auto-generated method stub
        return 0;
    }
    @Override
    public void writeToParcel(Parcel dest, int flags) {
        // TODO Auto-generated method stub
        Field[] fields = classType.getDeclaredFields();
        for (Field f : fields) {
            if (f.toString().startsWith("public")){
                write(f, dest);
            }
        }
    }


    private void read(Parcel in){
        Field[] fields = classType.getDeclaredFields();
        try{
            for(int i=0;i<fields.length;i++){
                String name = in.readString();
                Object v=in.readValue(null);
                for (Field f : fields) {
                    int mod=f.getModifiers();
                    if((mod & java.lang.reflect.Modifier.FINAL) != java.lang.reflect.Modifier.FINAL &&
                            java.lang.reflect.Modifier.isPublic(mod) && f.getName().equals(name))
                    {
                        Type t=f.getGenericType().getClass();
                        f.set(value, v);
                        break;
                        //this is final field
                    }
                }
            }

//            for (Field f : fields) {
//                String name = in.readString();
//                Object v=in.readValue(null);
//                if (f.toString().startsWith("public") && f.getName().equals(name)){
//                    Type t=f.getGenericType().getClass();
//                    f.set(value, v);
//                }
//            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    private void write(Field f, Parcel dest){
        String name = f.getName();
        dest.writeString(name);
        Type t=f.getType();
        try{
            dest.writeValue(f.get(value));
//            if (t == String.class)
//                dest.writeString(f.get(value).toString());
//            else if ( t== Integer.class)
//                dest.writeInt(f.getInt(value));
//            else if (t == Integer[].class)
//                dest.writeIntArray((int[])f.get(value));
//            else if (t == long.class)
//                dest.writeLong(f.getLong(value));
//            else if (t == long[].class)
//                dest.writeLongArray((long[])f.get(value));
//            else if (t == Boolean[].class)
//                dest.writeBooleanArray((boolean[])f.get(value));
//            else if (t == Byte.class)
//                dest.writeByte(f.getByte(value));
//            else if (t == Byte[].class)
//                dest.writeByteArray((byte[]) f.get(value));
//            else if (t == Double.class)
//                dest.writeDouble(f.getDouble(value));
//            else if (t == Double[].class)
//                dest.writeDoubleArray((double[])f.get(value));
//            else if (t == Float.class)
//                dest.writeFloat(f.getFloat(value));
//            else if (t == Float[].class)
//                dest.writeFloatArray((float[])f.get(value));

        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

}
