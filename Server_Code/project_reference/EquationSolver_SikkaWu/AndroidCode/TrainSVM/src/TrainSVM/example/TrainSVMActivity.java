package TrainSVM.example;


import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.PixelFormat;
import android.graphics.Bitmap.CompressFormat;
import android.hardware.Camera;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import java.io.*;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.*;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.DefaultHttpClient;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;

public class TrainSVMActivity extends Activity  {
	private SurfaceView 	m_Preview = null;
	private SurfaceHolder 	m_PreviewHolder = null;
	private Camera 			m_Camera=null;
	private Builder 		m_Builder;
	private int				m_HW = 0;
	private Button			m_QueryButton = null;
	private int				m_QueryType;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		/* Use full screen and remove window title */
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(	WindowManager.LayoutParams.FLAG_FULLSCREEN,
	             				WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(R.layout.main);

		/* Create message dialog for showing text */
		m_Builder = new AlertDialog.Builder(this);
		m_Builder.setTitle("Solution");
	
		/* Class to take care of the photo application */
		m_Preview=(SurfaceView)findViewById(R.id.SurfaceView01);
		m_PreviewHolder=m_Preview.getHolder();
		m_PreviewHolder.addCallback(surfaceCallback);
		m_PreviewHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
		
		/* Add button for query/add */
		m_QueryButton 	= (Button) findViewById( R.id.solveHW);
		m_QueryButton.setOnClickListener( new OnClickListener() {
			public void onClick(View v) {
				m_QueryType = 1;
				takePicture();
			}
		});
		m_QueryButton 	= (Button) findViewById( R.id.solveP);
		m_QueryButton.setOnClickListener( new OnClickListener() {
			public void onClick(View v) {
				m_QueryType = 0;
				takePicture();
			}
		});
		
		m_QueryButton 	= (Button) findViewById( R.id.confirm);
		m_QueryButton.setOnClickListener( new OnClickListener() {
			public void onClick(View v) {
				TextView editView = (TextView)findViewById(R.id.equation);
				Button button = (Button) findViewById( R.id.confirm);
				Log.v("Final Equation: ", editView.getText().toString());
				editView.setVisibility(View.INVISIBLE);
				button.setVisibility(View.INVISIBLE);
				m_Builder.setMessage((QueryImage2(editView.getText().toString().getBytes() )));
				editView.setText("");
				m_Builder.show();
			}
		});
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode==KeyEvent.KEYCODE_CAMERA || keyCode==KeyEvent.KEYCODE_SEARCH) {
			m_QueryType = 0;
			takePicture();
			return(true);
		}
		return(super.onKeyDown(keyCode, event));
	}
	
	private void takePicture() {
		m_Camera.takePicture(null, null, photoCallback);
	}
	
	Camera.PictureCallback photoCallback=new Camera.PictureCallback() {
		public void onPictureTaken(byte[] data, Camera m_Camera) {
			/* Downsize the image from the camera */
			Bitmap bImage = BitmapFactory.decodeByteArray( data, 0, data.length);
			bImage = Bitmap.createScaledBitmap(bImage, 640, 480, false);
			ByteArrayOutputStream oData = new ByteArrayOutputStream();  
			bImage.compress( CompressFormat.JPEG, 85, oData);
			/* Query image */
			String sResult = QueryImage1( oData.toByteArray() ,m_QueryType);
			/* Display equation and wait for confirmation from user*/
			
			TextView editView = (TextView)findViewById(R.id.equation);
			Button button = (Button) findViewById( R.id.confirm);
			editView.setText(sResult);
			//editView.setVisibility(View.VISIBLE);
			//button.setVisibility(View.VISIBLE);
			m_Camera.startPreview();
		}
	};
	
	/* COPY THE FOLLOWING FUNCTION TO YOUR CLASS IF YOU PLAN TO USE TEXT RECOGNITION SERVICE*/
	/* Send HTTP POST request with image data to image recognition server */  
	public static String QueryImage1( byte[] bData, int iQueryType)
	{			
		/* Setup http objects */
		HttpClient 	httpClient 	= new DefaultHttpClient();
		HttpPost 	httpPost;
		if(iQueryType == 1) {
			httpPost 	= new HttpPost("http://10.33.83.227/train.php");
		}
		else {
			httpPost 	= new HttpPost("http://10.33.83.227/train.php");
		}
		ByteArrayEntity bEntity = new ByteArrayEntity(bData);
		String 		sResult 	= null;
		
		try { 
            /* Construct data */ 
			httpPost.setEntity(bEntity);
			/* Send HTTP request */
			HttpResponse httpResponse = httpClient.execute(httpPost);
			
			/* Get the text results from the response */
			BufferedReader 	hBufferedReader = new BufferedReader(new InputStreamReader(httpResponse.getEntity().getContent()));
			StringBuilder 	sInputBuffer 	= new StringBuilder();
			try {
				String 	sInputLine = null;
				while((sInputLine = hBufferedReader.readLine())!=null)
					sInputBuffer.append(sInputLine + "\n");
			}
			catch(Exception ex) {	}
			finally {
				try		{	httpResponse.getEntity().getContent().close();	}
				catch(Exception ex) {}
			}
			sResult = sInputBuffer.toString();			
			
			Log.v("RECEIVED", sResult);
        } catch (Exception e) { 
        }
		return sResult;
	};
	
	public static String QueryImage2(byte[] bData)
	{			
		/* Setup http objects */
		HttpClient 	httpClient 	= new DefaultHttpClient();
		HttpPost 	httpPost 	= new HttpPost("http://10.33.83.227/EqSolverSolve.php");
		String test = "THIS IS A TEST";
		ByteArrayEntity bEntity = new ByteArrayEntity(bData);
		
		String 		sResult 	= null;
		
		try { 
            /* Construct data */ 
			httpPost.setEntity(bEntity);
			/* Send HTTP request */
			HttpResponse httpResponse = httpClient.execute(httpPost);
			
			/* Get the text results from the response */
			BufferedReader 	hBufferedReader = new BufferedReader(new InputStreamReader(httpResponse.getEntity().getContent()));
			StringBuilder 	sInputBuffer 	= new StringBuilder();
			try {
				String 	sInputLine = null;
				while((sInputLine = hBufferedReader.readLine())!=null)
					sInputBuffer.append(sInputLine + "\n");
			}
			catch(Exception ex) {	}
			finally {
				try		{	httpResponse.getEntity().getContent().close();	}
				catch(Exception ex) {}
			}
			sResult = sInputBuffer.toString();			
			
			Log.v("RECEIVED", sResult);
        } catch (Exception e) { 
        }
		return sResult;
	};
	
	SurfaceHolder.Callback surfaceCallback=new SurfaceHolder.Callback() {
		public void surfaceCreated(SurfaceHolder holder) {
			m_Camera=Camera.open();
			/* Set the camera parameters to take the smallest image as possible */
			Camera.Parameters 	currentParameters = m_Camera.getParameters();
			m_Camera.setParameters(currentParameters);
			try {
				m_Camera.setPreviewDisplay(m_PreviewHolder);
			}
			catch (Throwable t) {
				Log.e("PictureDemo-surfaceCallback", "Exception in setPreviewDisplay()", t);
				Toast
					.makeText(TrainSVMActivity.this, t.getMessage(), Toast.LENGTH_LONG)
					.show();
			}
		}
	
		public void surfaceChanged(SurfaceHolder holder, int format, int width, int height)	{
			Camera.Parameters 	currentParameters = m_Camera.getParameters();
			currentParameters.setPreviewSize(width, height);
			currentParameters.setPictureFormat(PixelFormat.JPEG);
			m_Camera.setParameters(currentParameters);
			m_Camera.startPreview();
		}
	
		public void surfaceDestroyed(SurfaceHolder holder) {
			m_Camera.stopPreview();
			m_Camera.release();
			m_Camera=null;
		}
	};
}