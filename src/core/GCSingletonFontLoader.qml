/* GCompris - GCSingletonFontLoader.qml
 *
 * SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

// FIXME: this triggers a doxygen error, why?
pragma Singleton

/**
 * A QML singleton helper to load currently active font based on current font
 * settings
 * @ingroup infrastructure
 *
 * @inherit QtQuick.QtObject
 * @sa ApplicationSettings.isEmbeddedFont, ApplicationSettings.font
 */
QtObject {
    property QtObject fontLoader: FontLoader {
        id: sourceLoader
        // Set default embedded font name to avoid FontLoader.Error
        source: "resource/fonts/Andika-R.ttf"
    }
    // Using direct binding for fontLoader source can cause errors as font and isEmbeddedFont values change one after the other...
    // Setting the value on signal trigger avoid errors.
    property string appSettingsFont: ApplicationSettings.font
    onAppSettingsFontChanged: {
        sourceLoader.source =  "resource/fonts/" + (ApplicationSettings.isEmbeddedFont ? appSettingsFont : "Andika-R.ttf")
    }

    property string fontName: ApplicationSettings.isEmbeddedFont ? fontLoader.name : ApplicationSettings.font
}
