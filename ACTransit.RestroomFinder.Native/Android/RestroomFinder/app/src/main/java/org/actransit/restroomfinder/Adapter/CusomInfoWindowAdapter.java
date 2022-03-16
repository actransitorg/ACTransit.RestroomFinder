package org.actransit.restroomfinder.Adapter;

import android.view.View;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.Marker;
import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import com.google.android.gms.maps.GoogleMap.InfoWindowAdapter;
import com.google.android.gms.maps.model.Marker;
import org.actransit.restroomfinder.R;

/**
 * Created by atajadod on 5/20/2016.
 */
public class CusomInfoWindowAdapter implements  GoogleMap.InfoWindowAdapter {
    private View popup=null;
    private LayoutInflater inflater=null;

    public String description;

    public CusomInfoWindowAdapter(LayoutInflater inflater) {
        this.inflater=inflater;
    }

    @Override
    public View getInfoWindow(Marker marker) {
        return(null);
    }

    @SuppressLint("InflateParams")
    @Override
    public View getInfoContents(Marker marker) {
        if (popup == null) {
            popup=inflater.inflate(R.layout.cusominfowindow, null);
        }

        TextView header=(TextView)popup.findViewById(R.id.txtHeader);
        TextView description=(TextView)popup.findViewById(R.id.txtDescription);
        header.setText(marker.getTitle());
        description.setText(marker.getSnippet());
//        TextView tv=(TextView)popup.findViewById(R.id.title);
//
//        tv.setText(marker.getTitle());
//        tv=(TextView)popup.findViewById(R.id.snippet);
//        tv.setText(marker.getSnippet());

        return(popup);
    }
}
