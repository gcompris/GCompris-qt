/* GCompris - FileTest.cpp
 *
 * Copyright (C) 2018 Himanshu Vishwakarma <himvish997@gmail.com>
 * GCompris  (C) 2018 GCompris Developers  <gcompris-devel@kde.org>
 *
 * Authors:
 *   Himanshu Vishwakarma <himvish997@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

/* This file is used for the unit tests */

#include <QtTest>
#include <QObject>

#include "src/core/File.h"

class CoreFileTest : public QObject
{
    Q_OBJECT
private slots:
    void FileTest();
    void ReadWriteTest();
};

void CoreFileTest::FileTest()
{
    File file;
    QSignalSpy spyName(&file, &File::nameChanged);

    QVERIFY(spyName.count() == 0);

    QString name = QStringLiteral("./dummy_test_files.txt");
    file.setName(name);
    QVERIFY(File::exists(name));
    QVERIFY(File::mkpath(QStringLiteral("./make/dummy/path")));
    QVERIFY(spyName.count() == 1);
    QCOMPARE(file.write(QStringLiteral("How are you??")), true);
    QCOMPARE(file.read(), QStringLiteral("How are you??"));
}

void CoreFileTest::ReadWriteTest()
{
    File file;

    QString fileContaint = QStringLiteral("this is going to test the class File in the core");
    QSignalSpy spyError(&file, &File::error);
    QVERIFY(spyError.count() == 0);
    // File object does not having file name
    QVERIFY(!file.write(fileContaint));
    QVERIFY(spyError.count() == 1);
    QVERIFY(file.write(fileContaint, "./dummy_test_files.txt"));
    QCOMPARE(file.read(), fileContaint);
    QVERIFY(file.exists("./dummy_test_files.txt"));

}

QTEST_MAIN(CoreFileTest)
#include "FileTest.moc"