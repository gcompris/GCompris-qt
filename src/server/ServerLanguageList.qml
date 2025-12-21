/* GCompris - ServerLanguageList.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

/**
 * Container object with a list of all available translations.
 * @ingroup infrastructure
 *
 * Put here the locales for which we have a good enough translation.
 */
QtObject {
    /**
     * type:list
     * List of language objects.
     *
     * A language object consists of the properties @c text (language string in
     * the locales' language) and @c locale (locale string of the form
     * aa_AA.UTF-8).
     *
     * The special purpose locale 'system' is used to refer to the system's
     * standard locale.
     */
    property var languages: [
            { "text": qsTr("Your system default"), "locale": "system" },
            { "text": "American English", "locale": "en_US.UTF-8" },
        ]
}
