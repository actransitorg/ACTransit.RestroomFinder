package org.actransit.restroomfinder.Infrastructure;

import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.widget.Button;

import org.actransit.restroomfinder.R;

public class ButtonIcon extends Button {

    public enum FontTypeEnum{
        AntDesign(0),
        Entypo(1),
        EvilIcons(2),
        Feather(3),
        FontAwesome(4),
        FontAwesome5_Brands(5),
        FontAwesome5_Regular(6),
        FontAwesome5_Solid(7),
        Foundation(8),
        Ionicons(9),
        MaterialIcons(10),
        MaterialCommunityIcons(11),
        SimpleLineIcons(12),
        Octicons(13),
        Zocial(14);
        private final int value;
        private FontTypeEnum(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }
    private TextViewIcon.FontTypeEnum fontType;

    //public FontTypeEnum getFontType() { return this.fontType; }
    //public void setFontType(FontTypeEnum fontType) { this.fontType = fontType; }

    public ButtonIcon(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context, attrs);
    }

    public ButtonIcon(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }
//
//    public TextViewIcon(Context context) {
//        super(context);
//        init();
//    }

    private void init(Context context, AttributeSet attrs) {
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.IconProps,0,0);
        int ft = ta.getInt(R.styleable.IconProps_fontType,0);
        TextViewIcon.FontTypeEnum[] types= TextViewIcon.FontTypeEnum.values();
        for(int i=0;i<types.length;i++){
            if (types[i].getValue()==ft){
                this.fontType=types[i];
                break;
            }
        }
        ta.recycle();
        //Font name should not contain "/".
        AssetManager assets=getContext().getAssets();
        //String[] assetsLsit=assets.list("FontAwesome.ttf");
        Typeface tf = Typeface.createFromAsset(getContext().getAssets(),
                //"fonts/FontAwesome.ttf");
                "fonts/" + this.fontType.name() + ".ttf");
        setTypeface(tf);
    }
}
