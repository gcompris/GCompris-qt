/* GCompris - LanguageList.qml
 *
 * SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12

/**
 * Container object with a list of all available translations.
 * @ingroup infrastructure
 *
 * Put here the locales for which we have a good enough translation.
 */
QtObject {
    property bool inMenu: false

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
            { "text": inMenu ? qsTr("Your system default") : qsTr("GCompris' language"), "locale": "system" },
            { "text": "UK English", "locale": "en_GB.UTF-8" },
            { "text": "American English", "locale": "en_US.UTF-8" },
            { "text": "العربية", "locale": "ar_AR.UTF-8" },
            { "text": "Azərbaycanca", "locale": "az_AZ.UTF-8" },
            //{ "text": "български", "locale": "bg_BG.UTF-8" },
            { "text": "Brezhoneg", "locale": "br_FR.UTF-8" },
            { "text": "Беларуская", "locale": "be_BY.UTF-8" },
            { "text": "Català", "locale": "ca_ES.UTF-8" },
            { "text": "Valencian", "locale": "ca@valencia_ES.UTF-8" },
            { "text": "Česká", "locale": "cs_CZ.UTF-8" },
            //{ "text": "Dansk", "locale": "da_DK.UTF-8" },
            { "text": "Deutsch", "locale": "de_DE.UTF-8" },
            { "text": "Ελληνικά", "locale": "el_GR.UTF-8" },
            { "text": "Esperanto", "locale": "eo_EO.UTF-8" },
            { "text": "Español", "locale": "es_ES.UTF-8" },
            { "text": "Eesti", "locale": "et_EE.UTF-8" },
            { "text": "Euskara", "locale": "eu_ES.UTF-8" },
            { "text": "Suomi", "locale": "fi_FI.UTF-8" },
            { "text": "Français", "locale": "fr_FR.UTF-8" },
            //{ "text": "Gaeilge", "locale": "ga_IE.UTF-8" },
            //{ "text": "Gàidhlig", "locale": "gd_GB.UTF-8" },
            //{ "text": "Galego", "locale": "gl_ES.UTF-8" },
            { "text": "עברית", "locale": "he_IL.UTF-8" },
            //{ "text": "हिन्दी", "locale": "hi_IN.UTF-8" },
            { "text": "Hrvatski", "locale": "hr_HR.UTF-8" },
            { "text": "Magyar", "locale": "hu_HU.UTF-8" },
            { "text": "Indonesia", "locale": "id_ID.UTF-8" },
            { "text": "Italiano", "locale": "it_IT.UTF-8" },
            { "text": "Lietuvių", "locale": "lt_LT.UTF-8" },
            //{ "text": "Latviešu", "locale": "lv_LV.UTF-8" },
            { "text": "Македонски", "locale": "mk_MK.UTF-8" },
            { "text": "മലയാളം", "locale": "ml_IN.UTF-8" },
            { "text": "Nederlands", "locale": "nl_NL.UTF-8" },
            { "text": "Norsk (nynorsk)", "locale": "nn_NO.UTF-8" },
            { "text": "Polski", "locale": "pl_PL.UTF-8" },
            { "text": "Português", "locale": "pt_PT.UTF-8" },
            { "text": "Português do Brasil", "locale": "pt_BR.UTF-8" },
            { "text": "Română", "locale": "ro_RO.UTF-8" },
            { "text": "Русский", "locale": "ru_RU.UTF-8" },
            { "text": "Slovenský", "locale": "sk_SK.UTF-8" },
            { "text": "Slovenski", "locale": "sl_SI.UTF-8" },
            { "text": "Shqip", "locale": "sq_AL.UTF-8" },
            //{ "text": "црногорски jeзик", "locale": "sr_ME.UTF-8" },
            { "text": "Svenska", "locale": "sv_FI.UTF-8" },
            { "text": "Kiswahili", "locale": "sw_TZ.UTF-8" },
            //{ "text": "தமிழ்", "locale": "ta_IN.UTF-8" },
            //{ "text": "ไทย", "locale": "th_TH.UTF-8" },
            { "text": "Türkçe", "locale": "tr_TR.UTF-8" },
            { "text": "Українська", "locale": "uk_UA.UTF-8" },
            //{ "text": "中文（简体）", "locale": "zh_CN.UTF-8" },
            { "text": "繁體中文", "locale": "zh_TW.UTF-8" }
        ]
}
