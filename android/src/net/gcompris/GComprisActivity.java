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
** will be met: https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
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
** met: https://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

package net.gcompris;

import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
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
    public static final String SKU_NAME = "full";

    public GComprisActivity()
    {
        m_instance = this;
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
