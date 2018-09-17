/* GCompris - config.h
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
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
#ifndef GCOMPRIS_CONFIG_H
#define GCOMPRIS_CONFIG_H

/* Version number of package (string) */
#define VERSION "0.80"
/* Version number of package (integer) */
#define VERSION_CODE 8000
/* Folder where rccs and translations are installed */
#ifdef  Q_OS_MAC
#define GCOMPRIS_DATA_FOLDER "."
#else
#define GCOMPRIS_DATA_FOLDER "../bin/gcompris-qt.app/Contents/MacOS"
#endif
/* GCompris for android, gcompris-qt for others */
#define GCOMPRIS_APPLICATION_NAME "gcompris-qt"
/* Compressed audio format */
#define COMPRESSED_AUDIO "aac"
/* Download Allowed */
#define DOWNLOAD_ALLOWED "ON"
/* Date at which GCompris has been built */
#define BUILD_DATE "201757"
/* Type of activation system */
#define ACTIVATION_MODE "no"

#endif // GCOMPRIS_CONFIG_H
