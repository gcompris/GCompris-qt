/* GCompris - GImageGrabberTest.cpp
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include <QTest>
#include <QObject>

#include "src/core/GImageGrabber.h"

class GImageGrabberTest : public QObject
{
public:
    Q_OBJECT
private Q_SLOTS:
    void SetMaxUndoTest();
    void DoUndoTest();
    void DoRedoTest();
};

void GImageGrabberTest::SetMaxUndoTest()
{
    GImageGrabber grabber;

    grabber.setMaxUndo(-1);
    QCOMPARE(grabber.maxUndo(), 1);

    // set maxUndo to 20
    grabber.setMaxUndo(20);
    QCOMPARE(grabber.maxUndo(), 20);

    // get 21 undo steps
    for(int i = 0; i < 21; i++ ) {
        grabber.safeGrab(QSize(1, 1));
    }

    // move 5 undo to redoList
    for(int j = 0; j < 5; j++) {
        grabber.doUndo();
    }
    QCOMPARE(grabber.undoSize(), 16);
    QCOMPARE(grabber.redoSize(), 5);

    grabber.setMaxUndo(12);
    QCOMPARE(grabber.undoSize(), 13);
    QCOMPARE(grabber.redoSize(), 0);

    // move again 5 undo to redoList
    for(int j = 0; j < 5; j++) {
        grabber.doUndo();
    }
    QCOMPARE(grabber.undoSize(), 8);
    QCOMPARE(grabber.redoSize(), 5);

    grabber.setMaxUndo(10);
    QCOMPARE(grabber.undoSize(), 8);
    QCOMPARE(grabber.redoSize(), 3);
}

void GImageGrabberTest::DoUndoTest()
{
    GImageGrabber grabber;

    // test with nothing to undo (only 1 safeGrab)
    grabber.safeGrab(QSize(1, 1));
    QCOMPARE(grabber.undoSize(), 1);
    QCOMPARE(grabber.redoSize(), 0);

    grabber.doUndo();
    QCOMPARE(grabber.undoSize(), 1);
    QCOMPARE(grabber.redoSize(), 0);

    // test with something to undo (after 2nd safeGrab)
    grabber.safeGrab(QSize(1, 1));
    QCOMPARE(grabber.undoSize(), 2);
    QCOMPARE(grabber.redoSize(), 0);

    grabber.doUndo();
    QCOMPARE(grabber.undoSize(), 1);
    QCOMPARE(grabber.redoSize(), 1);
}

void GImageGrabberTest::DoRedoTest()
{
    GImageGrabber grabber;

    // make 2 safeGrab to have something to undo
    grabber.safeGrab(QSize(1, 1));
    grabber.safeGrab(QSize(1, 1));
    QCOMPARE(grabber.undoSize(), 2);
    QCOMPARE(grabber.redoSize(), 0);

    // test with nothing to redo
    grabber.doRedo();
    QCOMPARE(grabber.undoSize(), 2);
    QCOMPARE(grabber.redoSize(), 0);

    // test with something to redo
    grabber.doUndo();
    QCOMPARE(grabber.undoSize(), 1);
    QCOMPARE(grabber.redoSize(), 1);
    grabber.doRedo();
    QCOMPARE(grabber.undoSize(), 2);
    QCOMPARE(grabber.redoSize(), 0);
}

QTEST_MAIN(GImageGrabberTest)
#include "GImageGrabberTest.moc"
