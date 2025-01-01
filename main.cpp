#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "CryptoLogoFetcher.hpp"

#include <fstream>
#include <iostream>
#include <filesystem>
#include <fmt/format.h>

#include "CoinLoreDataFetcher.hpp"

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

    CryptoDataFetcher data_fetcher{};
    CryptoLogoFetcher logo_fetcher{"https://www.cryptologos.cc"};
    std::filesystem::create_directories("/tmp/logos");
    auto cryptos = data_fetcher.fetchTopCryptos(10);
    for (const auto& crypto : cryptos) {
        std::cout << "Fetching logo for " << crypto["name"].get<std::string>() << std::endl;
        std::cout << crypto.dump(4) << std::endl;
        try {
            auto result = logo_fetcher.fetch(crypto["nameid"].get<std::string>(), crypto["symbol"].get<std::string>());
            std::ofstream f{fmt::format("/tmp/logos/{}.png", crypto["symbol"].get<std::string>()), std::ios::trunc};
            f.write(reinterpret_cast<const char*>(result.data()), result.size());
        } catch (std::exception& e) {
            std::cerr << "Failed to fetch logo for " << crypto["nameid"].get<std::string>() << ": " << e.what() << std::endl;
        }

    }



    return app.exec();
}
