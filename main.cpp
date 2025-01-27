#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QWindow>
#include <QScreen>

#include <fstream>
#include <iostream>
#include <filesystem>
#include <cpprest/http_client.h>
#include <fmt/format.h>

#include "QtCryptoController.hpp"


void setOnScreenCenter(QQmlApplicationEngine& engine) {
    if (!engine.rootObjects().isEmpty()) {
        QWindow *window = qobject_cast<QWindow *>(engine.rootObjects().first());
        if (window) {
            window->setX(QGuiApplication::primaryScreen()->geometry().x() + (QGuiApplication::primaryScreen()->geometry().width() - window->width()) / 2);
            window->setY(QGuiApplication::primaryScreen()->geometry().y() + (QGuiApplication::primaryScreen()->geometry().height() - window->height()) / 2);
        }
    }
}

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QtCryptoController controller{};
    qmlRegisterSingletonInstance("com.company.QtCryptoController", 1, 0, "QtCryptoController", &controller);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("CryptoBrowser", "Main");
    setOnScreenCenter(engine);

    return app.exec();
}
