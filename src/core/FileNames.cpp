/* GCompris - FileNames.cpp
 *
 * Copyright (C) 2017 Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
 *
 * Authors:
 *   Rudra Nil Basu <rudra.nil.basu.1996@gmail.com>
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
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

#include "FileNames.h"

#include <dirent.h>
#include <QString>
#include <string.h>
#include <QObject>


FileNames::FileNames()
{
}

QString FileNames::getFiles(QString location)
{
    const char *s=location.toUtf8().constData();
    DIR *dpdf=opendir(s);
    struct dirent *epdf;

    QString files;

    if(dpdf!=NULL) {
        while(epdf = readdir(dpdf)) {
            if(strcmp(epdf->d_name, ".")!=0 && strcmp(epdf->d_name,"..")) {
                // next file name = epdf->d_name
                files.append(QString::fromLocal8Bit((epdf->d_name)));
                files.append(" ");
            }
        }
    }
    return files;
}
