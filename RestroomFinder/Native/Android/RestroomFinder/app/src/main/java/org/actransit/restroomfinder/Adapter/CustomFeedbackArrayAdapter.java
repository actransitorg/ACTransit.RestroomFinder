package org.actransit.restroomfinder.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.RatingBar;
import android.widget.TextView;
import android.widget.Toast;

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
        ImageButton btnFeedback= (ImageButton) rowView.findViewById(R.id.imgRowFeedback);
        //Button btnTest = (Button) rowView.findViewById(R.id.rowbutton);
        final FeedbackModel value = values.get(position);
        textView.setText("Need attention: " + (value.needAttention?"Yes":"No") + "\r\n" +  value.feedbackText);
        ratingBar.setRating(Float.parseFloat(value.rate.toString()));
        TextView lblDistance= (TextView) rowView.findViewById(R.id.lblDistance);
        lblDistance.setVisibility(View.INVISIBLE);
        btnFeedback.setVisibility(View.INVISIBLE);


        return rowView;
    }

}
