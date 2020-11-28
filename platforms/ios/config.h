/* GCompris - config.h
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
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

#endif // GCOMPRIS_CONFIG_H
