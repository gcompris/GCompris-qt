/* GCompris - GImageGrabber.h
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef GIMAGEGRABBER_H
#define GIMAGEGRABBER_H

#include <QQuickItem>
#include <QList>
#include <QtQml/qqmlregistration.h>
#include <config.h>
/**
 * @class GImageGrabber
 * @short A component to grab images in memory and store undo/redo stack
 * @ingroup components
 *
 */
class GImageGrabber : public QQuickItem
{
    Q_OBJECT
#ifndef WITH_RCC
    QML_ELEMENT
#endif
    friend class GImageGrabberTest;

    /**
    * Maximum number of undo stored
    *
    * Default is 10, use a lower number to optimize for low-memory devices,
    * and don't set too high value to limit memory used.
    *
    * Minimum is 1 (lower numbers will be set to 1)
    */
    Q_PROPERTY(int maxUndo READ maxUndo WRITE setMaxUndo NOTIFY maxUndoChanged)
    /**
     * Read-only, property, used to know if there is some undo stored.
     */
    Q_PROPERTY(int undoSize READ undoSize NOTIFY undoSizeChanged)
    /**
     * Read-only, property, used to know if there is some redo stored.
     */
    Q_PROPERTY(int redoSize READ redoSize NOTIFY redoSizeChanged)

public:
    explicit GImageGrabber(QQuickItem *parent = nullptr);

    int maxUndo() const;
    void setMaxUndo(const int&);

    int undoSize() const;
    int redoSize() const;

    /**
     * Grabs the image and store it in grabbedResult for further use.
     *
     * @param name Target pixel size to grab
     */
    Q_INVOKABLE void safeGrab(const QSize &targetSize);
    /**
     * Save current image in grabbedResult to a file
     *
     * @param name url to save the file
     */
    Q_INVOKABLE void saveToFile(const QUrl &filePath);
    /**
     * Get the url to access the image in grabbedResult to load in an Image item.
     */
    Q_INVOKABLE QUrl getImageUrl();
    /**
     * Call undo.
     */
    Q_INVOKABLE void doUndo();
    /**
     * Call redo.
     */
    Q_INVOKABLE void doRedo();
    /**
     * Clear the undo stack.
     */
    Q_INVOKABLE void clearUndo();
    /**
     * Clear the redo stack.
     */
    Q_INVOKABLE void clearRedo();

Q_SIGNALS:
    void maxUndoChanged();
    void undoSizeChanged();
    void redoSizeChanged();
    /**
     * Sent when the grabbed image is ready after a safeGrab.
     */
    void grabReady();

private:
    // Default to 10, can be set in qml property maxUndo
    int m_maxUndo = 10;

    int m_undoSize = 0;
    int m_redoSize = 0;

    void pushToUndo(const QSharedPointer<QQuickItemGrabResult>&);
    void setUndoSize(const qsizetype&);
    void setRedoSize(const qsizetype&);

    QSharedPointer<QQuickItemGrabResult> grabbedResult;
    QList<QSharedPointer<QQuickItemGrabResult>> undoList;
    QList<QSharedPointer<QQuickItemGrabResult>> redoList;
};

#endif
