#include <QtDebug>
#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QObject>

#include "ActivityInfoTree.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

	ActivityInfoTree::init();

	QtQuick2ApplicationViewer viewer;
	viewer.setMainQmlFile(QStringLiteral("qml/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
