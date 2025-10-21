/* GCompris - UndoStack.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtCore
import core 1.0

Item {
    required property var canvas        // Canvas where drawing is done
    required property var image         // Offscreen image to store and restore canvas
    required property string filePrefix
    readonly property url tempFile: StandardPaths.writableLocation(StandardPaths.TempLocation) + filePrefix // Image file prefix, adds index and ".png"
    property alias undoCount: undoModel.count
    property alias redoCount: redoModel.count
    property string lastSavedFile: ""
    property bool isFileSaved: true

    function clear() {                  // Reset models and undoIndex
        clearModel(undoModel)
        clearModel(redoModel)
        isFileSaved = true
    }

    function undoLast() {               // Push last undoModel data to redoModel. Returns data to restore
        if (undoCount < 1) return                   // Exit on empty stack, saving first data
        isFileSaved = false
        pushModel(redoModel, popModel(undoModel))   // move top element to redoModel
        return undoModel.get(undoCount - 1)
    }

    function redoLast() {               // Push last redoModel data to undoModel. Returns data to restore
        if (redoCount < 1) return                   // Exit on empty stack, should never happen
        isFileSaved = false
        var todo = popModel(redoModel)
        pushModel(undoModel, todo)
        lastSavedFile = todo.savedFile              // Remember last saved file's name
        return todo
    }

    function pushData(data, withImage = false) {    // Push new data to undoModel. Copy canvas to image and conditionally save image.
        var savedFile = lastSavedFile
        if (withImage) {
            savedFile = tempFile + undoIndex.toString() + ".png"
            canvas.grabToImage(function(result) {   // Copy canvas to image
                image.source = result.url
                result.saveToFile(savedFile)        // Save image into file
            }, Qt.size(canvas.width, canvas.height))
            undoIndex++
            lastSavedFile = savedFile
            isFileSaved = undoCount < 1
        }
        data.savedFile = savedFile
        pushModel(undoModel, data)
        clearModel(redoModel)                   // redoModel is cleared
        while (undoCount > 40) {                // Limited undo stack length
            var todo = shiftModel(undoModel)
            if (todo.savedFile !== "")
                file.rmpath(todo.savedFile)     // remove undo files on disk
        }
    }

    function getLastStacked() {             // Get data from undoModel last element
        return undoModel.get(undoCount - 1)
    }

    function setLastStacked(data) {         // Set data from undoModel last element
        undoModel.set(undoCount - 1, data)
    }

    // Following properties and functions don't need to be called from outer code (private)
    property int undoIndex: 0

    File { id: file }
    ListModel { id: undoModel }
    ListModel { id: redoModel }

    function clearModel(model) {            // Clear model and image files
        while (model.count){
            var todo = popModel(model)
            if (todo.savedFile !== "")
                file.rmpath(todo.savedFile) // Remove undo files on disk
        }
    }

    function pushModel(model, data) {       // Push data into model (undoModel or redoModel)
        model.append(data)
    }

    function popModel(model) {
        var data = JSON.parse(JSON.stringify(model.get(model.count - 1)))   // Clone data before removing
        model.remove(model.count - 1)
        return data
    }

    function shiftModel(model) {
        var data = JSON.parse(JSON.stringify(model.get(0)))                 // Clone data before removing
        model.remove(0)
        return data
    }
}
