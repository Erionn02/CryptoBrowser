#pragma once

#include "CoinLoreFetcher.hpp"

#include <QAbstractListModel>
#include <QPointF>

Q_DECLARE_METATYPE(Point) // Declare Point as a metatype

class QtCryptoController : public QAbstractListModel {
    Q_OBJECT

public:
    enum Role {
        CryptoNameRole = Qt::UserRole + 1,
        CryptoSymbolRole,
        CryptoPriceRole,
        CryptoMarketCapRole,
        CryptoChange24HRole,
        CryptoLogoRole,
        CryptoChartDataRole,
        IndexRole,
        IntervalRole
    };

    QtCryptoController(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void fetchSome();
    void fetchTopCryptos(int limit, const QString& interval);
    void updateChartInterval(int idx, const QString &interval);
    void search(const QString& query);
    void clear();

private:
    QList<CryptoData> cryptos;
    CoinLoreFetcher fetcher;
};
