/* GCompris - DownloadManagerTest.cpp
 *
 * Copyright (C) 2018 Alex Kovrigin <a.kovrigin0@gmail.com>
 * GCompris  (C) 2018 GCompris Developers <gcompris-devel@kde.org>
 *
 * Authors:
 *   Alex Kovrigin <a.kovrigin0@gmail.com>
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
#include <QString>

#include "src/core/DownloadManager.h"
#include "src/core/ApplicationInfo.h"
#include "ApplicationSettingsMock.h"
/**
 * @brief The DownloadManagerTest class Unit tests class for DownloadManager testing
 * @sa DownloadManager
 */
class DownloadManagerTest : public QObject
{
    Q_OBJECT

private slots:
    /**
     * @brief initTestCase Case for basic functionality of DownloadManager
     */
    void initTestCase()
    {
        ApplicationSettingsMock::getInstance()->setIsAutomaticDownloadsEnabled(false);
        downloadManager = DownloadManager::getInstance();
    }

    void test_getVoicesResourceForLocale_data()
    {
        QTest::addColumn<QString>("locale");
        QTest::addColumn<QString>("language");

        QTest::newRow("en_US") << "en_US" << "en";
        QTest::newRow("en_UK") << "en_UK" << "en";
        QTest::newRow("ru_RU") << "ru_RU" << "ru";
        QTest::newRow("de_DE") << "de_DE" << "de";
        QTest::newRow("fr_FR") << "fr_FR" << "fr";
    }
    void test_getVoicesResourceForLocale()
    {
        QFETCH(QString, locale);
        QFETCH(QString, language);

        QCOMPARE(downloadManager->getVoicesResourceForLocale(locale),
                 QString("data2/voices-%1/voices-%2.rcc").arg(COMPRESSED_AUDIO, language));
    }

    void test_haveLocalResource_data()
    {
        QTest::addColumn<QString>("resource");
        QTest::addColumn<bool>("expected_success");

        QTest::newRow("invalid.invalid") << "invalid.invalid" << false;
        QTest::newRow("no.no") << "no.no" << false;
        QTest::newRow("money.rcc") << "money.rcc" << true;
        QTest::newRow("penalty.rcc") << "penalty.rcc" << true;
    }
    void test_haveLocalResource()
    {
        QFETCH(QString, resource);
        QFETCH(bool, expected_success);

        QVERIFY(expected_success == downloadManager->haveLocalResource(resource));
    }

    void test_downloadResource_data()
    {
        QTest::addColumn<QString>("resource");

        QTest::newRow("invalid.blabla") << "invalid.blabla";
        QTest::newRow("algorithm.rcc") << "algorithm.rcc";
    }
    void test_downloadResource()
    {
        QFETCH(QString, resource);

        QVERIFY(downloadManager->downloadResource(resource));
        QVERIFY(!downloadManager->downloadResource(resource));
        downloadManager->abortDownloads();
    }

    void test_updateResource_data()
    {
        QTest::addColumn<QString>("resource");
        QTest::addColumn<bool>("expected_success");

        QTest::newRow("invalid.haha") << "invalid.haha" << false;
        QTest::newRow("money.rcc") << "money.rcc" << true;
    }
    void test_updateResource()
    {
        QFETCH(QString, resource);
        QFETCH(bool, expected_success);

        QVERIFY(expected_success == downloadManager->updateResource(resource));
    }

    void test_downloadIsRunning_data()
    {
        QTest::addColumn<QString>("resource");

        QTest::newRow("colors.rcc") << "colors.rcc";
    }
    void test_downloadIsRunning()
    {
        QFETCH(QString, resource);

        downloadManager->abortDownloads();
        QVERIFY(!downloadManager->downloadIsRunning());
        QVERIFY(downloadManager->downloadResource(resource));
        QVERIFY(downloadManager->downloadIsRunning());
        downloadManager->abortDownloads();
    }

    void test_registerResource_data()
    {
        QTest::addColumn<QString>("resource");
        QTest::addColumn<bool>("expected_success");

        QTest::newRow("invalid.rcc") << "invalid.rcc" << false;
        QTest::newRow("money.rcc") << "money.rcc" << true;
    }
    void test_registerResource()
    {
        QFETCH(QString, resource);
        QFETCH(bool, expected_success);

        QVERIFY(expected_success == downloadManager->registerResource(resource));
    }

    void test_isDataRegistered_data()
    {
        QTest::addColumn<QString>("resource");
        QTest::addColumn<QString>("register_mode");

        QTest::newRow("invalid.rcc") << "invalid.rcc" << "invalid";
        QTest::newRow("mosaic.rcc") << "mosaic.rcc" << "not_registered";
    }
    void test_isDataRegistered()
    {
        QFETCH(QString, resource);
        QFETCH(QString, register_mode);

        if(register_mode == "not_registered") {
            QVERIFY(!downloadManager->isDataRegistered(resource));
        }
        else if(register_mode == "invalid") {
            QVERIFY(!downloadManager->registerResource(resource));
            QVERIFY(!downloadManager->isDataRegistered(resource));
        }
        else {
            QVERIFY(false);
        }
    }
    
private:
    /**
     * @brief downloadManager The DownloadManager object, that is the test downloadManager
     */
    DownloadManager *downloadManager;
};

QTEST_MAIN(DownloadManagerTest);
#include "DownloadManagerTest.moc"
