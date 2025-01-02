#pragma once

#include "CoinLoreFetcher.hpp"

#include <QAbstractListModel>


class QtCryptoController : public QAbstractListModel {
    Q_OBJECT

public:
    enum Role {
        CryptoNameRole = Qt::UserRole + 1,
        CryptoSymbolRole,
        CryptoPriceRole,
        CryptoMarketCapRole,
        CryptoChange24HRole,
        CryptoLogoRole
    };

    QtCryptoController(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void fetchSome();

private:
    QList<CryptoData> cryptos;
    CoinLoreFetcher fetcher;
};
