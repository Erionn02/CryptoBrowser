#pragma once

#include "CoinLoreMetadataFetcher.hpp"
#include "CoinLoreLogoFetcher.hpp"
#include "CryptoChartDataFetcher.hpp"


struct CryptoData {
    std::string name;
    std::string symbol;
    double price;
    double market_cap;
    double change_24h;
    std::vector<uint8_t> logo;
    ChartData chart_data;
    std::string interval;
};

class CoinLoreFetcher {
public:
    std::vector<CryptoData> fetchTopCryptos(std::size_t limit, const std::string& interval = "1d");
    std::vector<CryptoData> fetchTop10();

    CoinLoreMetadataFetcher data_fetcher{};
    CoinLoreLogoFetcher logo_fetcher{};
    CryptoChartDataFetcher chart_data_fetcher{};
};
