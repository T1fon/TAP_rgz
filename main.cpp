#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "View/MainScreen.hpp"
#include <Model/TableModel.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<MainScreen>("Main_Screen", 1, 0, "Main_Screen");
    qmlRegisterType<TableModel>("Table_Model", 1, 0, "Table_Model");
    const QUrl url(u"qrc:/RGZ_TAP/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);



    return app.exec();
}
