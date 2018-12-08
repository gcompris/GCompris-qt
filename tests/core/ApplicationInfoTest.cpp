/* GCompris - ApplicationInfoTest.cpp
 *
 * Copyright (C) 2018 Billy Laws <blaws05@gmail.com>
 * GCompris  (C) 2018 GCompris Developers  <gcompris-devel@kde.org>
 *
 * Authors:
 *   Billy Laws <blaws05@gmail.com>
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

#include "src/core/ApplicationInfo.h"

class ApplicationInfoTest : public QObject
{
public:
    Q_OBJECT
private slots:
    void LocaleTest_data();
    void LocaleTest();
    void WindowTest_data();
    void WindowTest();
};

void ApplicationInfoTest::LocaleTest_data()
{
    QTest::addColumn<QString>("localeFull");
    QTest::addColumn<QString>("localeShort");
    QTest::addColumn<QString>("higherWord");
    QTest::addColumn<QString>("lowerWord");
    QTest::newRow("British English") << QStringLiteral("en_GB")
                                     << QStringLiteral("en")
                                     << QStringLiteral("apple")
                                     << QStringLiteral("banana");
}

void ApplicationInfoTest::LocaleTest()
{
    ApplicationInfo appInfo;
    ApplicationInfo::getInstance();

    QFETCH(QString, localeFull);
    QFETCH(QString, localeShort);
    QFETCH(QString, higherWord);
    QFETCH(QString, lowerWord);

    QVERIFY(appInfo.localeShort(localeFull) == localeShort);
    QVERIFY(appInfo.localeCompare(higherWord, lowerWord, localeFull) == -1);
    QVERIFY(appInfo.localeCompare(lowerWord, higherWord, localeFull) == 1);
    QVERIFY(appInfo.localeCompare(higherWord, higherWord, localeFull) == 0);

    QVariantList sortList;
	
    sortList.append(QVariant(higherWord));
    sortList.append(QVariant(lowerWord));
    sortList.append(QVariant(higherWord));
    sortList.append(QVariant(lowerWord));

    sortList = appInfo.localeSort(sortList, localeFull);

    QVERIFY(sortList[0] == higherWord);
    QVERIFY(sortList[1] == higherWord);
    QVERIFY(sortList[2] == lowerWord);
    QVERIFY(sortList[3] == lowerWord);
}

void ApplicationInfoTest::WindowTest_data()
{
    QTest::addColumn<bool>("useOpenGL");
    QTest::addColumn<int>("applicationWidth");
    QTest::addColumn<bool>("portraitMode");
    QTest::newRow("dummy1") << true
                            << 1920
                            << true;
}

void ApplicationInfoTest::WindowTest()
{
    ApplicationInfo appInfo;
    ApplicationInfo::getInstance();

    QFETCH(bool, useOpenGL);
    QFETCH(int, applicationWidth);
    QFETCH(bool, portraitMode);

    appInfo.setApplicationWidth(applicationWidth);
    appInfo.setIsPortraitMode(portraitMode);
    appInfo.setUseOpenGL(useOpenGL);

    QVERIFY(appInfo.useOpenGL() == useOpenGL);
    QVERIFY(appInfo.applicationWidth() == applicationWidth);
    QVERIFY(appInfo.isPortraitMode() == portraitMode);
}

QTEST_MAIN(ApplicationInfoTest)
#include "ApplicationInfoTest.moc"
