package org.actransit.restroomfinder.Infrastructure;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ListView;

import androidx.annotation.Nullable;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.model.Marker;

import org.actransit.restroomfinder.Adapter.CustomRestroomArrayAdapter;
import org.actransit.restroomfinder.MapviewActivity;
import org.actransit.restroomfinder.Model.RestroomModel;
import org.actransit.restroomfinder.R;

import java.util.List;
import java.util.Map;

public class CustomListView extends ListView {
    private CustomRestroomArrayAdapter dataSource;


    public CustomListView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context, attrs);
    }

    public CustomListView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }


    private void init(Context context, AttributeSet attrs) {

    }

    public CustomRestroomArrayAdapter getDataSource() {return this.dataSource;}
    public void setDataSource(CustomRestroomArrayAdapter dataSource) {
        this.dataSource=dataSource;
        this.setAdapter(dataSource);
    }

    @Override
    public void setOnItemClickListener(@Nullable OnItemClickListener listener) {
        super.setOnItemClickListener(listener);
    }

    public void setSelection(int position, boolean moveToSelected) {
        //Integer oldIndex=getSelectedItemPosition();
        dataSource.setSelected(position);
        dataSource.notifyDataSetChanged();
        if (moveToSelected){
            super.setSelection(position);
        }

        //this.dataSource.notifyDataSetChanged();
        //this.deferNotifyDataSetChanged();
    }



    //    @Override
//    public void onListItemClick(ListView l, View v, int position, long id) {
//        if (currentSelectedView != null && currentSelectedView != v) {
//            unhighlightCurrentRow(currentSelectedView);
//        }
//
//        currentSelectedView = v;
//        highlightCurrentRow(currentSelectedView);
//        //other codes
//    }
}
