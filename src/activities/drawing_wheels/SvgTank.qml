/* GCompris - SvgTank.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * Simple svg tank. Reset it, open path, add line or curve and close path. Write to svg file.
 * Easily extendable to other svg element (rect, ellipse etc.)
 * Undo and redo stack.
 *
 */
import QtQuick
import core 1.0

Item {
    id: svgTank
    property string fileName: 'svgtank.svg'
    readonly property string svgProtocol: `data:image/svg+xml;utf8,`
    readonly property string xmlHeader: `<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n`
    readonly property string svgFooter: `</svg>`
    property string svgHeader: `<svg width="${Math.ceil(svgSize)}" height="${Math.ceil(svgSize)}" version="1.1" xmlns="http://www.w3.org/2000/svg">\n`
    property real svgSize: 100

    property string source: ""
    property string path:""
    property string stroke: "black"
    property real strokeWidth: 1
    property string fill: "none"
    property real svgOpacity: 1.0

    property var undoStack: []
    property var redoStack: []

    visible: false

    File { id: file }

    function resetSvg(width_, color_) {
        svgSize = width_
        source = ""
        path = ""
        fill = "none"
        clear(color_)
        undoStack = []
        redoStack = []
    }

    function loadSvg(svgData) {
        // Find width of loaded file, calculate scale compared to current size, then apply group with transform.
        // index of first width=", which should be of main svg tag
        var widthStartIndex = svgData.search(`width="`)
        var widthEndIndex = svgData.indexOf(`"`, widthStartIndex + 7)
        var oldSize = parseInt(svgData.substring(widthStartIndex + 7, widthEndIndex))
        if(oldSize != svgSize) {
            var sizeScale = svgSize / oldSize
            source = `<g transform="scale(${sizeScale})">`
            source += svgData.replace(/<\?xml[^>]*><svg[^>]*>(.*)<\/svg>/g, "$1")
            source += `</g>`
        } else {
            source = svgData.replace(/<\?xml[^>]*><svg[^>]*>(.*)<\/svg>/g, "$1")
        }
        path = ""
        undoStack = []
        redoStack = []
        writeSvg()
    }

    function undo() {
        if (undoStack.length)
            redoStack.push(undoStack.pop())
    }

    function redo() {
        if (redoStack.length)
            undoStack.push(redoStack.pop())
    }

    function clear(color) { // fill background
        source += `<rect x="0" y="0" width="${Math.ceil(svgSize)}" height="${Math.ceil(svgSize)}" style="fill:${color};stroke:none;" />\n`
    }

    function rectangle(w, h, color) {
        undoStack.push(`<rect x="0" y="0" width="${w}" height="${h}" style="fill:${color};stroke:none;" />`)
    }

    function openPath(x, y) {
        path = `M ${x.toFixed(3)} ${y.toFixed(3)}`
    }

    function addLine(x, y) {
        path += ` L ${x.toFixed(3)} ${y.toFixed(3)}`
    }

    function addQuadratic(x1, y1, x, y) {
        path += ` Q ${x1.toFixed(3)} ${y1.toFixed(3)}, ${x.toFixed(3)} ${y.toFixed(3)}`
    }

    function closePath() {
        path += ` Z`
    }

    function finishPath() {
        undoStack.push(`<path d="${path}" style="fill:${fill};stroke:${stroke};stroke-width:${strokeWidth};opacity:${svgOpacity};stroke-linecap:round;stroke-linejoin:round;"/>\n`)
        path = ""
        redoStack = []      // redo stack is cleared when a new path is pushed
    }

    function getSource() {
        return `${xmlHeader}${svgHeader}${source}${undoStack.join('\n')}${svgFooter}`
    }

    function writeSvg() {
        file.write(getSource(), fileName)
    }
}
