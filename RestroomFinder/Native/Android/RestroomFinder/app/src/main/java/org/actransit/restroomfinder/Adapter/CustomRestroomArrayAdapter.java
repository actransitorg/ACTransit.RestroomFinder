package org.actransit.restroomfinder.Adapter;

import android.content.Context;
import android.support.annotation.IntDef;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.vision.text.Text;

import org.actransit.restroomfinder.MapviewActivity;
import org.actransit.restroomfinder.Model.CustomListDataRow;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by atajadod on 5/16/2016.
 */
public class CustomRestroomArrayAdapter extends ArrayAdapter<RestroomModel>  {
    private final Context context;
    private final List<RestroomModel> values;
    private final onClickListener callBack;
    private final int mode;
    public CustomRestroomArrayAdapter(Context context,List<RestroomModel> values,@ModeEnum int mode,  onClickListener callBack) {
        super(context, R.layout.customlistrow,values==null?new ArrayList<RestroomModel>(RestroolList):values);
        if (values==null)
            values=new ArrayList<RestroomModel>();
        this.context= context;
        this.values = values;
        this.mode=mode;
        this.callBack= callBack;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        final View rowView = inflater.inflate(R.layout.customlistrow, parent, false);
        if (values==null)
            return rowView;

        TextView textView = (TextView) rowView.findViewById(R.id.rowtext);
        RatingBar ratingBar= (RatingBar) rowView.findViewById(R.id.ratingBar);
        ImageButton btnFeedback= (ImageButton) rowView.findViewById(R.id.imgRowFeedback);
        TextView lblDistance= (TextView) rowView.findViewById(R.id.lblDistance);
        ImageView imgWater= (ImageView) rowView.findViewById(R.id.imgWater);
        //Button btnTest = (Button) rowView.findViewById(R.id.rowbutton);
        final RestroomModel value = values.get(position);
        textView.setText(value.restroomName);
        ratingBar.setRating(Float.parseFloat(value.averageRating().toString()));
        lblDistance.setText(value.distanceFromLocation + " mi");
        int visibility=View.INVISIBLE;
        if (value.drinkingWater())
            visibility= View.VISIBLE;

        if (mode==FeedbackList){
            visibility= View.INVISIBLE;
            lblDistance.setVisibility(View.INVISIBLE);
            btnFeedback.setVisibility(View.INVISIBLE);
        }

        imgWater.setVisibility(visibility);

        btnFeedback.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.setTag(value);
                if (callBack!=null)
                    callBack.onClick(v, true);
            }
        });
        rowView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                v.setTag(value);
                callBack.onClick(v,false);
            }
        });

        // Change the icon for Windows and iPhone
//        String s = values[position];
//        if (s.startsWith("Windows7") || s.startsWith("iPhone")
//                || s.startsWith("Solaris")) {
//            imageView.setImageResource(R.drawable.no);
//        } else {
//            imageView.setImageResource(R.drawable.ok);
//        }

        return rowView;
    }

    public interface onClickListener{
        public void onClick(View v, boolean isButton);
    }

    public static final int RestroolList=1;
    public static final int FeedbackList=2;

    @IntDef({RestroolList, FeedbackList})
    public @interface ModeEnum{
//        public static final int RestroolList=1;
//        public static final int FeedbackList=2;
    }
}
