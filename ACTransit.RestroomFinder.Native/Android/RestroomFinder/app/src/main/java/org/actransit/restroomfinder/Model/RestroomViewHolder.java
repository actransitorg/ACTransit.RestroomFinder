package org.actransit.restroomfinder.Model;

import android.view.View;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import org.actransit.restroomfinder.Infrastructure.ButtonIcon;
import org.actransit.restroomfinder.Infrastructure.TextViewIcon;

public class RestroomViewHolder {
    public View row;
    public TextView textView;
    public RatingBar ratingBar;
    public ButtonIcon btnFeedback;
    public TextView lblDistance;
    public ImageView imgWater;
    public TextViewIcon tviIsHistory;
    public TextViewIcon tviIsToiletAvailable;
    public TextView lblInspectionPassed;
    public TextView lblLabelId;
    public RestroomModel restroom;
    //public boolean isSelected=false;
}
