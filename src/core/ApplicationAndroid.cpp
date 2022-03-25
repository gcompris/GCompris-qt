/* GCompris - ApplicationAndroid.cpp
 *
 * SPDX-FileCopyrightText: 2014-2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "ApplicationSettings.h"
#include "ApplicationInfo.h"
#include <QAndroidJniObject>
#include <QDebug>
#include <QtAndroid>

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

int ApplicationInfo::localeCompare(const QString &a, const QString &b,
                                   const QString &locale) const
{
    QString _locale = locale.isEmpty() ? ApplicationSettings::getInstance()->locale()
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

// Code adapted from https://bugreports.qt.io/browse/QTBUG-50759
bool ApplicationInfo::checkPermissions() const
{
    const QStringList permissionsRequest = QStringList(
        { QString("android.permission.READ_EXTERNAL_STORAGE"),
          QString("android.permission.WRITE_EXTERNAL_STORAGE") });
    /* clang-format off */
    if ((QtAndroid::checkPermission(permissionsRequest[0]) == QtAndroid::PermissionResult::Denied) ||
        (QtAndroid::checkPermission(permissionsRequest[1])) == QtAndroid::PermissionResult::Denied) {
        /* clang-format on */
        auto permissionResults = QtAndroid::requestPermissionsSync(permissionsRequest);
        for (const QString &permission: permissionsRequest) {
            if (permissionResults[permission] == QtAndroid::PermissionResult::Denied) {
                qDebug() << "Permission denied for" << permission;
                return false;
            }
        }
    }
    return true;
}
