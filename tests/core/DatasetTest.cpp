/* GCompris - DatasetTest.cpp
 *
 * Copyright (C) 2020 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
private slots:
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
