package org.actransit.restroomfinder.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;
import android.widget.Toast;

import org.actransit.restroomfinder.Infrastructure.ButtonIcon;
import org.actransit.restroomfinder.Infrastructure.TextViewIcon;
import org.actransit.restroomfinder.Model.FeedbackModel;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.R;

import java.util.List;

/**
 * Created by DevTeam on 6/24/16.
 */
public class CustomFeedbackArrayAdapter extends ArrayAdapter<FeedbackModel> {
    private final Context context;
    private final List<FeedbackModel> values;
    public CustomFeedbackArrayAdapter(Context context,List<FeedbackModel> values) {
        super(context, R.layout.customlistrow,values);
        this.context= context;
        this.values = values;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View rowView = inflater.inflate(R.layout.customlistrow, parent, false);
        TextView textView = (TextView) rowView.findViewById(R.id.rowtext);
        RatingBar ratingBar= (RatingBar) rowView.findViewById(R.id.ratingBar);
        ButtonIcon btnFeedback= (ButtonIcon) rowView.findViewById(R.id.imgRowFeedback);
        TextView lblInspectionPassed= (TextView) rowView.findViewById(R.id.lblInspectionPass);
        TextViewIcon tvisToiletAvailable= (TextViewIcon) rowView.findViewById(R.id.tvisToiletAvailable);
        //Button btnTest = (Button) rowView.findViewById(R.id.rowbutton);
        final FeedbackModel value = values.get(position);
        String note="Need attention: " + (value.getNeedAttention()?"Yes":"No");
        if (value.feedbackText!=null && !value.feedbackText.equals("")){
            note = note + "\r\nNote:" +  value.feedbackText;
        }
        textView.setText(note);
        Double rating = value.rating;
        if (rating==null) rating=0.0;
        ratingBar.setRating(Float.parseFloat(rating.toString()));
        TextView lblDistance= (TextView) rowView.findViewById(R.id.lblDistance);
        lblDistance.setVisibility(View.GONE);
        tvisToiletAvailable.setVisibility(View.GONE);
        btnFeedback.setVisibility(View.GONE);



        if (value.inspectionPassed!=null){
            lblInspectionPassed.setVisibility(View.VISIBLE);
            String txt=value.inspectionPassed==true?"Inspection Passed ":"Inspection Failed ";
            lblInspectionPassed.setText(txt);
        }
        else {
            lblInspectionPassed.setVisibility(View.GONE);
        }
        ImageView img= (ImageView) rowView.findViewById(R.id.imgWater);
        img.setVisibility(View.GONE);

        TextViewIcon tviHistory= (TextViewIcon) rowView.findViewById(R.id.tviIsHistory);
        tviHistory.setVisibility(View.GONE);

        return rowView;
    }

}
