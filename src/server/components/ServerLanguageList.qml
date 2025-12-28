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
            { "text": "العربية", "locale": "ar_AR.UTF-8" },
            { "text": "български", "locale": "bg_BG.UTF-8" },
            { "text": "Català", "locale": "ca_ES.UTF-8" },
            { "text": "Valencian", "locale": "ca@valencia_ES.UTF-8" },
            { "text": "Español", "locale": "es_ES.UTF-8" },
            { "text": "Euskara", "locale": "eu_ES.UTF-8" },
            { "text": "Français", "locale": "fr_FR.UTF-8" },
            { "text": "ქართული", "locale": "ka_GE.UTF-8" },
            { "text": "Nederlands", "locale": "nl_NL.UTF-8" },
            { "text": "Português do Brasil", "locale": "pt_BR.UTF-8" },
            { "text": "Slovenski", "locale": "sl_SI.UTF-8" },
            { "text": "Türkçe", "locale": "tr_TR.UTF-8" },
            { "text": "Українська", "locale": "uk_UA.UTF-8" }
        ]
}
