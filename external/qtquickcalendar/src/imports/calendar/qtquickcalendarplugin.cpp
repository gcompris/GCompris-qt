/****************************************************************************
**
** Copyright (C) 2020 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt Quick Calendar.
**
** $QT_BEGIN_LICENSE:GPL-MARKETPLACE-QT$
**
** Marketplace License Usage
** Users, who have licensed the Software under the Qt Marketplace license
** agreement, may use this file in accordance with the Qt Marketplace license
** agreement provided with the Software or, alternatively, in accordance with
** the terms contained in a written agreement between the licensee and The Qt
** Company. For licensing terms and conditions see
** https://www.qt.io/terms-conditions/#marketplace and
** https://www.qt.io/terms-conditions. For further information use the contact
** form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QtQml/qqmlextensionplugin.h>

#include "qquickdayofweekrow_p.h"
#include "qquickmonthgrid_p.h"
#include "qquickweeknumbercolumn_p.h"
#include "qquickcalendarmodel_p.h"
#include "qquickcalendar_p.h"

QT_BEGIN_NAMESPACE

class QtQuickCalendarPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    QtQuickCalendarPlugin(QObject *parent = nullptr);
    void registerTypes(const char *uri) override;
};

QtQuickCalendarPlugin::QtQuickCalendarPlugin(QObject *parent) : QQmlExtensionPlugin(parent)
{
}

static QObject *calendarSingleton(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    return new QQuickCalendar;
}

void QtQuickCalendarPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<QQuickDayOfWeekRow>(uri, 1, 0, "AbstractDayOfWeekRow");
    qmlRegisterType<QQuickMonthGrid>(uri, 1, 0, "AbstractMonthGrid");
    qmlRegisterType<QQuickWeekNumberColumn>(uri, 1, 0, "AbstractWeekNumberColumn");
    qmlRegisterType<QQuickCalendarModel>(uri, 1, 0, "CalendarModel");
    qmlRegisterSingletonType<QQuickCalendar>(uri, 1, 0, "Calendar", calendarSingleton);
}

QT_END_NAMESPACE

#include "qtquickcalendarplugin.moc"
