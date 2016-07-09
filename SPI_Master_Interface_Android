//User must modify the below package with their package name
package com.SPIMasterDemo; 
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.usb.UsbAccessory;
import android.hardware.usb.UsbManager;
import android.os.Handler;
import android.os.Message;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import android.widget.Toast;


/******************************FT311 GPIO interface class******************************************/
public class FT311SPIMasterInterface extends Activity
{
	
	private static final String ACTION_USB_PERMISSION =    "com.SPIMasterDemo.USB_PERMISSION";
	public UsbManager usbmanager;
	public UsbAccessory usbaccessory;
	public PendingIntent mPermissionIntent;
	public ParcelFileDescriptor filedescriptor;
	public FileInputStream inputstream;
	public FileOutputStream outputstream;
	public boolean mPermissionRequestPending = false;
	public boolean READ_ENABLE = true;
	public boolean accessory_attached = false;
	public handler_thread handlerThread;
	
	private byte [] usbdata; 
    private byte []	writeusbdata;
    private int readcount;
    private byte status;
    private byte  maxnumbytes = (byte) 63; /*maximum data bytes, except command*/
    public boolean datareceived = false;

    public Context global_context;
   
    public static String ManufacturerString = "mManufacturer=FTDI";
    public static String ModelString = "mModel=FTDISPIMasterDemo";
    public static String VersionString = "mVersion=1.0";	
	
		
		/*constructor*/
	 public FT311SPIMasterInterface(Context context){
		 	super();
                        global_context = context;
			/*shall we start a thread here or what*/
			usbdata = new byte[64]; 
	        writeusbdata = new byte[64];
	        
	        /***********************USB handling******************************************/
			
	        usbmanager = (UsbManager) context.getSystemService(Context.USB_SERVICE);
	       // Log.d("LED", "usbmanager" +usbmanager);
	        mPermissionIntent = PendingIntent.getBroadcast(context, 0, new Intent(ACTION_USB_PERMISSION), 0);
	        IntentFilter filter = new IntentFilter(ACTION_USB_PERMISSION);
	       filter.addAction(UsbManager.ACTION_USB_ACCESSORY_DETACHED);
	       context.registerReceiver(mUsbReceiver, filter);
	        
	       inputstream = null;
	       outputstream = null;
		}
	 
	 	/*reset method*/
	 	public void Reset()
	 	{
	 		/*create the packet*/
	 		writeusbdata[0] = (byte) 0x64;
			/*send the packet over the USB*/
			SendPacket(1);
	 	}
	 	
	 	
	 	public void SetConfig(byte clockPhase, byte dataOrder, int clockFreq)
	 	{
	 		/*check for maximum clock freq, 24Mhz*/
	 		if(clockFreq > 24000000){
	 			clockFreq = 24000000;
	 		}
	 		
	 		writeusbdata[0] = (byte) 0x61;
	 		writeusbdata[1] = clockPhase;
	 		writeusbdata[2] = dataOrder;
	 		writeusbdata[3] = (byte)(clockFreq & 0xff);
	 		writeusbdata[4] = (byte)((clockFreq >> 8) & 0xff);
	 		writeusbdata[5] = (byte)((clockFreq >> 16)& 0xff);
	 		writeusbdata[6] = (byte)((clockFreq >> 24)& 0xff);
	 		
	 		SendPacket((int)7);;
	 		
	 	}
	 		
	 	
	 	/*write data*/
	 	public byte SendData(byte numBytes, byte[] buffer, byte [] numReadBytes)
	 	{
	 		
	 		status = 0x00; /*error by default*/
	 		/*
	 		 * if num bytes are more than maximum limit
	 		 */
	 		if(numBytes < 1){
	 			/*return the status with the error in the command*/
	 			return status;
	 		}
	 		
	 		/*check for maximum limit*/
	 		if(numBytes > maxnumbytes){
	 			numBytes = maxnumbytes;
		
	 		}
	 		
	 		
	 		/*prepare the packet to be sent*/
	 		for(int count = 0;count<numBytes;count++)
	 		{
	 			writeusbdata[count+1] = buffer[count];
	 		}
	 		
	 		/*prepare the usbpacket*/
	 		writeusbdata[0] = (byte) 0x62;
	 		SendPacket((int)(numBytes+1));
	 		
	 		datareceived = false;
	 		/*wait while the data is received*/
	 		/*FIXME, may be create a thread to wait on , but any
	 		 * way has to wait in while loop
	 		 */
	 		while(true){
	 			
	 			if(datareceived == true){
	 				break;
	 			}
	 		}
	 		
	 		/*success by default*/
	 		status = 0x00;
	 		
	 		if(usbdata[0] == 0x62)
	 		{
	 		
	 			/*copy the received data into the buffer*/
	 			for(int count=0;count<(readcount-1);count++){
	 			
	 				buffer[count] = usbdata[count+1];
	 			}
	 		
	 			/*update the received length*/
	 			numReadBytes[0] = (byte)(readcount-1);
	 		}	
	 		/*read the next usb data*/
	 		datareceived = false;
	 			
	 		return status;
	 	}
	 	
	 	
	 	/*write data*/
	 	public byte ReadData(byte numBytes, byte[] buffer, byte [] numReadBytes)
	 	{
	 		
	 		status = 0x00; /*error by default*/
	 		/*
	 		 * if num bytes are more than maximum limit
	 		 */
	 		if(numBytes < 1){
	 			/*return the status with the error in the command*/
	 			return status;
	 		}
	 		
	 		/*check for maximum limit*/
	 		if(numBytes > maxnumbytes){
	 			numBytes = maxnumbytes;
		
	 		}
	 		
	 		
	 		/*prepare the packet to be sent*/
	 		for(int count = 0;count<numBytes;count++)
	 		{
	 			
	 			writeusbdata[count+1] = buffer[count];
 			
	 		}
	 		
	 		/*prepare the usbpacket*/
	 		writeusbdata[0] = (byte) 0x63;
	 		SendPacket((int)(numBytes+1));
	 		
	 		datareceived = false;
	 		/*wait while the data is received*/
	 		/*FIXME, may be create a thread to wait on , but any
	 		 * way has to wait in while loop
	 		 */
	 		while(true){
	 			
	 			if(datareceived == true){
	 				
	 				break;
	 			}
	 		}
	 		
	 		/*success by default*/
	 		status = 0x00;
	 		if(usbdata[0] ==  0x63)
	 		{
	 			/*copy the received data into the buffer*/
	 			for(int count=0;count<(readcount-1);count++){
	 			
	 				buffer[count] = usbdata[count+1];
	 			}
	 		
	 			/*update the received length*/
	 			numReadBytes[0] = (byte)(readcount-1);
	 			/*read the next usb data*/
	 			datareceived = false;
	 		}	
	 		return status;
	 	}
	 		 	
		/*method to send on USB*/
		private void SendPacket(int numBytes)
		{
			
			
			try {
				if(outputstream != null){
					outputstream.write(writeusbdata, 0,numBytes);
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		
		/*resume accessory*/
		public void ResumeAccessory()
		{
			// Intent intent = getIntent();
			if (inputstream != null && outputstream != null) {
				return;
			}
			
			UsbAccessory[] accessories = usbmanager.getAccessoryList();
			if(accessories != null)
			{
				Toast.makeText(global_context, "Accessory Attached", Toast.LENGTH_SHORT).show();
			}
			else
			{
				accessory_attached = false;
				return;
			}
			
			UsbAccessory accessory = (accessories == null ? null : accessories[0]);
			if (accessory != null) {
				if( -1 == accessory.toString().indexOf(ManufacturerString))
				{
					Toast.makeText(global_context, "Manufacturer is not matched!", Toast.LENGTH_SHORT).show();
					return;
				}

				if( -1 == accessory.toString().indexOf(ModelString))
				{
					Toast.makeText(global_context, "Model is not matched!", Toast.LENGTH_SHORT).show();
					return;
				}
				
				if( -1 == accessory.toString().indexOf(VersionString))
				{
					Toast.makeText(global_context, "Version is not matched!", Toast.LENGTH_SHORT).show();
					return;
				}
				
				Toast.makeText(global_context, "Manufacturer, Model & Version are matched!", Toast.LENGTH_SHORT).show();
				accessory_attached = true;
				
				if (usbmanager.hasPermission(accessory)) {
					OpenAccessory(accessory);
				} 
				else
				{
					synchronized (mUsbReceiver) {
						if (!mPermissionRequestPending) {
							Toast.makeText(global_context, "Request USB Permission", Toast.LENGTH_SHORT).show();
							usbmanager.requestPermission(accessory,
									mPermissionIntent);
							mPermissionRequestPending = true;
						}
				}
			}
			} else {}

		}
		
		/*destroy accessory*/
		public void DestroyAccessory(){
			global_context.unregisterReceiver(mUsbReceiver);
			if(accessory_attached == true)
			{
				READ_ENABLE = false;  // set false condition for handler_thread to exit waiting data loop
				byte [] tmpnRBytes = {0};
				byte [] temp2 = new byte[64];			
				ReadData((byte)3,temp2, tmpnRBytes); // send dummy data for instream.read going
				try{Thread.sleep(10);}
		 		catch(Exception e){}
			}
			CloseAccessory();
		}
		

		
/*********************helper routines*************************************************/		
		
		public void OpenAccessory(UsbAccessory accessory)
		{
			filedescriptor = usbmanager.openAccessory(accessory);
			if(filedescriptor != null){
				usbaccessory = accessory;
				FileDescriptor fd = filedescriptor.getFileDescriptor();
				inputstream = new FileInputStream(fd);
				outputstream = new FileOutputStream(fd);
				/*check if any of them are null*/
				if(inputstream == null || outputstream==null){
					return;
				}
			}
			
			handlerThread = new handler_thread(inputstream);
			handlerThread.start();
		}
		
		private void CloseAccessory()
		{
			try{
				if(filedescriptor != null)
					filedescriptor.close();
				
			}catch (IOException e){}
			
			try {
				if(inputstream != null)
						inputstream.close();
			} catch(IOException e){}
			
			try {
				if(outputstream != null)
						outputstream.close();
				
			}catch(IOException e){}
			/*FIXME, add the notfication also to close the application*/
			
			filedescriptor = null;
			inputstream = null;
			outputstream = null;
		
			System.exit(0);
		
		}
		
				
		/***********USB broadcast receiver*******************************************/
	    private final BroadcastReceiver mUsbReceiver = new BroadcastReceiver() 
		{
			@Override
			public void onReceive(Context context, Intent intent) 
			{
				String action = intent.getAction();
				if (ACTION_USB_PERMISSION.equals(action)) 
				{
					synchronized (this)
					{
						UsbAccessory accessory = (UsbAccessory) intent.getParcelableExtra(UsbManager.EXTRA_ACCESSORY);
						if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false))
						{
							Toast.makeText(global_context, "Allow USB Permission", Toast.LENGTH_SHORT).show();
							OpenAccessory(accessory);
						} 
						else 
						{
							Toast.makeText(global_context, "Deny USB Permission", Toast.LENGTH_SHORT).show();
							Log.d("LED", "permission denied for accessory "+ accessory);
							
						}
						mPermissionRequestPending = false;
					}
				} 
				else if (UsbManager.ACTION_USB_ACCESSORY_DETACHED.equals(action)) 
				{
						CloseAccessory();
				}else
				{
					Log.d("LED", "....");
				}
			}	
		};
	    
		
		
		
		
		/*usb input data handler*/
		private class handler_thread  extends Thread {
			FileInputStream instream;
			
			handler_thread(FileInputStream stream ){
				instream = stream;
			}
			
			public void run()
			{
				
				while(READ_ENABLE == true)
				{
					
					try
					{
						/*dont overwrite the previous buffer*/
						if((instream != null) && (datareceived==false))
						{
							readcount = instream.read(usbdata,0,64);
							if(readcount > 0)
							{
								datareceived = true;
								/*send only when you find something*/
							}
						}
					}catch (IOException e){}
				}
			}
		}
	}
