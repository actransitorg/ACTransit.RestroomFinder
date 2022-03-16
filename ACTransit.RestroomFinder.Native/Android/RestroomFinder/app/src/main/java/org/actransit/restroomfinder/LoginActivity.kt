package org.actransit.restroomfinder

import android.content.Context
import android.opengl.Visibility
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.SystemClock
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import android.widget.ProgressBar
import android.widget.TextView
import com.android.volley.VolleyError
import com.google.android.play.core.appupdate.AppUpdateInfo
import com.tellexperience.jsonhelper.ServerBaseAPI
import kotlinx.android.synthetic.main.activity_login.*
import org.actransit.restroomfinder.Infrastructure.*
import org.actransit.restroomfinder.Model.AuthenticationModel
import org.actransit.restroomfinder.Model.BoolModel
import org.actransit.restroomfinder.Model.VersionModel
import org.w3c.dom.Text
import java.lang.Exception
import kotlin.system.exitProcess

public class LoginActivity : BaseActivity() {
    var textChangedByProgram: Boolean = false;
    var enableSendButtonAt  : Long =0;

    override fun currentActivity(): MyApplication.Activity_Enum {
        return MyApplication.Activity_Enum.ACTIVITY_CURRENT_PAGE_Login;
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        (findViewById(R.id.loginLayout) as View).setBackground(BaseActivity.Gradients.getColorScala());
        //var t= findViewById<EditText>(R.id.txtPhone)

        txtPhone.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(p0: Editable?) {
                textChangedByProgram = false;
            }
            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if (textChangedByProgram) return;
                textChangedByProgram = true;
                var txt=txtPhone.text.toString();
                var formated=formattedNumber(txt);
                txtPhone.setText(formated);
                txtPhone.setSelection(formated.length,formated.length)
            }
        })

    }

    override fun CheckForUpdateDone(available: Boolean, appUpdateInfo: AppUpdateInfo?) {
        super.CheckForUpdateDone(available, appUpdateInfo)
        if (available)
            startUpdate(this, appUpdateInfo)
    }

    override fun onBackPressed() {
        return;
    }

    fun btnGetSecurityCode_Clicked(view: View){
        var firstName = txtFirstName.text.toString()
        var lastName = txtLastName.text.toString()
        var badge = txtBadge.text.toString()
        var phone = txtPhone.text.toString()

        dismissKeyboard();
        if (!validate())
            return;
        showWait()

        Server.sendSecurityCode(firstName, lastName,badge,phone, object : ServerBaseAPI.ServerResult<BoolModel?> {
            override fun Always(data: BoolModel?, error:Exception?) {
                hideWait()

                if (data!=null && data.value){
                    btnGetSecurityCode.setEnabled(false);
                    enableSendButtonAt = SystemClock.uptimeMillis() + (5000 * 60);
                    Toast( "Security code sent to the provided number",5000);
                }
                else if (error!=null && error is VolleyError)
                    Alert("Error", Server.parseVolleyError(error as VolleyError));
                else
                    Alert("Error", "Something went wrong. Please try again later.");
            }
        });



    }
    fun btnNext_Clicked(view: View){
        var firstName = txtFirstName.text.toString()
        var lastName = txtLastName.text.toString()
        var badge = txtBadge.text.toString()
        var phone = txtPhone.text.toString()
        var securityCode = txtSecurityCode.text.toString()

        if (!validate())
            return;

        showWait()
        Server.validateSecurityCode(firstName, lastName,badge,phone, securityCode, object : ServerBaseAPI.ServerResult<AuthenticationModel?> {
            override fun Always(data: AuthenticationModel?, error:Exception?) {
                hideWait()
                if (data!=null && data.sessionApproved)
                {
                    AppStorage.Current(this@LoginActivity).setCurrentLoginInformation(firstName,lastName,badge, phone,data.deviceSessionId);
                    Common.canAddRestroom=data.canAddRestroom
                    Common.canEditRestroom=data.canEditRestroom
                    Common.Loggedin = true;
                    MyApplication.NavigateTo(DisclaimerActivity::class.java)
                }
                else if (error!=null && error is VolleyError)
                    Alert("Error", Server.parseVolleyError(error as VolleyError));
                else
                    Alert("Error", "Something went wrong. Please try again later.");
            }
        });

    }

    override fun onEverySecond() {
        this@LoginActivity.runOnUiThread(Runnable {
            if (btnGetSecurityCode!=null && enableSendButtonAt>0) {
                if (!btnGetSecurityCode.isEnabled() && enableSendButtonAt<SystemClock.uptimeMillis()){
                    enableSendButtonAt=0;
                    btnGetSecurityCode.setEnabled(true);
                    btnGetSecurityCode.setText(R.string.get_security_code_by_sms);

                }
                else {
                    var timeLeft=(enableSendButtonAt - SystemClock.uptimeMillis())/60000;
                    var secondsLeft = timeLeft.toInt() + 1;
                    btnGetSecurityCode.setText("Send again in " + secondsLeft + " Min");
                }
            }

            var lblErr= findViewById<TextView>(R.id.lblError);
            if (lblErr!=null){

                val connected = NetworkUtil.isNetworkAvailable(applicationContext)
                lblErr.text = "";
                if (!connected)
                    lblErr.text = "No internet connection";
            }

        })



    }

    fun btnCancel_Clicked(view: View){
        if (!Constants.PublicViewEnabled){
            finishAffinity()
            return;
        }
        MyApplication.NavigateTo(MapviewActivity::class.java)
    }
    override fun dispatchTouchEvent(ev: MotionEvent): Boolean {
        dismissKeyboard()
        return super.dispatchTouchEvent(ev)
    }

    override fun onTouchEvent(event: MotionEvent): Boolean {
        dismissKeyboard()
        return super.onTouchEvent(event)
    }
    private fun dismissKeyboard() {
        val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(txtBadge.windowToken, 0)
    }

    fun validate():Boolean{
        var firstName = txtFirstName.text.toString()
        var lastName = txtLastName.text.toString()
        var badge = txtBadge.text.toString()
        var phone = txtPhone.text.toString()
        if (firstName==""){
            txtFirstName.requestFocus();
            txtFirstName.setError("First name is required.");
            return false;
        }
        if (lastName==""){
            txtLastName.requestFocus();
            txtLastName.setError("Last name is required.");
            return false;
        }
        if (badge==""){
            txtBadge.requestFocus();
            txtBadge.setError("Badge is required.");
            return false;
        }
        if (phone=="" || phone.length!=15){
            txtPhone.requestFocus();
            txtPhone.setError("Phone number is required.");
            return false;
        }
        return true;

    }

    fun formattedNumber(number: String):String  {
        var cleanPhoneNumber = number.replace("+","").replace("(","").replace(")","").replace(" " ,"").replace("-","");
        var mask = "+1(XXX)XXX-XXXX"

        var result = ""
        var index = 0
        for(ch in mask){
            if (index >= cleanPhoneNumber.length) break;
            if (ch == 'X') {
                result += cleanPhoneNumber[index]
                index +=1
            } else {
                if (ch ==cleanPhoneNumber[index]){
                    index +=1
                }
                result +=ch;
            }
        }

        return result
    }
}
