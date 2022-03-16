"# Android-Json-Mapper-" 
This is my solution to map any Json to the plain java classes to be used as model.
Please note this library depends on volley:1.0.0
So please make sure to have the line below in you build.gradle.
compile 'com.android.volley:volley:1.0.0'

--------------------------------------------
Ho To Use:

for arrays, assuming response is JSONArray and type is class<T>, you can
List<T> result= JsonMapper.toObjects(response,type);

for object, assuming response is JSONObject and type is class<T>, you can
T result= JsonMapper.toObject(response,type);

To use ServerBaseAPI, create a class and extends ServverBaseAPI. here is a sample:

public class ServerAPI extends ServerBaseAPI{

    Context context;
    ProgressDialog mDialog;

    public ServerAPI(Context context){
        super(MyApp.getAppContext());
        this.context=context;
        this.addServerAPIEventListener(new ServerAPIEventListener() {
            @Override
            public void started(ServerAPIEvent event) {
                if (mDialog==null || !mDialog.isShowing())
                    showWaitDialog();
            }

            @Override
            public void finished(ServerAPIEvent event) {
                if (ServerAPI.this.mDialog!=null && event.numberOfRequests==0)
                    mDialog.dismiss();
            }
        });
    }

    public void getAllModels(ServerResult callBack){
        Get("http://TellExperience.com", MyMainModel.class, callBack);
    }

    public ProgressDialog showWaitDialog(){
        mDialog = new ProgressDialog(context);
        mDialog.setMessage("Please wait...");
        mDialog.setCancelable(false);
        mDialog.show();
        return mDialog;
    }
}
here is how you can use it:

        ServerAPI service=new ServerAPI(this);
        service.getAllModels(new ServerBaseAPI.ServerResult<MyMainModel>() {
            @Override
            public void Always(MyMainModel data, Exception error) {
                Log.d("------------------",data.toString());
            }
        });
		

--------------------------------------------
What Next:

- Error handling. at this moment, I silent the errors. 
- Performance needs to be tested and possibly improved.

--------------------------------------------
Limitations:

This library has issues with arrays. so if you have array in your model, you need to provide the set implementation. for example 

public class Draw{
    public int drawNumber;
    public String drawDate;
    public String closeDate;
    public int jackpotAmount;
    public String[] winningNumbers;
    public String raceTime;
    @PropertyModel(PropertyType = PropertyModel.PropertyTypeEnum.Get)
    public Prize[] prizes;

    @PropertyModel(Name = "prizes",PropertyType = PropertyModel.PropertyTypeEnum.Set)
    public Prize[] setPrizes(Object... values){
        if (values==null) return null;
        prizes=new Prize[values.length];
        for(int i=0;i<values.length;i++){
            prizes[i]=(Prize)values[i];
        }
        return prizes;
    }
}

public class Prize
{
    public String description;
    public Integer amount;
    public int count;
}
