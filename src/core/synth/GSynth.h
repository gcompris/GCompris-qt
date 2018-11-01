/* miniSynth - A Simple Software Synthesizer
   Copyright (C) 2015 Ville Räisänen <vsr at vsr.name>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
#ifndef GSYNTH_H
#define GSYNTH_H

#include <QAudioDeviceInfo>
#include <QAudioOutput>
#include <QTimer>
#include <QQmlEngine>

class Generator;

class GSynth : public QObject
{
    Q_OBJECT

public:
    explicit GSynth(QObject *parent = 0);
    virtual ~GSynth();

    /**
     * Saves per-activity progress using the default "progress" key.
     *
     * @param activity Name of the activity that wants to persist settings.
     * @param progress Last started level to save as progress value.
     */
    Q_INVOKABLE void generate(int note, int duration);

    static GSynth *getInstance() {
        if(!m_instance) {
            m_instance = new GSynth();
        }
        return m_instance;
    }
    static QObject *synthProvider(QQmlEngine *engine,
                                  QJSEngine *scriptEngine);

protected:
    static GSynth *m_instance;

private slots:
    void stopAudio(int note);
    
private:
    unsigned int bufferSize;

    Generator        *m_generator;
    QAudioDeviceInfo  m_device;
    QAudioFormat      m_format;
    QByteArray        m_buffer;
    QAudioOutput     *m_audioOutput;
    QIODevice        *m_output;
    QMap<int, QTimer *> m_timers;
};

#endif // GSYNTH_H
 
