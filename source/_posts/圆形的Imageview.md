---
title: 圆形的Imageview
date: 2017-09-22 10:31:57
tags:
---
``` Java
/** 圆形的Imageview　*/
public class CircleImageView extends ImageView {
    private Paint paint = new Paint();

    public CircleImageView(Context context) {
        super(context);
    }

    public CircleImageView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CircleImageView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        Drawable drawable = getDrawable();
        if (null != drawable) {
            Bitmap bitmap1 = ((BitmapDrawable) drawable).getBitmap();
            Matrix matrix = new Matrix();
            float x = (float)100/bitmap1.getWidth();
            float y = (float)100/bitmap1.getHeight();
            matrix.postScale(x, y);
            Bitmap bitmap = Bitmap.createBitmap(bitmap1, 0, 0, bitmap1.getWidth(), bitmap1.getHeight(), matrix, true);
            Bitmap b = toRoundCorner(bitmap, 14);
            final Rect rect = new Rect(0, 0, b.getWidth(),  b.getHeight());
            paint.reset();
            canvas.drawBitmap(b, rect, rect, paint);
        } else {
            super.onDraw(canvas);
        }
    }

    private Bitmap toRoundCorner(Bitmap bitmap, int pixels) {
        Bitmap output = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Config.ARGB_8888);
        Canvas canvas = new Canvas(output);
        final int color = 0xff424242;
        final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
        paint.setAntiAlias(true);
        canvas.drawARGB(0, 0, 0, 0);
        paint.setColor(color);
        int x = bitmap.getWidth();
        canvas.drawCircle(x / 2, x / 2, x / 2, paint);
        paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
        canvas.drawBitmap(bitmap, rect, rect, paint);
        return output;
    }
}
```
