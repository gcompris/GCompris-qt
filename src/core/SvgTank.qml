/* GCompris - SvgTank.qml
 *
 * SPDX-FileCopyrightText: 2026 Bruno Anselme <be.root@free.fr>
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
 * References :
 *   https://stackoverflow.com/questions/5736398/how-to-calculate-the-svg-path-for-an-arc-of-a-circle
 */
import QtQuick
import core 1.0

Item {
    id: svgTank
    property string fileName: 'svgtank.svg' // Should be overloaded by activity
    property bool autoSave: false           // Save file after each change. Set to true if needed by activity or for debug
    property int precision: 3

    readonly property string svgProtocol: `data:image/svg+xml;utf8,`
    readonly property string xmlHeader: `<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n`
    readonly property string svgFooter: `\n</svg>`
    property string svgHeader: `<svg viewBox="${svgOrigin.x} ${svgOrigin.y} ${svgWidth} ${svgHeight} " width="${Math.ceil(svgWidth)}" height="${Math.ceil(svgHeight)}" version="1.1" xmlns="http://www.w3.org/2000/svg">\n`

    property real svgWidth: 100
    property real svgHeight: 100
    property string source: ""
    property string path:""
    property string strokeColor: "black"
    property real strokeWidth: 2
    property real arcStrokeWidth: Math.max(2, strokeWidth)  // arcs with stroke less than 2 may not be rendered correctly by some renderers
    property string lineCap: "round"
    property string lineJoin: "round"
    property string fillColor: "none"
    property string svgDash: ""
    property real svgDashOffset: 0
    property real svgOpacity: 1.0
    property bool svgCentered: false
    property point svgOrigin: svgCentered ? Qt.point(-svgWidth / 2, -svgHeight / 2) : Qt.point(0, 0)
    property string backColor: "#ffffff"

    property var svgUndoStack: []
    property var svgRedoStack: []

    visible: false

    File { id: file }

    onWidthChanged: if (autoSave) writeSvg()
    onHeightChanged: if (autoSave) writeSvg()
    onBackColorChanged: if (autoSave) writeSvg()

    function resetSvg(width_, height_, color_, centered_ = false) {
        svgCentered = centered_
        svgWidth = width_
        svgHeight = height_
        source = ""
        path = ""
        fillColor = "none"
        backColor = color_
        svgUndoStack = []
        svgRedoStack = []
        if (autoSave) writeSvg()
    }

    function loadSvg(data_, centered_, rescale_ = false) {  // warning: centered_ and rescale_ have never been tested together
        svgCentered = centered_
        path = ""
        svgUndoStack = []
        svgRedoStack = []

        source = data_.replace(/<\?xml[^>]*>\s*<svg[^>]*>/gmi, "").replace(/<\/svg>/gi, "").trim()  // Extract svg source
        var found = data_.match(new RegExp(/<svg[^>]*>/gm))   // Extract svg header
        if (found) {
            let header = found[0]
            found  = header.match(new RegExp(/width=\"\s*([-\d\.]+)\s*\"/i))
            if (found) {
                let width = null
                width = Number(found[1])        // extract width
                found  = header.match(new RegExp(/height=\"\s*([-\d\.]+)\s*\"/i))
                if (found) {
                    let height = null
                    let viewBox = null
                    height = Number(found[1])   // extract height
                    found = header.match(new RegExp(/viewBox=\"\s*([-\d\.]+)\s*([-\d\.]+)\s*([-\d\.]+)\s*([-\d\.]+)\s*\"/i))
                    if (found)                  // extract viewBox
                        viewBox = found.slice(-(found.length - 1)).map(Number)
                    else
                        viewBox = [0, 0, width, height]
                    // Recenter loaded svg to current drawing.
                    if (svgCentered) {
                        const dx = (viewBox[2] / 2) + viewBox[0]
                        const dy = (viewBox[3] / 2) + viewBox[1]
                        if (dx || dy)
                            source = `<g transform="translate(${-dx} ${-dy})">\n${source}\n</g>`
                    }
                    // Rescale loaded svg
                    if (rescale_) {
                        if ((width !== svgWidth) || (height !== svgHeight)) {
                            const sizeX = svgWidth / width
                            const sizeY = svgHeight / height
                            source = `<g transform="scale(${sizeX} ${sizeY})">\n${source}\n</g>`
                        }
                    }
                }
            }
        }
        if (autoSave) writeSvg()
    }

    function getSource() {
        return `${xmlHeader}${svgHeader}${background()}${source}${svgUndoStack.join('\n')}${svgFooter}`
    }

    function writeSvg() {
        file.write(getSource(), fileName)
    }

    // undo stacks management
    function undo() {
        if (svgUndoStack.length) {
            svgRedoStack.push(svgUndoStack.pop())
            if (autoSave) writeSvg()
        }
    }

    function redo() {
        if (svgRedoStack.length) {
            svgUndoStack.push(svgRedoStack.pop())
            if (autoSave) writeSvg()
        }
    }

    // Functions adding to path
    function openPath(x, y) {
        path = `M ${x.toFixed(precision)} ${y.toFixed(precision)}`
    }

    function openEmptyPath() {
        path = ``
    }

    function moveTo(x, y) {
        path += ` M ${x.toFixed(precision)} ${y.toFixed(precision)}`
    }

    function addLine(x, y) {
        path += ` L ${x.toFixed(precision)} ${y.toFixed(precision)}`
    }

    function addQuadratic(x1, y1, x, y) {
        path += ` Q ${x1.toFixed(precision)} ${y1.toFixed(precision)}, ${x.toFixed(precision)} ${y.toFixed(precision)}`
    }

    function finishPath() {
        path += ` Z`
    }

    function addArc(x, y, radius, startAngle, endAngle){
        const start = polarToCartesian(x, y, radius, endAngle)
        const end = polarToCartesian(x, y, radius, startAngle)
        const largeArcFlag = endAngle - startAngle <= 180 ? "0" : "1"
        path += [
            "M", start.x.toFixed(precision), start.y.toFixed(precision),
            "A", radius.toFixed(precision), radius.toFixed(precision), 0, largeArcFlag, 0, end.x.toFixed(precision), end.y.toFixed(precision)
        ].join(" ")
        if (autoSave) writeSvg()
    }

    function addSlice(x, y, radius, spread, startAngle, endAngle){
        const innerStart = polarToCartesian(x, y, radius, endAngle)
        const innerEnd = polarToCartesian(x, y, radius, startAngle)
        const outerStart = polarToCartesian(x, y, radius + spread, endAngle)
        const outerEnd = polarToCartesian(x, y, radius + spread, startAngle)
        const largeArcFlag = endAngle - startAngle <= 180 ? "0" : "1"
        path += [
            "M", outerStart.x.toFixed(precision), outerStart.y.toFixed(precision),
            "A", (radius + spread).toFixed(precision), (radius + spread).toFixed(precision), 0, largeArcFlag, 0, outerEnd.x.toFixed(precision), outerEnd.y.toFixed(precision),
            "L", innerEnd.x.toFixed(precision), innerEnd.y.toFixed(precision),
            "A", radius.toFixed(precision), radius.toFixed(precision), 0, largeArcFlag, 1, innerStart.x.toFixed(precision), innerStart.y.toFixed(precision),
            "L", outerStart.x.toFixed(precision), outerStart.y.toFixed(precision), "Z"
        ].join(" ")
        if (autoSave) writeSvg()
    }

    function closePath() {
        svgUndoStack.push(`<path d="${path}" style="fill:${fillColor};stroke:${strokeColor};stroke-width:${strokeWidth};opacity:${svgOpacity.toFixed(precision)};stroke-linecap:${lineCap};stroke-linejoin:${lineJoin};stroke-dasharray:${svgDash};"/>`)
        path = ""
        svgRedoStack = []      // redo stack is cleared when a new path is pushed
        if (autoSave) writeSvg()
    }

    // Functions writing SVG
    function background() {
        return `<rect x="${Math.ceil(svgOrigin.x)}" y="${Math.ceil(svgOrigin.y)}" width="${Math.ceil(svgWidth)}" height="${Math.ceil(svgHeight)}" style="fill:${backColor};stroke:none;" />\n`
    }

    function clear(color) { // fill background
        source += `<rect x="${Math.ceil(svgOrigin.x)}" y="${Math.ceil(svgOrigin.y)}" width="${Math.ceil(svgWidth)}" height="${Math.ceil(svgHeight)}" style="fill:${color};stroke:none;" />\n`
        if (autoSave) writeSvg()
    }

    function rectangle(w, h, color) {
        svgUndoStack.push(`<rect x="0" y="0" width="${w}" height="${h}" style="fill:${color};stroke:none;" />`)
        if (autoSave) writeSvg()
    }

    function addCircle(cx, cy, r) {
        svgUndoStack.push(`<circle cx="${cx.toFixed(precision)}" cy="${cy.toFixed(precision)}" r="${r}" style="fill:${fillColor};stroke:${strokeColor};stroke-width:${strokeWidth};stroke-dasharray:${svgDash};opacity:${svgOpacity};" />`)
        if (autoSave) writeSvg()
    }

    function addArcSegment(cx, cy, r, minAngle, maxAngle) { // Draw en arc segment as a dashed circle
        var dash = ""
        var dashOffset = 0
        const angle = maxAngle - minAngle
        var circumference = circumference = 2 * Math.PI * r
        if (angle < 360) {
            const segLength = angle ? circumference * angle / 360 : 1   // Will plot a single dot when angle == 0
            const segRemain = circumference - segLength
            dash = `${segLength.toFixed(precision)} ${segRemain.toFixed(precision)}`
            dashOffset = -(circumference * minAngle / 360).toFixed(precision)
        }
        if (circumference < 1)  // Special case to draw a single dot when tip and pen are at the same position (filled circle)
            svgUndoStack.push(`<circle cx="${cx.toFixed(precision)}" cy="${cy.toFixed(precision)}" r="${arcStrokeWidth / 2}" style="fill:${strokeColor};stroke:none;stroke-width:0;opacity:${svgOpacity.toFixed(precision)};" />`)
        else
            svgUndoStack.push(`<circle cx="${cx.toFixed(precision)}" cy="${cy.toFixed(precision)}" r="${r.toFixed(precision)}" style="fill:${fillColor};stroke:${strokeColor};stroke-width:${arcStrokeWidth};stroke-dasharray:${dash};stroke-dashoffset:${dashOffset};stroke-linecap:round;opacity:${svgOpacity.toFixed(precision)};" />`)
        if (autoSave) writeSvg()
    }

    function addCross(cx, cy, r) {
        openPath(cx - r, cy - r)
        addLine(cx + r, cy + r)
        moveTo(cx + r, cy - r)
        addLine(cx - r, cy + r)
        closePath()
    }

    // Math function
    function polarToCartesian(centerX, centerY, radius, angleInDegrees) {
      const angleInRadians = (angleInDegrees - 90) * Math.PI / 180.0
      return {
        x: centerX + (radius * Math.cos(angleInRadians)),
        y: centerY + (radius * Math.sin(angleInRadians))
      }
    }
}
