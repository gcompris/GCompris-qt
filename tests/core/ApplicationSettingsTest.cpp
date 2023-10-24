/* GCompris - ApplicationSettingsTest.cpp
 *
 * SPDX-FileCopyrightText: 2018 Himanshu Vishwakarma <himvish997@gmail.com>
 *
 * Authors:
 *   Himanshu Vishwakarma <himvish997@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include <QTest>
#include <QObject>
#include <QFile>
#include <QSignalSpy>

#include "src/core/ApplicationSettings.h"
#include "ApplicationSettingsMock.h"

#define APPLICATION_SETTINGS_TEST_ATTRIBUTE(attributeType, attributeName, accessorName, accessorNameChanged) \
{ \
    QFETCH(attributeType, attributeName); \
    QSignalSpy spy(&applicationSettingsMock, &ApplicationSettings::accessorNameChanged); \
    QVERIFY(spy.isValid()); \
    QVERIFY(spy.count() == 0); \
    applicationSettingsMock.accessorName(attributeName); \
    QVERIFY(spy.count() == 1); \
    QCOMPARE(applicationSettingsMock.attributeName(), attributeName); \
}

class CoreApplicationSettingsTest : public QObject
{
    Q_OBJECT
private Q_SLOTS:
    void cleanup();
    void ApplicationSettingsInitializationTest();
    void ApplicationSettingsTest();
    void ApplicationSettingsTest_data();
    void ActivitySettingsTest();
};

void CoreApplicationSettingsTest::ApplicationSettingsInitializationTest()
{
    ApplicationSettingsMock applicationSettings;
    QCOMPARE(applicationSettings.baseFontSizeMin(), -7);
    QCOMPARE(applicationSettings.baseFontSizeMax(), 7);
    QCOMPARE(applicationSettings.fontLetterSpacingMin(), (qreal)0.0);
    QCOMPARE(applicationSettings.fontLetterSpacingMax(), (qreal)8.0);
}

void CoreApplicationSettingsTest::ApplicationSettingsTest_data()
{
    QTest::addColumn<bool>("isAudioVoicesEnabled");
    QTest::addColumn<bool>("isAudioEffectsEnabled");
    QTest::addColumn<bool>("isBackgroundMusicEnabled");
    QTest::addColumn<quint32>("previousHeight");
    QTest::addColumn<quint32>("previousWidth");
    QTest::addColumn<bool>("isVirtualKeyboard");
    QTest::addColumn<QString>("locale");
    QTest::addColumn<QString>("font");
    QTest::addColumn<bool>("isEmbeddedFont");
    QTest::addColumn<quint32>("fontCapitalization");
    QTest::addColumn<qreal>("fontLetterSpacing");
    QTest::addColumn<bool>("isAutomaticDownloadsEnabled");
    QTest::addColumn<quint32>("filterLevelMin");
    QTest::addColumn<quint32>("filterLevelMax");
    QTest::addColumn<bool>("isKioskMode");
    QTest::addColumn<bool>("sectionVisible");
    QTest::addColumn<QString>("downloadServerUrl");
    QTest::addColumn<QString>("cachePath");
    QTest::addColumn<QString>("userDataPath");
    QTest::addColumn<quint32>("exeCount");
    QTest::addColumn<bool>("isBarHidden");
    QTest::addColumn<int>("baseFontSize");
    QTest::addColumn<int>("lastGCVersionRan");
    QTest::addColumn<bool>("isFullscreen");
    QTest::addColumn<QString>("renderer");
    QTest::addColumn<qreal>("backgroundMusicVolume");
    QTest::addColumn<qreal>("audioEffectsVolume");
    QTest::addColumn<QStringList>("filteredBackgroundMusic");
    
    QTest::newRow("dummySettings1") << true << true << true << (quint32)21 << (quint32)25 << true << "en_EN" << "font1" << true << (quint32)36 << (qreal)2.532 << true << (quint32)26 << (quint32)84 << true << true << "downloadServerUrl1" << "cachePath1" << "userDataPath1" << (quint32)48 << true << 7 << 52 << false << "softwareRenderer" << (qreal)0.5 << (qreal)0.7 << (QStringList() << "music1");
    QTest::newRow("dummySettings2") << false << false << false << (quint32)20 << (quint32)32 << false << "en_US" << "font2" << false << (quint32)34 <<(qreal)2.3 << false << (quint32)24 << (quint32)80 << false << false << "downloadServerUrl2" << "cachePath2" << "userDataPath2" << (quint32)44 << false << 5 << 64 << false << "openglRenderer" << (qreal)1.0 << (qreal)0.0 << (QStringList() << "music2" << "music3");
}

void CoreApplicationSettingsTest::ApplicationSettingsTest()
{
    ApplicationSettingsMock applicationSettingsMock;
    ApplicationSettingsMock::getInstance();

    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, isAudioVoicesEnabled, setIsAudioVoicesEnabled, audioVoicesEnabledChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, isAudioEffectsEnabled, setIsAudioEffectsEnabled, audioEffectsEnabledChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, isBackgroundMusicEnabled, setIsBackgroundMusicEnabled, backgroundMusicEnabledChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(quint32, previousHeight, setPreviousHeight, previousHeightChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(quint32, previousWidth, setPreviousWidth, previousWidthChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, isVirtualKeyboard, setVirtualKeyboard, virtualKeyboardChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(QString, locale, setLocale, localeChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(QString, font, setFont, fontChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, isEmbeddedFont, setIsEmbeddedFont, embeddedFontChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(quint32, fontCapitalization, setFontCapitalization, fontCapitalizationChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(qreal, fontLetterSpacing, setFontLetterSpacing, fontLetterSpacingChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, isAutomaticDownloadsEnabled, setIsAutomaticDownloadsEnabled, automaticDownloadsEnabledChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(quint32, filterLevelMin, setFilterLevelMin, filterLevelMinChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(quint32, filterLevelMax, setFilterLevelMax, filterLevelMaxChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, isKioskMode, setKioskMode, kioskModeChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, sectionVisible, setSectionVisible, sectionVisibleChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(QString, downloadServerUrl, setDownloadServerUrl, downloadServerUrlChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(QString, cachePath, setCachePath, cachePathChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(QString, userDataPath, setUserDataPath, userDataPathChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(quint32, exeCount, setExeCount, exeCountChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, isBarHidden, setBarHidden, barHiddenChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(int, baseFontSize, setBaseFontSize, baseFontSizeChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(int, lastGCVersionRan, setLastGCVersionRan, lastGCVersionRanChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(bool, isFullscreen, setFullscreen, fullscreenChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(QString, renderer, setRenderer, rendererChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(qreal, backgroundMusicVolume, setBackgroundMusicVolume, backgroundMusicVolumeChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(qreal, audioEffectsVolume, setAudioEffectsVolume, audioEffectsVolumeChanged);
    APPLICATION_SETTINGS_TEST_ATTRIBUTE(QStringList, filteredBackgroundMusic, setFilteredBackgroundMusic, filteredBackgroundMusicChanged);

    delete ApplicationSettingsMock::getInstance();
}

void CoreApplicationSettingsTest::ActivitySettingsTest()
{
    ApplicationSettingsMock applicationSettingsMock;
    ApplicationSettingsMock::getInstance();
    // Creating a dummyActivity
    QString dummyActivity = QStringLiteral("DummyActivity");

    // By Default the DummyActivity is not favorite
    QVERIFY(!applicationSettingsMock.isFavorite(dummyActivity));
    // Setting Up the DummyActivity as Favorite
    applicationSettingsMock.setFavorite(dummyActivity, true);
    QVERIFY(applicationSettingsMock.isFavorite(dummyActivity));
    // setting Up the DummyActivity as Not favorite
    applicationSettingsMock.setFavorite(dummyActivity, false);
    QVERIFY(!applicationSettingsMock.isFavorite(dummyActivity));

    // By Default the activity progress is zero
    QCOMPARE(applicationSettingsMock.loadActivityProgress(dummyActivity), 0);
    // Saving the Activity Progress
    applicationSettingsMock.saveActivityProgress(dummyActivity, 3);
    QCOMPARE(applicationSettingsMock.loadActivityProgress(dummyActivity), 3);
    applicationSettingsMock.saveActivityProgress(dummyActivity, 10);
    QCOMPARE(applicationSettingsMock.loadActivityProgress(dummyActivity), 10);
    applicationSettingsMock.saveActivityProgress(dummyActivity, 0);
    QCOMPARE(applicationSettingsMock.loadActivityProgress(dummyActivity), 0);

    // Test current level getter/setter
    QCOMPARE(applicationSettingsMock.currentLevels(dummyActivity), {});
    applicationSettingsMock.setCurrentLevels(dummyActivity, {"3"});
    QCOMPARE(applicationSettingsMock.currentLevels(dummyActivity), {"3"});

    // By Default the activity
    QVariantMap configuration;
    configuration.insert(QStringLiteral("DummyKey1"), QStringLiteral("DummyValue1"));
    configuration.insert(QStringLiteral("DummyKey2"), QStringLiteral("DummyValue2"));
    configuration.insert(QStringLiteral("DummyKey3"), QStringLiteral("DummyValue3"));
    configuration.insert(QStringLiteral("DummyKey4"), QStringLiteral("DummyValue4"));

    applicationSettingsMock.saveActivityConfiguration(dummyActivity, configuration);
    QVariantMap newConfiguration = applicationSettingsMock.loadActivityConfiguration(dummyActivity);

    QCOMPARE(newConfiguration.value(QStringLiteral("DummyKey1")), configuration.value(QStringLiteral("DummyKey1")));
    QCOMPARE(newConfiguration.value(QStringLiteral("DummyKey2")), configuration.value(QStringLiteral("DummyKey2")));
    QCOMPARE(newConfiguration.value(QStringLiteral("DummyKey3")), configuration.value(QStringLiteral("DummyKey3")));
    QCOMPARE(newConfiguration.value(QStringLiteral("DummyKey4")), configuration.value(QStringLiteral("DummyKey4")));

    delete ApplicationSettingsMock::getInstance();
}

void CoreApplicationSettingsTest::cleanup()
{
    QFile::remove("./dummy_application_settings.conf");
}

QTEST_MAIN(CoreApplicationSettingsTest)
#include "ApplicationSettingsTest.moc"
