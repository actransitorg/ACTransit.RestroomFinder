package org.actransit.restroomfinder.Model;

/**
 * Created by DevTeam on 6/24/16.
 */
public class FeedbackModel extends BaseModel {
    public long feedbackID = 0;
    public int  restroomId = 0;
    public boolean  needAttention = false;
    public String  feedbackText;
    public Double  rate = 0.0;
    public String badge="";
}
