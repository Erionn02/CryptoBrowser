#include "QtCryptoController.hpp"

QString vectorToBase64QString(const std::vector<uint8_t>& vec) {
    QByteArray byteArray(reinterpret_cast<const char*>(vec.data()), static_cast<int>(vec.size()));
    QByteArray base64ByteArray = byteArray.toBase64();
    return QString::fromUtf8(base64ByteArray);
}

QtCryptoController::QtCryptoController(QObject *parent): QAbstractListModel(parent) {}

int QtCryptoController::rowCount(const QModelIndex &parent) const {
    return cryptos.size();
}

QVariant QtCryptoController::data(const QModelIndex &index, int role) const {
    if (index.isValid() && index.row() >= 0 && index.row() < cryptos.size()) {
        const auto& crypto = cryptos.at(index.row());
        switch (role) {
        case CryptoNameRole:
            return QString::fromStdString(crypto.name);
        case CryptoSymbolRole:
            return QString::fromStdString(crypto.symbol);
        case CryptoPriceRole:
            return crypto.price;
        case CryptoMarketCapRole:
            return crypto.market_cap;
        case CryptoChange24HRole:
            return crypto.change_24h;
            case CryptoLogoRole:
            return vectorToBase64QString(crypto.logo);
        default:
            break;
        }
    }
}

QHash<int, QByteArray> QtCryptoController::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[CryptoNameRole] = "cryptoName";
    roles[CryptoSymbolRole] = "cryptoSymbol";
    roles[CryptoPriceRole] = "cryptoPrice";
    roles[CryptoMarketCapRole] = "cryptoMarketCap";
    roles[CryptoChange24HRole] = "cryptoChange24H";
    roles[CryptoLogoRole] = "cryptoLogo";
    return roles;
}

void QtCryptoController::fetchSome() {
    std::cout << "Fetched some" << std::endl;
    auto result = fetcher.fetchTopCryptos(100);

    beginInsertRows(QModelIndex(), cryptos.size(), cryptos.size() + result.size() - 1);

    for (auto& crypto: result) {
        cryptos.emplace_back(std::move(crypto));
    }
    endInsertRows();
}
