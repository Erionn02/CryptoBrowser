#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "CryptoLogoFetcher.hpp"

#include <fstream>
#include <iostream>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("CryptoBrowser", "Main");

    CryptoLogoFetcher fetcher{"https://www.cryptologos.cc"};

    auto result = fetcher.fetch("pepe", "pepe");

    std::ofstream f{"/tmp/pepe.png", std::ios::trunc};
    std::cout << "Writing " << result.size() << " bytes to /tmp/pepe.png" << std::endl;
    f.write(reinterpret_cast<char*>(result.data()), result.size());

    return app.exec();
}
