package org.actransit.restroomfinder.CustomMapDialog;

/**
 * Created by atajadod on 5/23/2016.
 * http://stackoverflow.com/questions/14123243/google-maps-android-api-v2-interactive-infowindow-like-in-original-android-go/15040761#15040761
 */
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.Marker;

import android.content.Context;
import android.graphics.Point;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.actransit.restroomfinder.Infrastructure.MyApplication;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.R;

public class MapWrapperLayout extends RelativeLayout {
    /**
     * Reference to a GoogleMap object
     */
    private GoogleMap map;
    private View infoWindow;
    private IMapCallBack callBack;
    private TextView infoTitle;
    private TextView infoSnippet;
    private ImageButton infoButton;
    private ImageButton imgBtnPaddleHours;
    private ImageView imgWater;
    private RatingBar ratingBar;
    private OnInfoWindowElemTouchListener buttonListener;

    public InfoButtonListener infoButtonListener;


    /**
     * Vertical offset in pixels between the bottom edge of our InfoWindow
     * and the marker position (by default it's bottom edge too).
     * It's a good idea to use custom markers and also the InfoWindow frame,
     * because we probably can't rely on the sizes of the default marker and frame.
     */
    private int bottomOffsetPixels;

    /**
     * A currently selected marker
     */
    private Marker marker;

    /**
     * Our custom view which is returned from either the InfoWindowAdapter.getInfoContents
     * or InfoWindowAdapter.getInfoWindow
     */

    public MapWrapperLayout(Context context) {super(context);}

    public MapWrapperLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public MapWrapperLayout(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }


    /**
     * Must be called before we can route the touch events
     */
    public void init(GoogleMap map, int bottomOffsetPixels, final View infoWindow, final IMapCallBack callBack) {
        this.map = map;
        this.bottomOffsetPixels = bottomOffsetPixels;
        this.infoWindow = infoWindow;
        this.callBack=callBack;
        this.infoTitle = (TextView)infoWindow.findViewById(R.id.txtHeader);
        this.infoSnippet = (TextView)infoWindow.findViewById(R.id.txtDescription);
        this.infoButton = (ImageButton)infoWindow.findViewById(R.id.imgBtnFeedback);
        this.imgBtnPaddleHours = (ImageButton)infoWindow.findViewById(R.id.imgBtnPaddleHours);
        this.ratingBar = (RatingBar) infoWindow.findViewById(R.id.ratingBar);
        this.imgWater = (ImageView) infoWindow.findViewById(R.id.imgWater);
        this.buttonListener = new OnInfoWindowElemTouchListener(infoButton)
        {
            @Override
            protected void onClickConfirmed(View v, Marker marker) {
                if (infoButtonListener!=null)
                    infoButtonListener.onInfoButtonClicked(v, marker);
            }
        };
        this.infoButton.setOnTouchListener(buttonListener);
//
        map.setInfoWindowAdapter(new GoogleMap.InfoWindowAdapter() {
            @Override
            public View getInfoWindow(Marker marker) {
                return null;
            }

            @Override
            public View getInfoContents(Marker marker) {
                // Setting up the infoWindow with current's marker info
                RestroomModel model= callBack.getRestroom(marker);
                infoTitle.setText(marker.getTitle());
                infoSnippet.setText(marker.getSnippet());
                buttonListener.setMarker(marker);
                int waterVisibility=INVISIBLE;
                int paddleHoursVisibility=INVISIBLE;
                if (model!=null){
                    ratingBar.setRating(new Float(model.averageRating()));
                    if (model.drinkingWater())
                        waterVisibility=VISIBLE;
                    if (!model.hours.equals(""))
                        paddleHoursVisibility = VISIBLE;
                }
                imgWater.setVisibility(waterVisibility);
                imgBtnPaddleHours.setVisibility(paddleHoursVisibility);
                ViewGroup.LayoutParams params= imgBtnPaddleHours.getLayoutParams();
                if (paddleHoursVisibility ==  INVISIBLE)
                    params.width=0;
                else
                {
                    params.width= MyApplication.getPixelsFromDp(MyApplication.getAppContext(),40);
                }

                imgBtnPaddleHours.setLayoutParams(params);

                // We must call this to set the current marker and infoWindow references
                // to the MapWrapperLayout
                //setMarkerWithInfoWindow(marker, MapWrapperLayout.this.infoWindow);
                MapWrapperLayout.this.marker = marker;
                return MapWrapperLayout.this.infoWindow;
            }
        });
    }

    /**
     * Best to be called from either the InfoWindowAdapter.getInfoContents
     * or InfoWindowAdapter.getInfoWindow.
     */
//

//    public void setMarkerWithInfoWindow(Marker marker, View infoWindow) {
//        this.marker = marker;
//        this.infoWindow = infoWindow;
//    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        boolean ret = false;
        // Make sure that the infoWindow is shown and we have all the needed references
        if (marker != null && marker.isInfoWindowShown() && map != null && infoWindow != null) {
            // Get a marker position on the screen
            Point point = map.getProjection().toScreenLocation(marker.getPosition());

            // Make a copy of the MotionEvent and adjust it's location
            // so it is relative to the infoWindow left top corner
            MotionEvent copyEv = MotionEvent.obtain(ev);
            copyEv.offsetLocation(
                    -point.x + (infoWindow.getWidth() / 2),
                    -point.y + infoWindow.getHeight() + bottomOffsetPixels);

            // Dispatch the adjusted MotionEvent to the infoWindow
            ret = infoWindow.dispatchTouchEvent(copyEv);
        }
        // If the infoWindow consumed the touch event, then just return true.
        // Otherwise pass this event to the super class and return it's result
        return ret || super.dispatchTouchEvent(ev);
    }
}