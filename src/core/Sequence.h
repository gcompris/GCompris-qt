/* GCompris - Sequence.h
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
#ifndef SEQUENCE_H
#define SEQUENCE_H

#include <QList>
#include <QString>
#include <utility>

// activity name, dataset names
using SequenceElement = std::pair<QString, QStringList>;

class Sequence
{
public:
    const int currentActivityIndex() {
        return m_currentActivityIndex;
    }

    const SequenceElement& getNextActivity() {
        return m_sequences[m_currentActivityIndex++];
    }

    const qsizetype size() {
        return m_sequences.size();
    }
    const SequenceElement &operator[](qsizetype index) const {
        return m_sequences[index];
    }
    void clear() {
        m_sequences.clear();
    }
    bool empty() const {
        return m_sequences.empty();
    }

    // For c++17 for range loop
    QList<SequenceElement>::const_iterator begin() const {
        return m_sequences.begin();
    }
    QList<SequenceElement>::const_iterator end() const {
        return m_sequences.end();
    }

    void loadFromJson(const QByteArray &jsonContent);

private:
    int m_currentActivityIndex;
    QList<SequenceElement> m_sequences;
};

#endif // SEQUENCE_H
