/* Version number of package */
#define VERSION "0.35"
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
