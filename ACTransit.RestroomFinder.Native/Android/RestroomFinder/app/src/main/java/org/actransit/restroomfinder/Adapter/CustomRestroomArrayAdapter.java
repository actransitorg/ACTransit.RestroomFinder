package org.actransit.restroomfinder.Adapter;

import android.content.Context;
import androidx.annotation.IntDef;
import androidx.appcompat.content.res.AppCompatResources;

import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

//import com.google.android.gms.vision.text.Text;

import org.actransit.restroomfinder.Infrastructure.ButtonIcon;
import org.actransit.restroomfinder.Infrastructure.Common;
import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Infrastructure.TextViewIcon;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.Model.RestroomViewHolder;
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
    private final List<RestroomViewHolder> views;
    private int selected=-1;
    public CustomRestroomArrayAdapter(Context context,List<RestroomModel> values,@ModeEnum int mode,  onClickListener callBack) {
        super(context, R.layout.customlistrow,values==null?new ArrayList<RestroomModel>(RestroomList):values);
        if (values==null)
            values=new ArrayList<RestroomModel>();
        this.context= context;
        this.values = values;
        this.mode=mode;
        this.callBack= callBack;
        this.views=new ArrayList<RestroomViewHolder>();
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        View rowView = convertView;
        RestroomViewHolder view;
        if(rowView == null)
        {
            // Get a new instance of the row layout view
            LayoutInflater inflater = (LayoutInflater) context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            rowView = inflater.inflate(R.layout.customlistrow, parent, false);


            // Hold the view objects in an object, that way the don't need to be "re-  finded"
            view = new RestroomViewHolder();

            view.row = rowView;
            view.textView = (TextView) rowView.findViewById(R.id.rowtext);
            view.ratingBar= (RatingBar) rowView.findViewById(R.id.ratingBar);
            view.btnFeedback= (ButtonIcon) rowView.findViewById(R.id.imgRowFeedback);
            view.lblDistance= (TextView) rowView.findViewById(R.id.lblDistance);
            view.imgWater= (ImageView) rowView.findViewById(R.id.imgWater);
            view.tviIsHistory= (TextViewIcon) rowView.findViewById(R.id.tviIsHistory);
            view.tviIsToiletAvailable= (TextViewIcon) rowView.findViewById(R.id.tvisToiletAvailable);
            view.lblInspectionPassed= (TextView) rowView.findViewById(R.id.lblInspectionPass);
            view.lblLabelId = (TextView) rowView.findViewById(R.id.lblLabelId);


            this.views.add(view);
            rowView.setTag(view);
        } else {
            view = (RestroomViewHolder) rowView.getTag();
        }

        if (values==null)
            return rowView;

        final RestroomModel value = values.get(position);
        String name = value.restroomName;
        if (!value.approved && Common.waitingApprovalText!="")
            name += " (" + Common.waitingApprovalText + ")";
        view.textView.setText(name);
        view.ratingBar.setRating(Float.parseFloat(value.averageRating().toString()));
        view.lblDistance.setText(value.distanceFromLocation + " mi");
        int visibility=View.INVISIBLE;
        if (value.drinkingWater())
            visibility= View.VISIBLE;


        if (mode==FeedbackList){
            visibility= View.INVISIBLE;
            view.lblDistance.setVisibility(View.GONE);
            view.btnFeedback.setVisibility(View.INVISIBLE);
            view.lblInspectionPassed.setVisibility(View.GONE);
        }
        else {
            view.lblInspectionPassed.setVisibility(View.GONE);
        }

        view.imgWater.setVisibility(visibility);
        view.tviIsHistory.setVisibility(value.isHistory ? View.VISIBLE : View.INVISIBLE);
        view.tviIsToiletAvailable.setVisibility(value.isToiletAvailable ? View.VISIBLE : View.INVISIBLE);
        //view.lblLabelId.setVisibility((value.labelId==null || value.labelId.isEmpty()) ? View.GONE : View.VISIBLE);
        view.lblLabelId.setText(value.labelId);
        view.restroom = value;

        view.btnFeedback.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //v.setTag(value);
                v.setTag(view);
                if (callBack!=null)
                    callBack.onClick(v, true);
            }
        });
        rowView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //v.setTag(value);
                v.setTag(view);
                callBack.onClick(v,false);
            }
        });

        Drawable d=AppCompatResources.getDrawable(MyApplication.getAppContext(), value.isSelected?R.drawable.gradient_background2:R.drawable.gradient_background1);
        rowView.setBackground(d);


        return rowView;
    }

    public interface onClickListener{
        public void onClick(View v, boolean isButton);
    }

    public static final int RestroomList=1;
    public static final int FeedbackList=2;

    @IntDef({RestroomList, FeedbackList})
    public @interface ModeEnum{
//        public static final int RestroomList=1;
//        public static final int FeedbackList=2;
    }

    public void setSelected(int position){
        if (this.selected == position) return;
        if (this.selected!=-1){
            setBackground(this.selected, false);
        }
        setBackground(position, true);
        this.selected = position;
        //notifyDataSetChanged();

    }

//    private void setBackground(int position, int id){
//        RestroomModel model=getItem(position);
//        for (RestroomViewHolder vh:views) {
//            if (vh.restroom.equals(model)){
//                vh.isSelected =
//                Drawable d=AppCompatResources.getDrawable(MyApplication.getAppContext(), id);
//                vh.row.setBackground(d) ;
//                break;
//            }
//        }
//    }

    private void setBackground(int position, boolean selected){
        RestroomModel model=getItem(position);
        model.isSelected=selected;
        Log.d("setBackground", "setSelected: " + selected + " Position:" + position + ", restroomId:" + model.restroomId);
//        for (RestroomViewHolder vh:views) {
//            if (vh.restroom.equals(model)){
//                vh.isSelected =selected;
//                break;
//            }
//        }
    }


}
