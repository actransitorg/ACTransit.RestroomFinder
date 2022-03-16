package org.actransit.restroomfinder.Model;

/**
 * Created by DevTeam on 6/24/16.
 */
public class FeedbackModel extends BaseModel {
    public long feedbackId = 0;
    public int  restroomId = 0;
    public boolean  needAttention = false;

    public String  feedbackText;
    public Double  rating = 0.0;
    public String badge="";

    public boolean   needCleaning = false;
    public boolean   needSupply = false;
    public boolean   needRepair = false;
    public boolean   closed = false;
    public Boolean   inspectionPassed = null;


    public boolean   getNeedAttention(){
        return needCleaning || needSupply || needRepair;
    }

}
