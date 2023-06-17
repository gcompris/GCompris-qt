/* GCompris - DatasetTest.cpp
 *
 * SPDX-FileCopyrightText: 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

#include <QTest>
#include <QObject>
#include <QSignalSpy>
#include "src/core/Dataset.h"

#define DATASET_TEST_ATTRIBUTE(attributeName, accessorName, attributeType) \
{ \
  QFETCH(attributeType, attributeName); \
  QSignalSpy spy(&activityinfo, &Dataset::attributeName ## Changed); \
  QVERIFY(spy.isValid()); \
  QVERIFY(spy.count() == 0); \
  activityinfo.set ## accessorName(attributeName); \
  QVERIFY(spy.count() == 1); \
  QCOMPARE(activityinfo.attributeName(), attributeName); \
}

class CoreDatasetTest : public QObject
{
    Q_OBJECT
private Q_SLOTS:
    void DatasetTest();
    void DatasetTest_data();
};

void CoreDatasetTest::DatasetTest_data()
{
    QTest::addColumn<QString>("objective");
    QTest::addColumn<quint32>("difficulty");
    QTest::addColumn<QVariant>("data");
    QTest::addColumn<bool>("enabled");

    QTest::newRow("Dataset") << "objective 1" << (quint32)3 << QVariant("data") << false;
    QTest::newRow("Dataset_2") << "another objective" << (quint32)1 << QVariant(2.0) << true;
}

void CoreDatasetTest::DatasetTest()
{
    Dataset activityinfo;

    QVERIFY(activityinfo.objective().isEmpty());
    QCOMPARE(activityinfo.difficulty(), 0);
    QVERIFY(activityinfo.enabled());

    DATASET_TEST_ATTRIBUTE(objective, Objective, QString);
    DATASET_TEST_ATTRIBUTE(difficulty, Difficulty, quint32);
    DATASET_TEST_ATTRIBUTE(data, Data, QVariant);
    DATASET_TEST_ATTRIBUTE(enabled, Enabled, bool);
}

QTEST_MAIN(CoreDatasetTest)
#include "DatasetTest.moc"
