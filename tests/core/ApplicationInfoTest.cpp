/* GCompris - ApplicationInfoTest.cpp
 *
 * SPDX-FileCopyrightText: 2018 Billy Laws <blaws05@gmail.com>
 * GCompris  (C) 2018 GCompris Developers  <gcompris-devel@kde.org>
 *
 * Authors:
 *   Billy Laws <blaws05@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include <QObject>
#include <QTest>

#include "src/core/ApplicationInfo.h"

class ApplicationInfoTest : public QObject
{
public:
    Q_OBJECT
private Q_SLOTS:
    void LocaleTest_data();
    void LocaleTest();
    void WindowTest_data();
    void WindowTest();

    void getVoicesLocaleTest_data();
    void getVoicesLocaleTest();
    void getAudioFilePathForLocaleTest_data();
    void getAudioFilePathForLocaleTest();
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

void ApplicationInfoTest::getVoicesLocaleTest_data()
{
    QTest::addColumn<QString>("actual");
    QTest::addColumn<QString>("expected");
    QTest::newRow("default") << GC_DEFAULT_LOCALE
                             << "en_US";
    QTest::newRow("en_US") << "en_US"
                           << "en_US";
    QTest::newRow("pt_BR") << "pt_BR"
                           << "pt_BR";
    QTest::newRow("pt_PT") << "pt_PT"
                           << "pt";
    QTest::newRow("fr_FR") << "fr_FR"
                           << "fr";
}

void ApplicationInfoTest::getVoicesLocaleTest()
{
    // Set default locale to "C". ALlows to test GC_DEFAULT_LOCALE
    QLocale defaultLocale = QLocale::system();
    QLocale::setDefault(QLocale::c());
    ApplicationInfo appInfo;
    ApplicationInfo::getInstance();

    QFETCH(QString, actual);
    QFETCH(QString, expected);

    QCOMPARE(appInfo.getVoicesLocale(actual), expected);

    QLocale::setDefault(defaultLocale);
}

void ApplicationInfoTest::getAudioFilePathForLocaleTest_data()
{
    QTest::addColumn<QString>("file");
    QTest::addColumn<QString>("locale");
    QTest::addColumn<QString>("expected");
    QTest::newRow("absolutePath_en") << "/$LOCALE/$CA"
                                        << "en"
                                        << QString("/en/%1").arg(COMPRESSED_AUDIO);
    QTest::newRow("absolutePath_pt_BR") << "qrc:/$LOCALE/test"
                                        << "pt_BR"
                                        << "qrc:/pt_BR/test";
    QTest::newRow("absolute_fr") << ":/test/test2"
                                 << "unused"
                                 << ":/test/test2";
    QTest::newRow("relative_fr") << "$LOCALE/$CA"
                                 << "fr"
                                 << QString("qrc:/gcompris/data/fr/%1").arg(COMPRESSED_AUDIO);
}

void ApplicationInfoTest::getAudioFilePathForLocaleTest()
{
    ApplicationInfo appInfo;
    ApplicationInfo::getInstance();

    QFETCH(QString, file);
    QFETCH(QString, locale);
    QFETCH(QString, expected);

    QCOMPARE(appInfo.getAudioFilePathForLocale(file, locale), expected);
}

QTEST_MAIN(ApplicationInfoTest)
#include "ApplicationInfoTest.moc"
