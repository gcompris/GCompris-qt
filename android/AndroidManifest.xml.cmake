<?xml version="1.0"?>
<!--
  - SPDX-License-Identifier: BSD-2-Clause
  - SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
  - SPDX-FileCopyrightText: 2014-2022 Johnny Jazeix <jazeix@gmail.com>
 -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
     package="@ANDROID_PACKAGE@"
     android:installLocation="auto"
     android:versionCode="@GCOMPRIS_VERSION_CODE@"
     android:versionName="@GCOMPRIS_VERSION@">
    <supports-screens
        android:anyDensity="true"
        android:largeScreens="true"
        android:normalScreens="true"
        android:smallScreens="true" />
    <application
        android:icon="@drawable/icon"
        android:name="org.qtproject.qt.android.bindings.QtApplication"
        android:extractNativeLibs="true"
        android:hardwareAccelerated="true"
        android:label="GCompris"
        android:requestLegacyExternalStorage="true"
        android:allowNativeHeapPointerTagging="false"
        android:allowBackup="true"
        android:fullBackupOnly="false">
        <activity
            android:name="net.gcompris.GComprisActivity"
            android:configChanges="orientation|uiMode|screenLayout|screenSize|smallestScreenSize|layoutDirection|locale|fontScale|keyboard|keyboardHidden|navigation|mcc|mnc|density"
            android:label="@string/app_name"
            android:launchMode="singleTop"
            android:screenOrientation="unspecified"
            android:exported="true">
	    <intent-filter>
	      <action android:name="android.intent.action.MAIN"/>
	      <category android:name="android.intent.category.LAUNCHER"/>
	    </intent-filter>
	    <meta-data android:name="android.app.lib_name" android:value="GCompris"/>

	    <!-- Splash screen -->
            <meta-data android:name="android.app.splash_screen_drawable" android:resource="@drawable/splash"/>
          <meta-data
                android:name="android.app.extract_android_style"
                android:value="minimal" />
        </activity>
    </application>

    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    @ANDROID_INTERNET_PERMISSION@
    @ANDROID_ACCESS_NETWORK_STATE_PERMISSION@
</manifest>
