/* GCompris - FileTest.cpp
 *
 * SPDX-FileCopyrightText: 2018 Himanshu Vishwakarma <himvish997@gmail.com>
 * GCompris  (C) 2018 GCompris Developers  <gcompris-devel@kde.org>
 *
 * Authors:
 *   Himanshu Vishwakarma <himvish997@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

/* This file is used for the unit tests */

#include <QTest>
#include <QObject>
#include <QFile>
#include <QSignalSpy>

#include "src/core/File.h"

class CoreFileTest : public QObject
{
    Q_OBJECT
private Q_SLOTS:
    void cleanup();
    void FileExistsTest();
    void ReadWriteErrorsTest();
    void ReadWriteErrorsTest_data();
    void ReadWriteTest();
    void NameTest();
};

static const char *tempFilename = "./dummy_test_files.txt";
static const char *fakeFilename = "-_/fezagvvx&V/d;-ùlc";

void CoreFileTest::FileExistsTest()
{
    QFile tempFile(tempFilename);
    // open in write mode to create the file if does not exist
    tempFile.open(QIODevice::ReadWrite);
    tempFile.close();

    QVERIFY(File::exists(tempFilename));
}

void CoreFileTest::ReadWriteErrorsTest_data()
{
    QTest::addColumn<QString>("filename");
    QTest::addColumn<QString>("readError");
    QTest::addColumn<QString>("writeError");
    QTest::newRow("empty file") << ""
                                << QStringLiteral("source is empty")
                                << QStringLiteral("source is empty");

    QTest::newRow("non existing file") << fakeFilename
                                       << QStringLiteral("Unable to open the file")
                                       << QStringLiteral("could not open file ") + fakeFilename;
}

void CoreFileTest::ReadWriteErrorsTest()
{
    QFETCH(QString, filename);
    QFETCH(QString, readError);
    QFETCH(QString, writeError);

    const QString fileContent = QLatin1String("this is going to test the class File in the core");

    File file;
    QSignalSpy spyError(&file, &File::error);
    QVERIFY(spyError.isValid());
    QVERIFY(spyError.count() == 0);
    // we can't read
    QVERIFY(file.read(filename).isEmpty());
    QVERIFY(spyError.count() == 1);
    QString error = qvariant_cast<QString>(spyError.at(0).at(0));
    QCOMPARE(error, readError);
    // we can't write
    QVERIFY(!file.write(fileContent, filename));
    QVERIFY(spyError.count() == 2);
    error = qvariant_cast<QString>(spyError.at(1).at(0));
    QCOMPARE(error, writeError);
    // we can't append
    QVERIFY(!file.append(fileContent, filename));
    QVERIFY(spyError.count() == 3);
    error = qvariant_cast<QString>(spyError.at(2).at(0));
    QCOMPARE(error, writeError);
}

void CoreFileTest::ReadWriteTest()
{
    QFile tempFile(tempFilename);
    // open in write mode to create the file if does not exist
    tempFile.open(QIODevice::ReadWrite);
    tempFile.close();

    File file;
    const QString fileContent = QLatin1String("this is going to test the class File in the core");
    // normal use case, file exists
    QVERIFY(file.write(fileContent, tempFilename));
    QCOMPARE(file.read(), fileContent);

    // append to the file
    const QString appendedText = QLatin1String("appended text.");
    QVERIFY(file.append(appendedText, tempFilename));
    QCOMPARE(file.read(), fileContent+appendedText);
}

void CoreFileTest::NameTest()
{
    File file;
    QSignalSpy spyName(&file, &File::nameChanged);
    QVERIFY(spyName.isValid());
    QVERIFY(spyName.count() == 0);
    file.setName(tempFilename);
    QVERIFY(spyName.count() == 1);
    QCOMPARE(file.name(), QString(tempFilename));
    // test sanitizeUrl
    const QString sameNameUnsanitized = QStringLiteral("file://")+tempFilename;
    file.setName(sameNameUnsanitized);
    // no update triggered as same name after sanitization
    QVERIFY(spyName.count() == 1);
    QCOMPARE(file.name(), QString(tempFilename));

    const QString filenameUnsanitized = QStringLiteral("qrc:/")+tempFilename;
    file.setName(filenameUnsanitized);
    // no update triggered as same name after sanitization
    QVERIFY(spyName.count() == 2);
    QCOMPARE(file.name(), QStringLiteral(":/")+tempFilename);
}

void CoreFileTest::cleanup()
{
    QFile::remove("./dummy_test_files.txt");
}

QTEST_MAIN(CoreFileTest)
#include "FileTest.moc"
