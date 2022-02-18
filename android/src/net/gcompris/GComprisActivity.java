/****************************************************************************
**
** SPDX-FileCopyrightText: 2013 Digia Plc and /or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only or GPL-3.0-only
**
** This file is part of the QtAndroidExtras module of the Qt Toolkit.
**
****************************************************************************/

package net.gcompris;

import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
import android.media.AudioManager;
import android.util.Log;
import android.content.Context;
import android.view.WindowManager;
import java.text.Collator;
import java.util.Locale;
import java.util.Arrays;
import java.util.List;

public class GComprisActivity extends QtActivity
{
    private static GComprisActivity m_instance;
    private List<Locale> availableLocales = null;

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
		// Only initialize once the available locales list
		if(availableLocales == null)
			availableLocales = Arrays.asList(Collator.getAvailableLocales());
		String[] parts = locale.split("[\\._]");
		Locale l;
		if (parts.length >= 2 && availableLocales.contains(new Locale(parts[0], parts[1])))
			l = new Locale(parts[0], parts[1]);
		else if (availableLocales.contains(new Locale(parts[0])))
			l = new Locale(parts[0]);
		else
			l = Locale.getDefault();
		Collator collator = Collator.getInstance(l);
		// Note: This works only if the device supports the
		// passed locale. If it does not or if an invalid locale string has been
		// passed, the collator seems to sort according to Locale.getDefault()
                return collator.compare(a, b);
	}
}
