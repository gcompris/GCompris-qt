<?xml version='1.0' encoding='utf-8'?>
<manifest android:installLocation="auto" android:versionName="@ANDROID_VERSION_NAME@" xmlns:android="http://schemas.android.com/apk/res/android" package="net.gcompris" android:versionCode="6">
	<application android:label="GCompris" android:name="org.qtproject.qt5.android.bindings.QtApplication" android:icon="@drawable/icon">
		<activity android:configChanges="orientation|uiMode|screenLayout|screenSize|smallestScreenSize|locale|fontScale|keyboard|keyboardHidden|navigation" android:label="@string/app_name" android:name="org.qtproject.qt5.android.bindings.QtActivity" android:screenOrientation="unspecified">
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
			<meta-data android:name="android.app.bundle_local_qt_libs" android:value="1"/>
			<meta-data android:name="android.app.bundled_in_lib_resource_id" android:resource="@array/bundled_in_lib"/>
			<meta-data android:name="android.app.bundled_in_assets_resource_id" android:resource="@array/bundled_in_assets"/>
			<!-- Run with local libs -->
			<meta-data android:name="android.app.use_local_qt_libs" android:value="1"/>
			<meta-data android:name="android.app.libs_prefix" android:value="/data/local/tmp/qt/"/>
			<meta-data android:name="android.app.load_local_libs" android:value="plugins/platforms/android/libqtforandroidGL.so:lib/libQt5QuickParticles.so:lib/libQt5Xml.so:plugins/mediaservice/libqtmedia_android.so:lib/libQt5MultimediaQuick_p.so"/>
			<meta-data android:name="android.app.load_local_jars" android:value="jar/QtAndroid.jar:jar/QtAndroidAccessibility.jar:jar/QtAndroid-bundled.jar:jar/QtAndroidAccessibility-bundled.jar:jar/QtMultimedia.jar:jar/QtMultimedia-bundled.jar"/>
			<meta-data android:name="android.app.static_init_classes" android:value="org.qtproject.qt5.android.multimedia.QtMultimediaUtils:org.qtproject.qt5.android.multimedia.QtMultimediaUtils"/>
			<!--  Messages maps -->
			<meta-data android:name="android.app.ministro_not_found_msg" android:value="@string/ministro_not_found_msg"/>
			<meta-data android:name="android.app.ministro_needed_msg" android:value="@string/ministro_needed_msg"/>
			<meta-data android:name="android.app.fatal_error_msg" android:value="@string/fatal_error_msg"/>
		</activity>
	</application>
	<supports-screens android:anyDensity="true" android:normalScreens="true" android:smallScreens="true" android:largeScreens="true"/>
	<uses-sdk android:minSdkVersion="@ANDROID_API_LEVEL@"/>
	<!--uses-sdk android:minSdkVersion="9" android:targetSdkVersion="19"/-->
</manifest>
