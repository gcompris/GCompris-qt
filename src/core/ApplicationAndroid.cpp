/* GCompris - ApplicationAndroid.cpp
 *
 * Copyright (C) 2014-2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

#include "ApplicationSettings.h"
#include "ApplicationInfo.h"
#include <QAndroidJniObject>
#include <QDebug>
#include <QtAndroid>

void ApplicationSettings::setDemoMode(const bool newDemoMode)
{
    if(!newDemoMode) {
        // Call Google play store
        QAndroidJniObject::callStaticMethod<void>("net/gcompris/GComprisActivity",
                                                  "buyGCompris");
    } else {
        // Going back to demo mode, should never happens except for testing
        ApplicationSettings::getInstance()->bought(false);
    }
}

void ApplicationSettings::checkPayment() {
#if defined(WITH_ACTIVATION_CODE)
    QAndroidJniObject::callStaticMethod<void>("net/gcompris/GComprisActivity",
                                              "checkPayment");
#endif
}

uint ApplicationSettings::checkActivationCode(const QString &code) {
    // Not used in inapp mode.
    return 0;
}

static void bought(JNIEnv *, jclass /*clazz*/, jboolean b)
{
    ApplicationSettings::getInstance()->bought(b);
}

static JNINativeMethod methods[] = {
    {"bought", "(Z)V", (void *)bought}
};

bool ApplicationInfo::requestAudioFocus() const
{
  qDebug() << "requestAudioFocus";
  return QAndroidJniObject::callStaticMethod<jboolean>("net/gcompris/GComprisActivity",
						       "requestAudioFocus");
}

void ApplicationInfo::abandonAudioFocus() const
{
  QAndroidJniObject::callStaticMethod<void>("net/gcompris/GComprisActivity",
                                            "abandonAudioFocus");
}

jint JNICALL JNI_OnLoad(JavaVM *vm, void *)
{
    JNIEnv *env;
    if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_4) != JNI_OK)
        return JNI_FALSE;

    jclass clazz = env->FindClass("net/gcompris/GComprisActivity");
    if (env->RegisterNatives(clazz, methods, sizeof(methods) / sizeof(methods[0])) < 0)
        return JNI_FALSE;

    return JNI_VERSION_1_4;
}

void ApplicationInfo::setRequestedOrientation(int orientation)
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setRequestedOrientation", "(I)V", orientation);
}

int ApplicationInfo::getRequestedOrientation()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    jint orientation = activity.callMethod<jint>("getRequestedOrientation");
    return orientation;
}

void ApplicationInfo::setKeepScreenOn(bool value)
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    activity.callMethod<void>("setKeepScreenOn", "(Z)V", value);
}

int ApplicationInfo::localeCompare(const QString& a, const QString& b,
                                   const QString& locale) const
{
    QString _locale = locale.isEmpty() ? \
                          ApplicationSettings::getInstance()->locale() \
                        : locale;
    if (_locale == GC_DEFAULT_LOCALE)
        _locale = QLocale::system().name();

    // QCollator on Android uses only the posix backend as of Qt 5.5.1,
    // which is not capable of doing locale aware comparison.
    // cf. https://bugreports.qt.io/browse/QTBUG-43637
    // Therefore use native Collation via jni:
    jint res = QtAndroid::androidActivity().callMethod<jint>(
                   "localeCompare",
                   "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I",
                   QAndroidJniObject::fromString(a).object<jstring>(),
                   QAndroidJniObject::fromString(b).object<jstring>(),
                   QAndroidJniObject::fromString(_locale).object<jstring>());
    return res;
}
