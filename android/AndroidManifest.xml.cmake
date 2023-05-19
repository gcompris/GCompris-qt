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
        android:name="org.qtproject.qt5.android.bindings.QtApplication"
        android:extractNativeLibs="true"
        android:hardwareAccelerated="true"
        android:label="GCompris"
        android:requestLegacyExternalStorage="true">
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
            
            <meta-data android:name="android.app.qt_sources_resource_id" android:resource="@array/qt_sources"/>
            <meta-data android:name="android.app.repository" android:value="default"/>
            <meta-data android:name="android.app.qt_libs_resource_id" android:resource="@array/qt_libs"/>
            <meta-data android:name="android.app.bundled_libs_resource_id" android:resource="@array/bundled_libs"/>
            <!-- Deploy Qt libs as part of package -->
            <meta-data android:name="android.app.bundle_local_qt_libs" android:value="-- %%BUNDLE_LOCAL_QT_LIBS%% --"/>

            <!-- Run with local libs -->
            <meta-data android:name="android.app.use_local_qt_libs" android:value="-- %%USE_LOCAL_QT_LIBS%% --"/>
            <meta-data android:name="android.app.libs_prefix" android:value="/data/local/tmp/qt/"/>
            <meta-data android:name="android.app.load_local_libs_resource_id" android:resource="@array/load_local_libs"/>
            <meta-data android:name="android.app.load_local_jars" android:value="-- %%INSERT_LOCAL_JARS%% --"/>
            <meta-data android:name="android.app.static_init_classes" android:value="-- %%INSERT_INIT_CLASSES%% --"/>
            <!-- Used to specify custom system library path to run with local system libs -->
            <!-- <meta-data android:name="android.app.system_libs_prefix" android:value="/system/lib/"/> -->
            <!--  Messages maps -->
            <meta-data android:value="@string/ministro_not_found_msg" android:name="android.app.ministro_not_found_msg"/>
            <meta-data android:value="@string/ministro_needed_msg" android:name="android.app.ministro_needed_msg"/>
            <meta-data android:value="@string/fatal_error_msg" android:name="android.app.fatal_error_msg"/>
            <meta-data android:value="@string/unsupported_android_version" android:name="android.app.unsupported_android_version"/>
            <!--  Messages maps -->
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
