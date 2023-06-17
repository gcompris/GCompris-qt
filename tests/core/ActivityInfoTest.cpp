/* GCompris - ActivityInfoTest.cpp
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
#include <QSignalSpy>

#include "ApplicationSettingsMock.h"
#include "src/core/ActivityInfo.h"

#define ACTIVITY_INFO_TEST_ATTRIBUTE(attributeName, accessorName, attributeType) \
{ \
  QFETCH(attributeType, attributeName); \
  QSignalSpy spy(&activityinfo, &ActivityInfo::attributeName ## Changed); \
  QVERIFY(spy.isValid()); \
  QVERIFY(spy.count() == 0); \
  activityinfo.set ## accessorName(attributeName); \
  QVERIFY(spy.count() == 1); \
  QCOMPARE(activityinfo.attributeName(), attributeName); \
}

class CoreActivityInfoTest : public QObject
{
    Q_OBJECT
private Q_SLOTS:
    void ActivityInfoTest();
    void ActivityInfoTest_data();
    void levelsTest();
};

void CoreActivityInfoTest::ActivityInfoTest_data()
{
    QTest::addColumn<QString>("name");
    QTest::addColumn<QString>("section");
    QTest::addColumn<quint32>("difficulty");
    QTest::addColumn<quint32>("minimalDifficulty");
    QTest::addColumn<quint32>("maximalDifficulty");
    QTest::addColumn<QString>("icon");
    QTest::addColumn<QString>("author");
    QTest::addColumn<QString>("title");
    QTest::addColumn<QString>("description");
    QTest::addColumn<QString>("goal");
    QTest::addColumn<QString>("prerequisite");
    QTest::addColumn<QString>("manual");
    QTest::addColumn<QString>("credit");
    QTest::addColumn<bool>("favorite");
    QTest::addColumn<bool>("enabled");
    QTest::addColumn<int>("createdInVersion");

    QTest::newRow("ActivityInfo") << "Name" << "section" << (quint32)3 << (quint32)2 << (quint32)4 << "icon" << "author" << "title" << "description" << "goal" << "prerequisite" << "manual" << "credit" << false << false << 2;
    QTest::newRow("UnknownInfo") << "Unknown" << "Unknown" << (quint32)5 << (quint32)1 << (quint32)6 << "Unknown" << "Unknown" << "Unknown" << "Unknown" << "Unknown" << "Unknown" << "Unknown" << "Unknown" << true << true << 10;
    QTest::newRow("Empty") << "" << "" << (quint32)0 << (quint32)1 << (quint32)2 << "" << "" << "" << "" << "" << "" << "" << "" << true << true << 0;
}

void CoreActivityInfoTest::ActivityInfoTest()
{
    ActivityInfo activityinfo;

    // called here to set the static instance object to the mock one
    ApplicationSettingsMock::getInstance();

    QVERIFY(activityinfo.name().isEmpty());
    QVERIFY(activityinfo.section().isEmpty());
    QVERIFY(activityinfo.icon().isEmpty());
    QVERIFY(activityinfo.author().isEmpty());
    QVERIFY(activityinfo.title().isEmpty());
    QVERIFY(activityinfo.description().isEmpty());
    QVERIFY(activityinfo.goal().isEmpty());
    QVERIFY(activityinfo.prerequisite().isEmpty());
    QVERIFY(activityinfo.manual().isEmpty());
    QVERIFY(activityinfo.credit().isEmpty());
    QVERIFY(!activityinfo.favorite());
    QVERIFY(activityinfo.enabled());
    QCOMPARE(activityinfo.createdInVersion(), 0);

    ACTIVITY_INFO_TEST_ATTRIBUTE(name, Name, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(section, Section, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(difficulty, Difficulty, quint32);
    ACTIVITY_INFO_TEST_ATTRIBUTE(minimalDifficulty, MinimalDifficulty, quint32);
    ACTIVITY_INFO_TEST_ATTRIBUTE(maximalDifficulty, MaximalDifficulty, quint32);
    ACTIVITY_INFO_TEST_ATTRIBUTE(icon, Icon, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(author, Author, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(title, Title, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(description, Description, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(goal, Goal, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(prerequisite, Prerequisite, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(manual, Manual, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(credit, Credit, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(favorite, Favorite, bool);
    ACTIVITY_INFO_TEST_ATTRIBUTE(enabled, Enabled, bool);
    ACTIVITY_INFO_TEST_ATTRIBUTE(createdInVersion, CreatedInVersion, int);

    delete ApplicationSettingsMock::getInstance();
}

void CoreActivityInfoTest::levelsTest()
{
    // called here to set the static instance object to the mock one
    ApplicationSettingsMock::getInstance();

    ActivityInfo activityinfo;
    activityinfo.setName(QStringLiteral("activityTest"));
    QVERIFY(!activityinfo.hasDataset());
    activityinfo.setLevels({QStringLiteral("1,2,3,4,5,6")});
    QStringList expected;
    expected << "1" << "2" << "3" << "4" << "5" << "6";
    QCOMPARE(activityinfo.levels(), expected);
    QCOMPARE(activityinfo.currentLevels(), expected);

    for(int i = 1 ; i < 7 ; ++ i) {
        Dataset *d = new Dataset();
        d->setDifficulty(i);
        activityinfo.addDataset(QString::number(i), d);
    }

    activityinfo.enableDatasetsBetweenDifficulties(3, 4);
    QCOMPARE(activityinfo.minimalDifficulty(), 3);
    QCOMPARE(activityinfo.maximalDifficulty(), 4);

    QVERIFY(activityinfo.hasDataset());

    for(int i = 1 ; i < 7 ; ++ i) {
        QVERIFY(activityinfo.getDataset(QString::number(i))->enabled() == (i == 3 || i == 4));
        delete activityinfo.getDataset(QString::number(i));
    }
}

QTEST_MAIN(CoreActivityInfoTest)
#include "ActivityInfoTest.moc"
