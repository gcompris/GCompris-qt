/* GCompris - ActivityInfoTest.cpp
 *
 * Copyright (C) 2018 Himanshu Vishwakarma <himvish997@gmail.com>
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

#include <QtTest>
#include <QObject>

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
private slots:
    void ActivityInfoTest();
    void ActivityInfoTest_data();
    void getSectionPathTest();
};

void CoreActivityInfoTest::ActivityInfoTest_data()
{
    QTest::addColumn<QString>("name");
    QTest::addColumn<QString>("section");
    QTest::addColumn<unsigned int>("difficulty");
    QTest::addColumn<QString>("icon");
    QTest::addColumn<QString>("author");
    QTest::addColumn<bool>("demo");
    QTest::addColumn<QString>("title");
    QTest::addColumn<QString>("description");
    QTest::addColumn<QString>("goal");
    QTest::addColumn<QString>("prerequisite");
    QTest::addColumn<QString>("manual");
    QTest::addColumn<QString>("credit");
    QTest::addColumn<bool>("favorite");
    QTest::addColumn<bool>("enabled");
    QTest::addColumn<int>("createdInVersion");

    QTest::newRow("ActivityInfo") << "Name" << "section" << (unsigned int)3 << "icon" << "author" << true << "title" << "description" << "goal" << "prerequisite" << "manual" << "credit" << false << false << 2;
    QTest::newRow("UnknownInfo") << "Unknown" << "Unknown" << (unsigned int)5 << "Unknown" << "Unknown" << false << "Unknown" << "Unknown" << "Unknown" << "Unknown" << "Unknown" << "Unknown" << true << true << 10;
    QTest::newRow("Empty") << "" << "" << (unsigned int)0 << "" << "" << false << "" << "" << "" << "" << "" << "" << true << true << 0;
}

void CoreActivityInfoTest::ActivityInfoTest()
{
    ActivityInfo activityinfo;

    // called here to set the static instance object to the mock one
    ApplicationSettingsMock::getInstance();

    QCOMPARE(activityinfo.name(), QStringLiteral(""));
    QCOMPARE(activityinfo.section(), QStringLiteral(""));
    QCOMPARE(activityinfo.icon(), QStringLiteral(""));
    QCOMPARE(activityinfo.author(), QStringLiteral(""));
    QVERIFY(activityinfo.demo());
    QCOMPARE(activityinfo.title(), QStringLiteral(""));
    QCOMPARE(activityinfo.description(), QStringLiteral(""));
    QCOMPARE(activityinfo.goal(), QStringLiteral(""));
    QCOMPARE(activityinfo.prerequisite(), QStringLiteral(""));
    QCOMPARE(activityinfo.manual(), QStringLiteral(""));
    QCOMPARE(activityinfo.credit(), QStringLiteral(""));
    QVERIFY(!activityinfo.favorite());
    QVERIFY(activityinfo.enabled());
    QCOMPARE(activityinfo.createdInVersion(), 0);

    ACTIVITY_INFO_TEST_ATTRIBUTE(name, Name, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(section, Section, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(difficulty, Difficulty, unsigned int);
    ACTIVITY_INFO_TEST_ATTRIBUTE(icon, Icon, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(author, Author, QString);
    ACTIVITY_INFO_TEST_ATTRIBUTE(demo, Demo, bool);
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

void CoreActivityInfoTest::getSectionPathTest()
{
    ActivityInfo parent;
    parent.setSection("parent");
    ActivityInfo child(&parent);
    child.setSection("child");
    QStringList sectionPath = child.getSectionPath();

    QCOMPARE(sectionPath.size(), 2);
    QCOMPARE(sectionPath.join('/'), QStringLiteral("parent/child"));
}

QTEST_MAIN(CoreActivityInfoTest)
#include "ActivityInfoTest.moc"
