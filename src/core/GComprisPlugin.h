/* GCompris - GComprisPlugin.h
 *
 * SPDX-FileCopyrightText: 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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
    explicit GComprisPlugin(QObject *parent = nullptr);

    void registerTypes(const char *uri) override;
};

#endif
