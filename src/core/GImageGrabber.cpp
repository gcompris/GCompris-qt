/* GCompris - GImageGrabber.cpp
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include "GImageGrabber.h"
#include <QQuickItemGrabResult>

GImageGrabber::GImageGrabber(QQuickItem *parent) :
    QQuickItem(parent)
{
}

int GImageGrabber::maxUndo() const
{
    return m_maxUndo;
}

void GImageGrabber::setMaxUndo(const int &maxValue)
{
    int value = maxValue;
    if(value < 0) {
        value = 0;
    }
    m_maxUndo = value;
    Q_EMIT maxUndoChanged();
}

int GImageGrabber::undoSize() const
{
    return m_undoSize;
}

void GImageGrabber::setUndoSize(const int &listSize)
{
    m_undoSize = listSize;
    Q_EMIT undoSizeChanged();
}

int GImageGrabber::redoSize() const
{
    return m_redoSize;
}

void GImageGrabber::setRedoSize(const int &listSize)
{
    m_redoSize = listSize;
    Q_EMIT redoSizeChanged();
}

void GImageGrabber::safeGrab(const QSize &targetSize)
{

    grabbedResult = GImageGrabber::grabToImage(targetSize);
    pushToUndo(grabbedResult);

    const QQuickItemGrabResult* rawPtr = grabbedResult.data();
    QObject::connect(rawPtr, &QQuickItemGrabResult::ready, this, &GImageGrabber::grabReady);
}

void GImageGrabber::saveToFile(const QUrl &filePath)
{
    grabbedResult->saveToFile(filePath);
}

QUrl GImageGrabber::getImageUrl()
{
    return grabbedResult->url();
}

void GImageGrabber::doUndo()
{
    // 1st element of the list is always last possible state, never undo it
    if(undoList.size() > 1) {
        redoList.append(undoList.takeAt(undoList.size() - 1));
        grabbedResult = undoList.at(undoList.size() - 1);
        setUndoSize(undoList.size());
        setRedoSize(redoList.size());
    }
}

void GImageGrabber::doRedo()
{
    if(redoList.size() > 0) {
        undoList.append(redoList.takeAt(redoList.size() - 1));
        grabbedResult = undoList.at(undoList.size() - 1);
        setUndoSize(undoList.size());
        setRedoSize(redoList.size());
    }
}

void GImageGrabber::clearUndo()
{
    undoList.clear();
    setUndoSize(undoList.size());
}

void GImageGrabber::clearRedo()
{
    redoList.clear();
    setRedoSize(redoList.size());
}

void GImageGrabber::pushToUndo(const QSharedPointer<QQuickItemGrabResult> &imageUndo)
{
    if(m_undoSize > m_maxUndo) {
        undoList.remove(0, 1);
    }
    undoList.append(imageUndo);
    setUndoSize(undoList.size());

    if(m_redoSize > 0) {
        clearRedo();
    }
}

#include "moc_GImageGrabber.cpp"
