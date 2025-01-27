#include "QtCryptoController.hpp"

QString vectorToBase64QString(const std::vector<uint8_t> &vec) {
    QByteArray byteArray(reinterpret_cast<const char *>(vec.data()), static_cast<int>(vec.size()));
    QByteArray base64ByteArray = byteArray.toBase64();
    return QString::fromUtf8(base64ByteArray);
}

QtCryptoController::QtCryptoController(QObject *parent): QAbstractListModel(parent) {
}

int QtCryptoController::rowCount(const QModelIndex &parent) const {
    return cryptos.size();
}

QVariant QtCryptoController::data(const QModelIndex &index, int role) const {
    if (index.isValid() && index.row() >= 0 && index.row() < cryptos.size()) {
        const auto &crypto = cryptos.at(index.row());
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
            case CryptoChartDataRole: {
                QList<QPointF> list{};
                for (auto &point: crypto.chart_data) {
                    list.append({(double) point.timestamp, point.value});
                }
                return QVariant::fromValue(list);
            }
            case IndexRole:
                return index.row();
            case IntervalRole:
                return QString::fromStdString(crypto.interval);
            default:
                std::unreachable();
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
    roles[CryptoChartDataRole] = "cryptoChartData";
    roles[IndexRole] = "index";
    roles[IntervalRole] = "interval";
    return roles;
}

void QtCryptoController::fetchSome() {
    fetchTopCryptos(3, "1d");
}

void QtCryptoController::fetchTopCryptos(int limit, const QString &interval) {
    auto result = fetcher.fetchTopCryptos(limit, interval.toStdString());
    clear();

    beginInsertRows(QModelIndex(), cryptos.size(), cryptos.size() + result.size() - 1);

    for (auto &crypto: result) {
        cryptos.emplace_back(std::move(crypto));
    }
    endInsertRows();
}

void QtCryptoController::updateChartInterval(int idx, const QString &interval) {
    if (idx < 0 || idx >= cryptos.size()) {
        return;
    }
    auto &crypto = cryptos[idx];
    crypto.chart_data = fetcher.chart_data_fetcher.fetch(crypto.symbol, interval.toStdString());
    crypto.interval = interval.toStdString();
    emit dataChanged(index(idx), index(idx), {CryptoChartDataRole});
    emit dataChanged(index(idx), index(idx), {IntervalRole});
}

void QtCryptoController::search(const QString &query) {
    if (query.isEmpty()) {
        return;
    }

    auto upper_symbol = query.toUpper().toStdString();
    auto lower_symbol = query.toLower().toStdString();
    auto symbol = query.toStdString();
    std::vector<std::string> symbols{std::move(upper_symbol), std::move(lower_symbol), std::move(symbol)};

    QList<CryptoData> result{};
    for (auto &crypto: cryptos) {
        if (std::ranges::any_of(symbols, [&crypto](const auto & symbol) { return crypto.symbol.starts_with(symbol);})) {
            result.append(std::move(crypto));
        }
    }
    clear();

    beginInsertRows(QModelIndex(), cryptos.size(), cryptos.size() + result.size() - 1);
    for (auto &crypto: result) {
        cryptos.emplace_back(std::move(crypto));
    }
    endInsertRows();
}

void QtCryptoController::clear() {
    beginRemoveRows(QModelIndex(), 0, cryptos.size() - 1);
    cryptos.clear();
    endRemoveRows();
}
