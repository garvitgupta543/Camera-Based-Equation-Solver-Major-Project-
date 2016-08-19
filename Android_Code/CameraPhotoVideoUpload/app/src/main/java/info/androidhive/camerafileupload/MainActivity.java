package info.androidhive.camerafileupload;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class MainActivity extends Activity {

	// LogCat tag



    private Button printed, handwritten;
    int val;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Changing action bar background color
        // These two lines are not needed
 //       getActionBar().setBackgroundDrawable(new ColorDrawable(Color.parseColor(getResources().getString(R.color.action_bar))));



        printed = (Button) findViewById(R.id.solveprinted);
        handwritten = (Button) findViewById(R.id.solvehandwritten);

        /**
         * Capture image button click event
         */
        printed.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // capture picture
                Intent i = new Intent(MainActivity.this, ImageCalculator.class);
                val=0;
                i.putExtra("value",val);
                startActivity(i);

            }
        });

        /**
         * Record video button click event
         */
       handwritten.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // record video
                Intent i = new Intent(MainActivity.this, ImageCalculator.class);
                val=1;
                i.putExtra("value",val);
                startActivity(i);
            }
        });


    }

    /**
     * Checking device has camera hardware or not
     * */

}