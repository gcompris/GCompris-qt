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
import GCompris 1.0

//QTBUG-34418, singletons require explicit import to load qmldir file
//https://qt-project.org/wiki/QmlStyling#6b81104b320e452a59cc3bf6857115ab
import "."

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
    property QtObject fontLoader: ApplicationSettings.isEmbeddedFont ? sourceLoader : nameLoader

    property QtObject fontSourceLoader: FontLoader {
        id: sourceLoader
        source: ApplicationSettings.isEmbeddedFont ? "resource/fonts/"+ApplicationSettings.font : ""
    }

    property QtObject fontNameLoader: FontLoader {
        id: nameLoader
        name: ApplicationSettings.font
    }

}
