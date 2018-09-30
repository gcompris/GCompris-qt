/* GCompris - GComprisPlugin.h
 *
 * Copyright (C) 2018 Johnny Jazeix <jazeix@gmail.com>
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
#ifndef GCOMPRISPLUGIN_H
#define GCOMPRISPLUGIN_H

#include <QQmlExtensionPlugin>

/**
 * A plugin that exposes GCompris to QML in the form of declarative items.
 */
class Q_DECL_EXPORT GComprisPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
#if !defined(STATIC_PLUGIN_GCOMPRIS)
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
#endif

public:
    explicit GComprisPlugin(QObject *parent = 0);

    void registerTypes(const char *uri);
};

#endif
