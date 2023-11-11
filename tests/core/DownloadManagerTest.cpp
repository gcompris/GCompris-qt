/* GCompris - DownloadManagerTest.cpp
 *
 * SPDX-FileCopyrightText: 2018 Alex Kovrigin <a.kovrigin0@gmail.com>
 * GCompris  (C) 2018 GCompris Developers <gcompris-devel@kde.org>
 *
 * Authors:
 *   Alex Kovrigin <a.kovrigin0@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include <QObject>
#include <QTest>
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

private Q_SLOTS:
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

        QTest::newRow("en_US") << "en_US" << "en_US";
        QTest::newRow("en_UK") << "en_UK" << "en";
        QTest::newRow("ru_RU") << "ru_RU" << "ru";
        QTest::newRow("de_DE") << "de_DE" << "de";
        QTest::newRow("fr_FR") << "fr_FR" << "fr";
    }
    void test_getVoicesResourceForLocale()
    {
        QFETCH(QString, locale);
        QFETCH(QString, language);

        DownloadManager::DownloadJob job{GCompris::ResourceType::NONE};
        job.file.setFileName(QFINDTESTDATA("Contents.test"));
        downloadManager->parseContents(&job);
        QCOMPARE(downloadManager->getVoicesResourceForLocale(locale),
                 QString("data3/voices-%1/voices-%2-2023-10-07-17-29-00.rcc").arg(COMPRESSED_AUDIO, language));
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
        QTest::addColumn<GCompris::ResourceType>("resource");

        QTest::newRow("wordset") << GCompris::ResourceType::WORDSET;
        QTest::newRow("wordset") << GCompris::ResourceType::WORDSET;
    }
    void test_downloadResource()
    {
        QFETCH(GCompris::ResourceType, resource);

        QVERIFY(downloadManager->downloadResource(resource));
        QVERIFY(!downloadManager->downloadResource(resource));
        downloadManager->abortDownloads();
    }

    void test_updateResource_data()
    {
        QTest::addColumn<GCompris::ResourceType>("resource");
        QTest::addColumn<bool>("expected_success");

        QTest::newRow("wordset") << GCompris::ResourceType::WORDSET << false;
        QTest::newRow("none") << GCompris::ResourceType::NONE << false;
    }
    void test_updateResource()
    {
        QFETCH(GCompris::ResourceType, resource);
        QFETCH(bool, expected_success);

       QVERIFY(expected_success == downloadManager->updateResource(resource, {}));
    }

    void test_downloadIsRunning_data()
    {
        QTest::addColumn<GCompris::ResourceType>("resource");

        QTest::newRow("wordset") << GCompris::ResourceType::WORDSET;
    }
    void test_downloadIsRunning()
    {
        QFETCH(GCompris::ResourceType, resource);

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
