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
#include <QJniObject>
#include <QCoreApplication>
#include <QDebug>

#include <QtCore/private/qandroidextras_p.h>

bool ApplicationInfo::requestAudioFocus() const
{
    qDebug() << "requestAudioFocus";
    return QJniObject::callStaticMethod<jboolean>("net/gcompris/GComprisActivity",
                                                         "requestAudioFocus");
}

void ApplicationInfo::abandonAudioFocus() const
{
    QJniObject::callStaticMethod<void>("net/gcompris/GComprisActivity",
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
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    activity.callMethod<void>("setRequestedOrientation", "(I)V", orientation);
}

int ApplicationInfo::getRequestedOrientation()
{
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    jint orientation = activity.callMethod<jint>("getRequestedOrientation");
    return orientation;
}

void ApplicationInfo::setKeepScreenOn(bool value)
{
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
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
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    jint res = activity.callMethod<jint>(
        "localeCompare",
        "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I",
        QJniObject::fromString(a).object<jstring>(),
        QJniObject::fromString(b).object<jstring>(),
        QJniObject::fromString(_locale).object<jstring>());
    return res;
}

// Code adapted from https://bugreports.qt.io/browse/QTBUG-50759
bool ApplicationInfo::checkPermissions() const
{
    const QStringList permissionsRequest = QStringList(
        { QString("android.permission.READ_EXTERNAL_STORAGE"),
          QString("android.permission.WRITE_EXTERNAL_STORAGE") });
    /* clang-format off */
    if ((QtAndroidPrivate::checkPermission(permissionsRequest[0]).result() == QtAndroidPrivate::Denied) ||
        (QtAndroidPrivate::checkPermission(permissionsRequest[1])).result() == QtAndroidPrivate::Denied) {
        /* clang-format on */
        for (const QString &permission: permissionsRequest) {
            auto permissionResult = QtAndroidPrivate::requestPermission(permission).result();
            if (permissionResult == QtAndroidPrivate::Denied) {
                qDebug() << "Permission denied for" << permission;
                return false;
            }
        }
    }
    return true;
}
