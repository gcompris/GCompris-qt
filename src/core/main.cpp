#include <QtDebug>
#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickWindow>
#include <QtQml>
#include <QObject>

#include "ActivityInfoTree.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

	ActivityInfoTree::init();

	QQmlApplicationEngine engine(QUrl("qrc:/gcompris/src/core/main.qml"));
	QObject *topLevel = engine.rootObjects().value(0);

	QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
	if ( !window ) {
		qWarning("Error: Your root item has to be a Window.");
		return -1;
	}
	window->show();
	return app.exec();

}
