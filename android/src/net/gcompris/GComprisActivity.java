/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtAndroidExtras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

package net.gcompris;

import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
import com.android.vending.billing.*;
import android.media.AudioManager;
import android.util.Log;
import android.os.Bundle;
import android.os.IBinder;
import android.content.ServiceConnection;
import android.content.Intent;
import android.content.ComponentName;
import android.content.Context;
import android.app.PendingIntent;
import org.json.JSONObject;
import java.util.ArrayList;
import android.view.WindowManager;
import java.text.Collator;
import java.util.Locale;

public class GComprisActivity extends QtActivity
{
    private static GComprisActivity m_instance;
//    public static final String SKU_NAME = "android.test.purchased"; // for testing
    public static final String SKU_NAME = "full";

    private IInAppBillingService m_service;
    private ServiceConnection m_serviceConnection = new ServiceConnection() {
       @Override
       public void onServiceDisconnected(ComponentName name)
       {
           m_service = null;
       }

       @Override
       public void onServiceConnected(ComponentName name, IBinder service)
       {
           if(service.isBinderAlive()) {
               m_service = IInAppBillingService.Stub.asInterface(service);
           }
       }
    };

    public GComprisActivity()
    {
        m_instance = this;
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        Intent intent = new Intent("com.android.vending.billing.InAppBillingService.BIND");
        intent.setPackage("com.android.vending");
        bindService(intent,
                    m_serviceConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    public void onDestroy()
    {
        super.onDestroy();

        unbindService(m_serviceConnection);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK && data != null && requestCode == 1001) {
            int responseCode = data.getIntExtra("RESPONSE_CODE", -1);
            String purchaseData = data.getStringExtra("INAPP_PURCHASE_DATA");

            try {
                JSONObject jo = new JSONObject(purchaseData);
                String sku = jo.getString("productId");
                int purchaseState = jo.getInt("purchaseState");
                String payload = jo.getString("developerPayload");
                String purchaseToken = jo.getString("purchaseToken");
                if (sku.equals(SKU_NAME) && purchaseState == 0) {
                    bought(true);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

             Log.e(QtApplication.QtTAG, "Buying full version failed: Result code == " + resultCode);
        }
    }

    private static native void bought(boolean b);

    public static void buyGCompris()
    {
        if (m_instance.m_service == null) {
            Log.e(QtApplication.QtTAG, "Buying full version failed: No billing service");
            return;
        }

        try {
            Bundle buyIntentBundle = m_instance.m_service.getBuyIntent(3,
                                                                       m_instance.getPackageName(),
                                                                       SKU_NAME,
                                                                       "inapp",
                                                                       "");
            int responseCode = buyIntentBundle.getInt("RESPONSE_CODE");
            if (responseCode == 0 /* BILLING_RESPONSE_RESULT_OK */) {
                PendingIntent pendingIntent = buyIntentBundle.getParcelable("BUY_INTENT");
                m_instance.startIntentSenderForResult(pendingIntent.getIntentSender(),
                                                      1001, new Intent(), Integer.valueOf(0), Integer.valueOf(0),
                                                      Integer.valueOf(0));
                return;
            } else if (responseCode == 7 /* BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED */) {
                bought(true);
            } else {
                Log.e(QtApplication.QtTAG, "Buying full version failed: Response code == " + responseCode);
            }
        } catch (Exception e) {
            Log.e(QtApplication.QtTAG, "Exception caught when buying full version!", e);
        }
    }

    public static void checkPayment()
    {
        if (m_instance.m_service == null) {
            Log.e(QtApplication.QtTAG, "Check full version is bought failed: No billing service");
            return;
        }

        try {
            Bundle ownedItems = m_instance.m_service.getPurchases(3, m_instance.getPackageName(),
								  "inapp", null);
            int responseCode = ownedItems.getInt("RESPONSE_CODE");
            if (responseCode == 0) {
                ArrayList ownedSkus = ownedItems.getStringArrayList("INAPP_PURCHASE_ITEM_LIST");
                ArrayList purchaseDataList = ownedItems.getStringArrayList("INAPP_PURCHASE_DATA_LIST");
                for(int i=0; i<purchaseDataList.size(); ++i)
                {
                    String purchaseData = (String) purchaseDataList.get(i);
                    String sku = (String) ownedSkus.get(i);

                    if(sku.equals(SKU_NAME)) {
                        bought(true);
                        return;
		    } else {
			Log.e(QtApplication.QtTAG, "Unknown item bought " + sku);
		    }
		}
                bought(false);
                return;
            } else {
                bought(false);
                Log.e(QtApplication.QtTAG, "Item not owed " + responseCode);
            }
        } catch (Exception e) {
            Log.e(QtApplication.QtTAG, "Exception caught when checking if full version is bought!", e);
        }
    }

    public static boolean requestAudioFocus() {
	Context mContext = m_instance.getApplicationContext();
	AudioManager am = (AudioManager) mContext.getSystemService(Context.AUDIO_SERVICE);

	// Request audio focus for playback
	int result = am.requestAudioFocus(null,
					  // Use the music stream.
					  AudioManager.STREAM_MUSIC,
					  // Request permanent focus.
					  AudioManager.AUDIOFOCUS_GAIN);
   
	if (result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
	    return true;
	}
	return false;
    }

    public static void abandonAudioFocus() {
	// Abandon audio focus
	Context mContext = m_instance.getApplicationContext();
	AudioManager am = (AudioManager) mContext.getSystemService(Context.AUDIO_SERVICE);
	am.abandonAudioFocus(null);
    }

	/**
	 * Toggle activation of screen-saver
	 *
	 * Note that the window flags *must* be modified from the UI thread
	 * otherwise it has no effect.
	 *
	 * @param value  Whether screensaver should be enabled or disabled
	 */
	public void setKeepScreenOn(boolean value) {
		if (value)
			GComprisActivity.this.runOnUiThread(new Runnable() {
				public void run() {
					Log.d(QtApplication.QtTAG, "Disabling screensaver");
					getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
				}
			});
		else
			GComprisActivity.this.runOnUiThread(new Runnable() {
				public void run() {
					Log.d(QtApplication.QtTAG, "Enabling screensaver");
					getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
				}
			});
	}

	public int localeCompare(String a, String b, String locale)
	{
		String[] parts = locale.split("[\\._]");
		Locale l;
		if (parts.length == 1)
			l = new Locale(parts[0]);
		else if (parts.length == 2)
			l = new Locale(parts[0], parts[1]);
		else
			l = Locale.getDefault();
		Collator collator = Collator.getInstance(l);
		// Note: This works only if the device supports the
		// passed locale. If it does not or if an invalid locale string has been
		// passed, the collator seems to sort according to Locale.getDefault()
		return collator.compare(a, b);
	}
}
