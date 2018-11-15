/* GCompris - DirectoryTest.cpp
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

#include <QObject>
#include <QtTest>
#include <QDir>

#include "src/core/File.h"
#include "src/core/Directory.h"

class DirectoryTest : public QObject
{
public:
    Q_OBJECT
private slots:
    void GetFilesTest();
};


void DirectoryTest::GetFilesTest()
{
    // Removing the directory.
    // It is required as it may already be present in memory because of unsuccessful test/ interruption
    QDir dir("./dummy_directory");
    dir.removeRecursively();

    File file;
    QVERIFY(File::mkpath("./dummy_directory"));

    Directory directory;
    QStringList filelist = directory.getFiles("./dummy_directory");
    // We do not count './' & '../' in directory.
    QCOMPARE(filelist.count(), 0);

    // Creating the empty file of name file1.
    file.write("", "./dummy_directory/file1");
    // Creating the empty directory of name dir1.
    File::mkpath("./dummy_directory/dir1");
    filelist = directory.getFiles("./dummy_directory", {"*"});
    QCOMPARE(filelist.count(), 2);

    file.write("", "./dummy_directory/file2");
    file.write("", "./dummy_directory/file3");
    File::mkpath("./dummy_directory/dir2");
    File::mkpath("./dummy_directory/dir3");
    filelist = directory.getFiles("./dummy_directory");
    QCOMPARE(filelist.count(), 6);

    // Removing the directory.
    QVERIFY(File::rmpath("./dummy_directory/file3"));
    QVERIFY(File::rmpath("./dummy_directory/file2"));
    QVERIFY(!File::rmpath("./dummy_directory/dir3"));
    filelist = directory.getFiles("./dummy_directory");
    QCOMPARE(filelist.count(), 4);
    dir.removeRecursively();
}

QTEST_MAIN(DirectoryTest)
#include "DirectoryTest.moc"
