/* GCompris - ApplicationSettingsAndroid.cpp
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

#include "ApplicationSettings.h"
#include <QtAndroidExtras/QAndroidJniObject>
#include <QDebug>

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
    QAndroidJniObject::callStaticMethod<void>("net/gcompris/GComprisActivity",
                                              "checkPayment");
}

static void bought(JNIEnv *, jclass /*clazz*/, jboolean b)
{
    ApplicationSettings::getInstance()->bought(b);
}

static JNINativeMethod methods[] = {
    {"bought", "(Z)V", (void *)bought}
};

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
