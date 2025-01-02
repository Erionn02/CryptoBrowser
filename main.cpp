#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <fstream>
#include <iostream>
#include <filesystem>
#include <cpprest/http_client.h>
#include <fmt/format.h>

#include "CoinLoreMetadataFetcher.hpp"
#include "CoinLoreLogoFetcher.hpp"
#include "QtCryptoController.hpp"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

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

    CoinLoreMetadataFetcher data_fetcher{};
    std::filesystem::create_directories("/tmp/logos");




    return app.exec();
}
