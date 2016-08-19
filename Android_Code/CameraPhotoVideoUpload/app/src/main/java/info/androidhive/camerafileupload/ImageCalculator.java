package info.androidhive.camerafileupload;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.googlecode.tesseract.android.TessBaseAPI;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class ImageCalculator extends ActionBarActivity {


    private static final String TAG = MainActivity.class.getSimpleName();

    long totalSize = 0;
    // Camera activity request codes
    private static final int CAMERA_CAPTURE_IMAGE_REQUEST_CODE = 100;
    private static final int CAMERA_CAPTURE_VIDEO_REQUEST_CODE = 200;

    public static final int MEDIA_TYPE_IMAGE = 1;
    public static final int MEDIA_TYPE_VIDEO = 2;

    protected boolean _taken;
    public static final String lang = "eng";
    protected EditText _field;
    String recognizedText = "";

    private Uri fileUri; // file url to store image/video
    private Uri outputFileUri;
    protected String _path;
    Bitmap thePic,bitmap,undo;
    public static final String DATA_PATH = Environment
            .getExternalStorageDirectory().toString() + "/cameracalculator/";

    String finalpath;
    private ProgressBar progressBar;

    private Button SelectImage, EnhanceImage,Calculate,OCR;

    ImageView imViewAndroid;

    int val;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        progressBar = (ProgressBar) findViewById(R.id.progressBar);

        //txtPercentage = (TextView) findViewById(R.id.txtPercentage);

        // Changing action bar background color
        // These two lines are not needed
        //       getActionBar().setBackgroundDrawable(new ColorDrawable(Color.parseColor(getResources().getString(R.color.action_bar))));

        Intent i = getIntent();

        val = i.getIntExtra("value",0);


        //String path = DATA_PATH;
        String[] paths = new String[] { DATA_PATH, DATA_PATH + "tessdata/" };
        for (String path : paths) {
            File dir = new File(path);
            if (!dir.exists()) {
                if (!dir.mkdirs()) {
                    Log.v(TAG, "ERROR: Creation of directory " + path + " on sdcard failed");
                    return;
                } else {
                    Log.v(TAG, "Created directory " + path + " on sdcard");
                }
            }

        }

        if (!(new File(DATA_PATH + "tessdata/" + lang + ".traineddata")).exists()) {
            try {

                AssetManager assetManager = getAssets();
                InputStream in = assetManager.open("tessdata/" + lang + ".traineddata");
                //GZIPInputStream gin = new GZIPInputStream(in);
                OutputStream out = new FileOutputStream(DATA_PATH
                        + "tessdata/" + lang + ".traineddata");

                // Transfer bytes from in to out
                byte[] buf = new byte[1024];
                int len;
                //while ((lenf = gin.read(buff)) > 0) {
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
                in.close();
                //gin.close();
                out.close();

                Log.v(TAG, "Copied " + lang + " traineddata");
            } catch (IOException e) {
                Log.e(TAG, "Was unable to copy " + lang + " traineddata " + e.toString());
            }
        }


        _path = DATA_PATH + "/ocr.jpg";

        SelectImage = (Button) findViewById(R.id.selectimage);
        EnhanceImage = (Button) findViewById(R.id.enhance);
        imViewAndroid = (ImageView) findViewById(R.id.imageView1);
        _field = (EditText) findViewById(R.id.field);

        /**
         * Capture image button click event
         */
        SelectImage.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // capture picture
                captureImage();
            }
        });

        /**
         * Record video button click event
         */


        // Checking camera availability
        if (!isDeviceSupportCamera()) {
            Toast.makeText(getApplicationContext(),
                    "Sorry! Your device doesn't support camera",
                    Toast.LENGTH_LONG).show();
            // will close the app if the device does't have camera
            finish();
        }
    }

    /**
     * Checking device has camera hardware or not
     * */
    private boolean isDeviceSupportCamera() {
        if (getApplicationContext().getPackageManager().hasSystemFeature(
                PackageManager.FEATURE_CAMERA)) {
            // this device has a camera
            return true;
        } else {
            // no camera on this device
            return false;
        }
    }

    /**
     * Launching camera app to capture image
     */
    private void captureImage() {
       /* Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

        fileUri = getOutputMediaFileUri(MEDIA_TYPE_IMAGE);

        intent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri);

        // start the image capture Intent

        startActivityForResult(intent, CAMERA_CAPTURE_IMAGE_REQUEST_CODE);
        Toast.makeText(getApplicationContext(),
                "camera",
                Toast.LENGTH_LONG).show();*/

        final CharSequence[] options = { "Take Photo", "Choose from Gallery","Cancel" };

        AlertDialog.Builder builder = new AlertDialog.Builder(ImageCalculator.this);
        builder.setTitle("Add Photo!");
        builder.setItems(options, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int item) {
                if (options[item].equals("Take Photo"))
                {
                    File file = new File(_path);
                    outputFileUri = Uri.fromFile(file);

                    final Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                    intent.putExtra(MediaStore.EXTRA_OUTPUT, outputFileUri);

                    startActivityForResult(intent, 1);
                }
                else if (options[item].equals("Choose from Gallery"))
                {
                    Intent intent = new Intent();

                    intent.setType("image/*");
                    intent.setAction(Intent.ACTION_GET_CONTENT);

                    startActivityForResult(Intent.createChooser(intent, "Complete action using"), 2);

                }
                else if (options[item].equals("Cancel")) {
                    dialog.dismiss();
                }
            }
        });
        builder.show();

    }
    public void cropImage(){
        //call the standard crop action intent


        Intent cropIntent = new Intent("com.android.camera.action.CROP");


        //indicate image type and Uri of image
        cropIntent.setDataAndType(outputFileUri, "image/*");
        //set crop properties
        cropIntent.putExtra("crop", "true");
        //indicate aspect of desired crop
        //cropIntent.putExtra("aspectX", 0);
        //cropIntent.putExtra("aspectY", 0);
        //indicate output X and Y
        // cropIntent.putExtra("outputX", 200);
        // cropIntent.putExtra("outputY", 200);
        cropIntent.putExtra("scale", true);
        cropIntent.putExtra("scaleUpIfNeeded", true);

        String root = Environment.getExternalStorageDirectory().toString();
        File myDir = new File(root + "/saved_images");
        myDir.mkdirs();


        String fname = "test.jpg";

        finalpath = root + "/saved_images/" + fname;
        File file = new File (myDir, fname);
        if (file.exists ()) file.delete ();

        cropIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(file));
        cropIntent.putExtra("output", Uri.fromFile(file));

        //retrieve data on return
        cropIntent.putExtra("return-data", true);
        //start the activity - we handle returning in onActivityResult
        startActivityForResult(cropIntent, 3);
    }



    /**
     * Launching camera app to record video
     */

    /**
     * Here we store the file url as it will be null after returning from camera
     * app
     */
    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);

        // save file url in bundle as it will be null on screen orientation
        // changes
        outState.putParcelable("file_uri", outputFileUri);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);

        // get the file url
        outputFileUri = savedInstanceState.getParcelable("file_uri");
    }



    /**
     * Receiving activity result method will be called after closing the camera
     * */
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // if the result is capturing Image


        Log.i(TAG, "resultCode: " + resultCode);

		/*if (resultCode == -1) {
			onPhotoTaken();
		} else {
			Log.v(TAG, "User cancelled");
		}*/
        if (resultCode != RESULT_OK) return;

        Log.e("code", "requestcode: " + requestCode);

        switch(requestCode)
        {
            case 0:

                break;
            case 1:
                
                cropImage();
                break;
            case 2:
                outputFileUri = data.getData();
                cropImage();
                break;
            case 3:
                Bundle extras = data.getExtras();
                outputFileUri = data.getData();

                //get the cropped bitmap from extras
               // bitmap = extras.getParcelable("data");

                String root = Environment.getExternalStorageDirectory().toString();
                File myDir = new File(root + "/saved_images");
                myDir.mkdirs();


                String fname = "test.jpg";

                finalpath = root + "/saved_images/" + fname;

                 bitmap = BitmapFactory.decodeFile(finalpath);
                Log.e("Original   dimensions", bitmap.getWidth()+" "+bitmap.getHeight());



               /* File file = new File (myDir, fname);



                if (file.exists ()) file.delete ();
                try {
                    FileOutputStream out = new FileOutputStream(file);
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 60, out);

                    out.flush();
                    out.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }*/
                //launchUploadActivity(true);
                undo= bitmap.copy(bitmap.getConfig(), true);

                //Canvas canvas = new Canvas(bitmap);
                //canvas.drawBitmap(bitmap, 0, 0, null);

                Log.e("aftercrop", "width " + bitmap.getWidth() + "height " + bitmap.getHeight());
                imViewAndroid.setImageBitmap(bitmap);
                //onPhotoTaken(thePic);
                break;
        }

    }

    private void launchUploadActivity(boolean isImage){
        Intent i = new Intent(ImageCalculator.this, UploadActivity.class);
        i.putExtra("filePath", finalpath);
        i.putExtra("isImage", isImage);
        startActivity(i);
    }

    /**
     * ------------ Helper Methods ----------------------
     * */

    /**
     * Creating file uri to store image/video
     */
    public Uri getOutputMediaFileUri(int type) {
        return Uri.fromFile(getOutputMediaFile(type));
    }

    /**
     * returning image / video
     */
    private static File getOutputMediaFile(int type) {

        // External sdcard location
        File mediaStorageDir = new File(
                Environment
                        .getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES),
                Config.IMAGE_DIRECTORY_NAME);

        // Create the storage directory if it does not exist
        if (!mediaStorageDir.exists()) {
            if (!mediaStorageDir.mkdirs()) {
                Log.d(TAG, "Oops! Failed create "
                        + Config.IMAGE_DIRECTORY_NAME + " directory");
                return null;
            }
        }

        // Create a media file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss",
                Locale.getDefault()).format(new Date());
        File mediaFile;
        if (type == MEDIA_TYPE_IMAGE) {
            mediaFile = new File(mediaStorageDir.getPath() + File.separator
                    + "test.jpg");
        } else if (type == MEDIA_TYPE_VIDEO) {
            mediaFile = new File(mediaStorageDir.getPath() + File.separator
                    + "VID_" + timeStamp + ".mp4");
        } else {
            return null;
        }

        return mediaFile;
    }


    public void Enhance(View view)
    {
        //upload to serverc
        new UploadFileToServer().execute();



    }

    public void performOCR(View view)
    {
        if(val==0){
            _taken = true;
            String whitelist="0123456789+-*/x().";

            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inSampleSize = 4;
            bitmap = bitmap.copy(Bitmap.Config.ARGB_8888, true);

            Log.e(TAG, "Before baseApi");

            TessBaseAPI baseApi = new TessBaseAPI();

            baseApi.setDebug(true);

            baseApi.init(DATA_PATH, lang);
            baseApi.setImage(bitmap);
            baseApi.setVariable(TessBaseAPI.VAR_CHAR_WHITELIST, whitelist);

            recognizedText = baseApi.getUTF8Text();

            baseApi.end();

            // You now have the text in recognizedText var, you can do anything with it.
            // We will display a stripped out trimmed alpha-numeric version of it (if lang is eng)
            // so that garbage doesn't make it to the display.

            Log.e(TAG, "OCRED TEXT: " + recognizedText);

		/*if ( lang.equalsIgnoreCase("eng") ) {
			recognizedText = recognizedText.replaceAll("[^a-zA-Z0-9]+", " ");
		}*/

            recognizedText = recognizedText.trim();

            _field.setText(recognizedText);



        }
        else{
            try{
                UploadFileToServer2 task = new UploadFileToServer2();
                task.execute();


            }
            catch( Exception ex) {
                ex.printStackTrace();
            }

        }



        /*if ( recognizedText.length() != 0 ) {
            _field.setText(_field.getText().toString().length() == 0 ? recognizedText : _field.getText() + " " + recognizedText);
            _field.setSelection(_field.getText().toString().length());
        }*/

    }

    public void calculate(View view)
    {
        String recogtxt = String.valueOf(_field.getText());
        Log.e("calculation starts of ",recognizedText);
        int ans = new Calculate().evaluate(recogtxt);
        Log.e("anss",""+ans);
        _field.setText(""+ans);

    }

    public void Undo(View view)
    {
        bitmap = undo;
        imViewAndroid.setImageBitmap(undo);

    }
    private class UploadFileToServer extends AsyncTask<Void, Integer, String> {
        @Override
        protected void onPreExecute() {
            // setting progress bar to zero
          //  progressBar.setProgress(0);
            super.onPreExecute();
        }

        @Override
        protected void onProgressUpdate(Integer... progress) {
            // Making progress bar visible
            //progressBar.setVisibility(View.VISIBLE);

            // updating progress bar value
//            progressBar.setProgress(progress[0]);

            // updating percentage value
        //    txtPercentage.setText(String.valueOf(progress[0]) + "%");
        }

        @Override
        protected String doInBackground(Void... params) {
            return uploadFile();
        }

        @SuppressWarnings("deprecation")
        private String uploadFile() {
            String responseString = null;

            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httppost = new HttpPost(Config.FILE_UPLOAD_URL);

            try {
                AndroidMultiPartEntity entity = new AndroidMultiPartEntity(
                        new AndroidMultiPartEntity.ProgressListener() {

                            @Override
                            public void transferred(long num) {
                                publishProgress((int) ((num / (float) totalSize) * 100));
                            }
                        });

                File sourceFile = new File(finalpath);

                // Adding file data to http body
                entity.addPart("image", new FileBody(sourceFile));

                // Extra parameters if you want to pass to server
                entity.addPart("website",
                        new StringBody("www.androidhive.info"));
                entity.addPart("email", new StringBody("dikshaa42@gmail.com"));

                totalSize = entity.getContentLength();
                httppost.setEntity(entity);

                // Making server call
                HttpResponse response = httpclient.execute(httppost);
                HttpEntity r_entity = response.getEntity();

                int statusCode = response.getStatusLine().getStatusCode();
                if (statusCode == 200) {
                    // Server response
                    responseString = EntityUtils.toString(r_entity);
                } else {
                    responseString = "Error occurred! Http Status Code: "
                            + statusCode;
                }

            } catch (ClientProtocolException e) {
                responseString = e.toString();
            } catch (IOException e) {
                responseString = e.toString();
            }

            return responseString;

        }

        @Override
        protected void onPostExecute(String result) {
            Log.e(TAG, "Response from server: " + result);

            // showing the server response in an alert dialog

            String image_url = "http://192.168.43.175/major/enhanced.jpg";

            // ImageLoader class instance
            ImageLoader imgLoader = new ImageLoader(getApplicationContext());
            //new MemoryCache().clear();

            // whenever you want to load an image from url
            // call DisplayImage function
            // url - image url to load
            // loader - loader image, will be displayed before getting image
            // image - ImageView
            imgLoader.DisplayImage(image_url, imViewAndroid);
            bitmap = ((BitmapDrawable)imViewAndroid.getDrawable()).getBitmap();
            Log.e("Returned  dimensions ", bitmap.getWidth()+" "+bitmap.getHeight());
            imViewAndroid.setImageBitmap(bitmap);
            //showAlert(result);

            super.onPostExecute(result);
        }

    }

    /**
     * Method to show alert dialog
     * */
    private void showAlert(String message) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(message).setTitle("Response from Servers")
                .setCancelable(false)
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        // do nothing
                    }
                });
        AlertDialog alert = builder.create();
        alert.show();
    }

    private class UploadFileToServer2 extends AsyncTask<Void, Integer, String> {
        @Override
        protected void onPreExecute() {
            // setting progress bar to zero
            //  progressBar.setProgress(0);
            super.onPreExecute();
        }
    protected void onProgressUpdate(Integer... progress) {
        // Making progress bar visible
        //progressBar.setVisibility(View.VISIBLE);

        // updating progress bar value
//            progressBar.setProgress(progress[0]);

        // updating percentage value
        //    txtPercentage.setText(String.valueOf(progress[0]) + "%");
    }

    @Override
    protected String doInBackground(Void... params) {
        return uploadFile();
    }

    @SuppressWarnings("deprecation")
    private String uploadFile() {
        String responseString = null;

        HttpClient httpclient = new DefaultHttpClient();
        HttpPost httppost = new HttpPost(Config.TEXT_URL);

        try {
              /*  AndroidMultiPartEntity entity = new AndroidMultiPartEntity(
                        new AndroidMultiPartEntity.ProgressListener() {

                            @Override
                            public void transferred(long num) {
                                publishProgress((int) ((num / (float) totalSize) * 100));
                            }
                        });

                File sourceFile = new File(finalpath);

                // Adding file data to http body
                entity.addPart("image", new FileBody(sourceFile));

                // Extra parameters if you want to pass to server
                entity.addPart("website",
                        new StringBody("www.androidhive.info"));
                entity.addPart("email", new StringBody("dikshaa42@gmail.com"));

                totalSize = entity.getContentLength();
                httppost.setEntity(entity);
*/
            // Making server call
            HttpResponse response = httpclient.execute(httppost);
            Log.e("response","");
            HttpEntity r_entity = response.getEntity();

            int statusCode = response.getStatusLine().getStatusCode();
            if (statusCode == 200) {
                // Server response
                responseString = EntityUtils.toString(r_entity);
            } else {
                responseString = "Error occurred! Http Status Code: "
                        + statusCode;
            }

        } catch (ClientProtocolException e) {
            responseString = e.toString();
        } catch (IOException e) {
            responseString = e.toString();
        }

        return responseString;

    }

    @Override
    protected void onPostExecute(String result) {
        Log.e(TAG, "Response from server: " + result);

        String exp = result;
        Log.e("handwritten exp",""+exp);
        //double x= new Calculate().evaluate(exp);
        //String x1=Double.toString(x);
        _field.setText(exp);

        // showing the server response in an alert dialog

           /* String image_url = "http://192.168.43.175/major/enhanced.jpg";

            // ImageLoader class instance
            ImageLoader imgLoader = new ImageLoader(getApplicationContext());
            //new MemoryCache().clear();

            // whenever you want to load an image from url
            // call DisplayImage function
            // url - image url to load
            // loader - loader image, will be displayed before getting image
            // image - ImageView
            imgLoader.DisplayImage(image_url, imViewAndroid);
            bitmap = ((BitmapDrawable) imViewAndroid.getDrawable()).getBitmap();
            Log.e("Returned  dimensions ", bitmap.getWidth() + " " + bitmap.getHeight());
            imViewAndroid.setImageBitmap(bitmap);
            //showAlert(result);
*/
        super.onPostExecute(result);

    }

}

}
