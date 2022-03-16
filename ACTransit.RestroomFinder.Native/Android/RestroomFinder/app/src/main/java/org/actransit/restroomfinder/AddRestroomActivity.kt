package org.actransit.restroomfinder

//import android.support.v7.app.AppCompatActivity
import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.view.MotionEvent
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.*
import com.android.volley.VolleyError
import com.google.android.gms.maps.model.LatLng
import com.tellexperience.jsonhelper.ServerBaseAPI
import kotlinx.android.synthetic.main.activity_add_restroom.*
import org.actransit.restroomfinder.Infrastructure.Common
import org.actransit.restroomfinder.Infrastructure.Constants
import org.actransit.restroomfinder.Infrastructure.MyApplication
import org.actransit.restroomfinder.Model.RestroomModel
import org.actransit.restroomfinder.Model.RestroomParcelable

class AddRestroomActivity : BaseActivity() {
    var restroom: RestroomModel? = null
    var _location : LatLng? = null
    var _address : String? = null
    var _isPublic: Boolean = true
    var _postalCode: Int? = null

    override fun currentActivity(): MyApplication.Activity_Enum {
        return MyApplication.Activity_Enum.ACTIVITY_CURRENT_PAGE_AddRestroom;
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_restroom)
        (findViewById(R.id.addRestroomLayout) as View).setBackground(BaseActivity.Gradients.getColorScala());

        init();

        //var items = arrayOfNulls<String>(2)



    }

    fun btnNext_Clicked(view: View){
        dismissKeyboard()

        var chkPortableWater = findViewById<Switch>(R.id.chkPortableWater)
        var chkHasRestroom = findViewById<Switch>(R.id.chkRestroom)
        var chkRestroomMen = findViewById<Switch>(R.id.chkRestroomMen)
        var chkRestroomWomen = findViewById<Switch>(R.id.chkRestroomWomen)
        var chkRestroomNeutral = findViewById<Switch>(R.id.chkRestroomNeutral )


        var hasWater = chkPortableWater.isChecked()
        var txtName = findViewById<EditText>(R.id.txtName);
        var txtWeekdayHours = findViewById<EditText>(R.id.txtWeekdayHours);
        var txtSaturdayHours = findViewById<EditText>(R.id.txtSaturdayHours);
        var txtSundayHours = findViewById<EditText>(R.id.txtSundayHours);
        var txtNote = findViewById<EditText>(R.id.txtNote);
        var spnType = findViewById<Spinner>(R.id.spnType);


        if (this.restroom==null) {
            this.restroom = RestroomModel()
            this.restroom!!.isToiletAvailable = true
        }
        this.restroom!!.latitude = _location?.latitude
        this.restroom!!.longtitude = _location?.longitude
        this.restroom!!.drinkingWater(hasWater)
        this.restroom!!.restroomName = txtName.text.toString()
        this.restroom!!.labelId = txtLabelId.text.toString()
        this.restroom!!.restroomType = spnType.getSelectedItem()?.toString();
        this.restroom!!.address = lblAddressContent.text.toString()
        this.restroom!!.weekdayHours = txtWeekdayHours.text.toString()
        this.restroom!!.saturdayHours = txtSaturdayHours.text.toString()
        this.restroom!!.sundayHours = txtSundayHours.text.toString()
        this.restroom!!.isToiletAvailable = chkHasRestroom.isChecked();
        this.restroom!!.contactName=txtContactName.text.toString();
        this.restroom!!.contactTitle=txtTitle.text.toString();
        this.restroom!!.contactPhone=txtPhone.text.toString();
        this.restroom!!.contactEmail=txtEmail.text.toString();
        this.restroom!!.serviceProvider=txtServiceProvider.text.toString();
        this.restroom!!.note = txtNote.text.toString()
        this.restroom!!.isPublic = this._isPublic
        this.restroom!!.zip = this._postalCode
        if (chkHasRestroom.isChecked()){
            var id:Int=0;
            if ( chkRestroomMen.isChecked()) id=1;
            if ( chkRestroomWomen.isChecked()) id+=2;
            if ( chkRestroomNeutral.isChecked()) id+=4;
            this.restroom!!.toiletGenderId = id;
        }
        else
            this.restroom!!.toiletGenderId=0;

        this.restroom!!.addressChanged = (_address != this.restroom!!.address);

        //if (feedback.feedbackText.equals("") && feedback.rating<3){
        if (this.restroom!!.serviceProvider == "") {
            Toast(Constants.Messages.restroomEmptyServiceProviderSubmit, 1000)
            return
        }
        if (this.restroom!!.restroomName == "") {
            Toast(Constants.Messages.restroomEmptyLocationNameSubmit, 1000)
            return
        }
        if (this.restroom!!.contactName == "") {
            Toast(Constants.Messages.restroomEmptyContactNameSubmit, 1000)
            return
        }
        showWait();
        Server.saveRestroom(restroom, object : ServerBaseAPI.ServerResult<Any> {
            override fun Always(data: Any?, error: Exception?) {
                hideWait()
                if (error==null){
                    val parent = parent
                    if (parent == null) {
                        setResult(Activity.RESULT_OK, null)
                        sendGoogleEvent("saveRestroom, Lat:" + _location?.latitude + ", long: " + _location?.longitude + ", address:" + _address);
                        finish()
                    } else {
                        parent.setResult(Activity.RESULT_OK, null)
                        sendGoogleEvent("saveRestroom, Lat:" + _location?.latitude + ", long: " + _location?.longitude + ", address:" + _address);
                        finish()
                    }
                }
                else if (error!=null && error is VolleyError)
                    Alert("Error", Server.parseVolleyError(error as VolleyError));
                else
                    Alert("Error", "Something went wrong. Please try again later.");

            }
//            override fun Always(data: Any, error:Exception?) {
////                progressBar.setVisibility(ProgressBar.GONE)
////                if (data!=null && data.value)
////                    Toast( "Security code sent to the provided number",2000);
////                else if (error!=null && error is VolleyError)
////                    Alert("Error", Server.parseVolleyError(error as VolleyError));
////                else
////                    Alert("Error", "Something went wrong. Please try again later.");
//            }
        });

    }
    fun btnCancel_Clicked(view: View){
        dismissKeyboard()
        finish()
    }

    override fun onBackPressed() {
        return;
    }
    override fun dispatchTouchEvent(ev: MotionEvent): Boolean {
        dismissKeyboard()
        return super.dispatchTouchEvent(ev)
    }

    private fun init(){
        val activity = intent
        val r: RestroomParcelable? = if (activity.hasExtra(SharedExtras.Restroom)) activity.getParcelableExtra(SharedExtras.Restroom) else null
        if (r!=null) this.restroom = r!!.value else this.restroom = null
        if (this.restroom != null){
            showWait()
            Server.getRestroom(this.restroom!!.restroomId, ServerBaseAPI.ServerResult { restroom: RestroomModel, error ->
                hideWait();
                if (error==null && restroom!=null){
                    setVariables(restroom)
                }
                else if (restroom==null && error==null)
                    Alert("Error", "No Restroom found. Restroom might have been removed. Please refresh the list and try again.");
                else if (error!=null && error is VolleyError)
                    Alert("Error", Server.parseVolleyError(error as VolleyError));
                else
                    Alert("Error", "Something went wrong. Please try again later.");
            })
        }
    }
    private fun setVariables(restroom:RestroomModel){
        val activity = intent
        enableRestroomCheckboxes(false);
        chkRestroom.setOnCheckedChangeListener { compoundButton, b ->
            enableRestroomCheckboxes(b);
        };
        var items = arrayOf("Paid","UnPaid", "Bart","ACT")
        val adapter = ArrayAdapter<String>(this, R.layout.support_simple_spinner_dropdown_item, items)
        spnType.setAdapter(adapter)

        if (restroom != null){
            lblAddRestroom.setText("Edit Restroom");

            _location = LatLng(restroom!!.latitude, restroom!!.longtitude)
            _address = restroom!!.address
            _isPublic = restroom!!.isPublic
            _postalCode = restroom!!.zip

            txtServiceProvider.setText(restroom!!.serviceProvider);
            txtName.setText(restroom!!.restroomName);
            txtLabelId.setText(restroom!!.labelId);

            var typeIndex=1;
            if (restroom!!.restroomType.equals("PAID",true))
                typeIndex=0;
            else if (restroom!!.restroomType.equals("BART",true))
            else if (restroom!!.restroomType.equals("ACT",true))
                typeIndex=3;
            spnType.setSelection(typeIndex);

            txtWeekdayHours.setText(restroom!!.weekdayHours);
            txtSaturdayHours.setText(restroom!!.saturdayHours);
            txtSundayHours.setText(restroom!!.sundayHours);
            chkPortableWater.isChecked = restroom!!.drinkingWater()
            txtNote.setText(restroom!!.note);

            txtContactName.setText(restroom!!.contactName);
            txtTitle.setText(restroom!!.contactTitle);
            txtPhone.setText(restroom!!.contactPhone);
            txtEmail.setText(restroom!!.contactEmail);

            chkRestroom.isChecked=restroom!!.isToiletAvailable
            enableRestroomCheckboxes(chkRestroom.isChecked);
            if (chkRestroom.isChecked && restroom!!.toiletGenderId != null){
                var id:Int = restroom!!.toiletGenderId;
                chkRestroomMen.isChecked = (id and 1) == 1
                chkRestroomWomen.isChecked = (id and 2) == 2
                chkRestroomNeutral.isChecked = (id and 4) == 4
            }


            lltWarning.visibility =  if (restroom!!.isHistory) View.VISIBLE else View.INVISIBLE

            txtLatitude.setText(_location?.latitude.toString());
            txtLongitude.setText(_location?.longitude.toString());
            lblAddressContent.setText(_address);

        }
        else {
            lblAddRestroom.setText("Suggest a Restroom");

            _location = activity.getParcelableExtra<LatLng>(SharedExtras.Location)
            _address = activity.getStringExtra(SharedExtras.Address)
            _isPublic = activity.getBooleanExtra(SharedExtras.Public,true)
            try{
                _postalCode = activity.getStringExtra(SharedExtras.PostalCode).toInt();
            }
            catch(e: NumberFormatException){
                _postalCode = null
            }
            catch(e: IllegalArgumentException){
                _postalCode = null
            }
            catch(e:java.lang.Exception){
                _postalCode = null
            }

            if (!Common.Loggedin || !Common.canAddRestroom) _isPublic=true;

            lltWarning.visibility = View.INVISIBLE

            txtLatitude.setText(_location?.latitude.toString());
            txtLongitude.setText(_location?.longitude.toString());
            lblAddressContent.setText(_address);

        }

        if (_isPublic){
            spnType.visibility= View.GONE
            lblType.visibility = View.GONE
        }else{
            spnType.visibility= View.VISIBLE
            lblType.visibility = View.VISIBLE
        }
    }
//    private fun setVariables() {
//        val activity = intent
//
//        val r: RestroomParcelable? = if (activity.hasExtra(SharedExtras.Restroom)) activity.getParcelableExtra(SharedExtras.Restroom) else null
//        var items = arrayOf("Paid","UnPaid", "Bart")
//        val adapter = ArrayAdapter<String>(this, R.layout.support_simple_spinner_dropdown_item, items)
//        spnType.setAdapter(adapter)
//
//        if (r!=null) this.restroom = r!!.value else this.restroom = null
//
//        enableRestroomCheckboxes(false);
//        chkRestroom.setOnCheckedChangeListener { compoundButton, b ->
//            enableRestroomCheckboxes(b);
//        };
//        if (this.restroom != null){
//            lblAddRestroom.setText("Edit Restroom");
//            //progressBar.visibility=View.VISIBLE;
//            showWait()
//            Server.getRestroom(this.restroom!!.restroomId, ServerBaseAPI.ServerResult { restroom:RestroomModel, error ->
//                hideWait();
//                //progressBar.visibility=View.GONE;
//                if (error==null && restroom!=null){
//                    _location = LatLng(restroom!!.latitude, restroom!!.longtitude)
//                    _address = restroom!!.address
//                    _isPublic = restroom!!.isPublic
//                    _postalCode = restroom!!.zip
//
//                    txtServiceProvider.setText(restroom!!.serviceProvider);
//                    txtName.setText(restroom!!.restroomName);
//
//                    var typeIndex=1;
//                    if (restroom!!.restroomType.equals("PAID",true))
//                        typeIndex=0;
//                    else if (restroom!!.restroomType.equals("BART",true))
//                        typeIndex=2;
//                    spnType.setSelection(typeIndex);
//
//                    txtWeekdayHours.setText(restroom!!.weekdayHours);
//                    txtSaturdayHours.setText(restroom!!.saturdayHours);
//                    txtSundayHours.setText(restroom!!.sundayHours);
//                    chkPortableWater.isChecked = restroom!!.drinkingWater()
//                    txtNote.setText(restroom!!.note);
//
//                    txtContactName.setText(restroom!!.contactName);
//                    txtTitle.setText(restroom!!.contactTitle);
//                    txtPhone.setText(restroom!!.contactPhone);
//                    txtEmail.setText(restroom!!.contactEmail);
//
//                    chkRestroom.isChecked=restroom!!.isToiletAvailable
//                    enableRestroomCheckboxes(chkRestroom.isChecked);
//                    if (chkRestroom.isChecked && restroom!!.toiletGenderId != null){
//                        var id:Int = restroom!!.toiletGenderId;
//                        chkRestroomMen.isChecked = (id and 1) == 1
//                        chkRestroomWomen.isChecked = (id and 2) == 2
//                        chkRestroomNeutral.isChecked = (id and 4) == 4
//                    }
//
//
//                    lltWarning.visibility =  if (restroom!!.isHistory) View.VISIBLE else View.INVISIBLE
//
//                    txtLatitude.setText(_location?.latitude.toString());
//                    txtLongitude.setText(_location?.longitude.toString());
//                    lblAddressContent.setText(_address);
//
//                }
//                else if (restroom==null && error==null)
//                    Alert("Error", "No Restroom found. Restroom might have been removed. Please refresh the list and try again.");
//                else if (error!=null && error is VolleyError)
//                    Alert("Error", Server.parseVolleyError(error as VolleyError));
//                else
//                    Alert("Error", "Something went wrong. Please try again later.");
//
//
//
//            })
//
//
//        }
//        else {
//            lblAddRestroom.setText("Suggest a Restroom");
//
//            _location = activity.getParcelableExtra<LatLng>(SharedExtras.Location)
//            _address = activity.getStringExtra(SharedExtras.Address)
//            _isPublic = activity.getBooleanExtra(SharedExtras.Public,true)
//            try{
//                _postalCode = activity.getStringExtra(SharedExtras.PostalCode).toInt();
//            }
//            catch(e: NumberFormatException){
//                _postalCode = null
//            }
//            catch(e: IllegalArgumentException){
//                _postalCode = null
//            }
//            catch(e:java.lang.Exception){
//                _postalCode = null
//            }
//
//            if (!Common.Loggedin || !Common.canAddRestroom) _isPublic=true;
//
//            lltWarning.visibility = View.INVISIBLE
//
//            txtLatitude.setText(_location?.latitude.toString());
//            txtLongitude.setText(_location?.longitude.toString());
//            lblAddressContent.setText(_address);
//
//        }
//
//
//    }



    override fun Toast(message: String?, duration: Int) {
        Toast.makeText(this, message, duration).show()
    }
    private fun enableRestroomCheckboxes(enabled:Boolean){
        chkRestroomMen.isEnabled=enabled;
        chkRestroomWomen.isEnabled=enabled;
        chkRestroomNeutral.isEnabled=enabled;
    }
    private fun dismissKeyboard() {
        val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(txtName.windowToken, 0)
    }
    public companion object SharedExtras {
        var Location = "location"
        var Address = "address"
        var PostalCode = "postalcode"
        var Public = "isPublic"
        var Restroom = "Restroom"
    }
}
