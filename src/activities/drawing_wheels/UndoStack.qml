/* GCompris - UndoStack.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtCore
import core 1.0

Item {
    property alias undoCount: undoModel.count
    property alias redoCount: redoModel.count
    property int maxUndo: 10
    readonly property int maxUndoStored: maxUndo + 1 // max undo stored can always be maxUndo + 1 for current state

    function clear() {                  // Reset models and undoIndex
        undoModel.clear()
        redoModel.clear()
    }

    function undoLast() {               // Push last undoModel data to redoModel. Returns data to restore
        if (undoCount < 1) return                   // Exit on empty stack, saving first data
        pushModel(redoModel, popModel(undoModel))   // move top element to redoModel
        return undoModel.get(undoCount - 1)
    }

    function redoLast() {               // Push last redoModel data to undoModel. Returns data to restore
        if (redoCount < 1) return                   // Exit on empty stack, should never happen
        var todo = popModel(redoModel)
        pushModel(undoModel, todo)
        return todo
    }

    function pushData(data) {    // Push new data to undoModel
        pushModel(undoModel, data)
        redoModel.clear();                   // redoModel is cleared
        while (undoCount > maxUndoStored) {    // Limited undo stack length
            var todo = shiftModel(undoModel)
        }
    }

    function getLastStacked() {             // Get data from undoModel last element
        return undoModel.get(undoCount - 1)
    }

    function setLastStacked(data) {         // Set data from undoModel last element
        undoModel.set(undoCount - 1, data)
    }

    // Following items and functions don't need to be called from outer code (private)

    File { id: file }

    ListModel { id: undoModel }

    ListModel { id: redoModel }

    // Same logic as in GImageGrabber.cpp setMaxUndo(), to sync undo/redo content of both stacks
    onMaxUndoStoredChanged: {
        // if undoList has more than maxUndoStored, remove extra undo saved
        if(undoCount > maxUndoStored) {
            var difference = undoCount - maxUndoStored;
            undoModel.remove(0, difference);
        }
        // if (undoList + redoList) has more than maxUndoStored, remove extra redo saved
        var totalSaved = undoCount + redoCount;
        if(totalSaved > maxUndoStored) {
            var difference = totalSaved - maxUndoStored;
            redoModel.remove(0, difference);
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
