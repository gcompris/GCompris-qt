/* GCompris - Sequence.cpp
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#include "Sequence.h"
#include <QJsonDocument>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>

void Sequence::loadFromJson(const QByteArray &jsonContent) {
    m_currentActivityIndex = 0;
    m_sequences.clear();
    QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonContent);

    if (const QJsonValue v = jsonDocument["sequence"]; v.isArray()) {
        const QJsonArray sequences = v.toArray();
        for (int i = 0; i < sequences.size(); i++) {
            const QJsonObject sequence = sequences[i].toObject();
            const QString activity = sequence["activity"].toString();
            const QStringList datasets = sequence["datasets"].toVariant().toStringList();
            m_sequences.push_back({activity, datasets});
        }
    }
}
