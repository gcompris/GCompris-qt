/* GCompris - GCText.qml
 *
 * SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0
import "."

/**
 * A QML component unifying text presentation in GCompris.
 * @ingroup components
 *
 * GCText wraps QtQuick's Text to provide
 *
 * (1) a uniform font-family,<br/>
 * (2) DPI based automatic font-scaling and<br/>
 * (3) application-wide manual font-sizing.<br/>
 *
 * Activities should almost always use the @ref fontSize property to
 * define font sizes, it implements both (2) and (3). <b>Do not</b> set
 * @c font.pointSize directly, or GCText's automatic scaling will be
 * deactivated. If you really need to enforce a fixed font size (which
 * might be the case for dialogs) use the fixFontSize property.
 *
 * The xxxSize properties are meant to be enum-like values for often needed
 * font sizes. (QtQuick does not support enum definitions on QML layer, cf.
 * Qt issue #14861.)
 *
 * @inherit QtQuick.Text
 * @sa GCSingletonFontLoader
 */
Text {
    /**
     * type:int
     * Tiny font-size.
     * Value: 10
     */
    readonly property int tinySize:     10.0

    /**
     * type:int
     * Small font-size.
     * Value: 12
     */
    readonly property int smallSize:    12.0

    /**
     * type:int
     * Regular font-size.
     * Value: 14
     */
    readonly property int regularSize:  14.0

    /**
     * type:int
     * Medium font-size.
     * Value: 16
     */
    readonly property int mediumSize:   16.0

    /**
     * type:int
     * Large font-size.
     * Value: 24
     */
    readonly property int largeSize:    24.0

    /**
     * type:int
     * Huge font-size.
     * Value: 32
     */
    readonly property int hugeSize:     32.0

    /**
     * type:bool
     * Whether to not apply ApplicationSettings.baseFontSize.
     *
     * Set to true if you don't want to scale fonts. Used in some rare cases
     * like for dialogs.
     */
    property bool fixFontSize: false

    /**
     * type:int
     * Font size wrapping font.pointSize and applying font-scaling.
     *
     * Font-sizes are best specified using the fontSize property, which
     * wraps font.pointSize to take the DPI of the display into account.
     * If font.pointSize is used directly text might appear to small on some
     * devices.
     *
     * If you really need to specify font.pixelSize instead of pointSize,
     * you need to clear font.pointSize explicitly with NaN:
     *
     * @code
     * font.pointSize: NaN
     * @endcode
     *
     * Default is 14.
     */
    property int fontSize: 14

    /**
     * type:int
     * Read only value of the calculated pointSize
     */
    readonly property int pointSize: font.pointSize

    font.pointSize: ((fixFontSize ? 0 : ApplicationSettings.baseFontSize)
                      + fontSize) * ApplicationInfo.fontRatio
    font.family: GCSingletonFontLoader.fontLoader.name
    font.capitalization: ApplicationSettings.fontCapitalization
    font.letterSpacing: ApplicationSettings.fontLetterSpacing
    color: "#191919"
}
