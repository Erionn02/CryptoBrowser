#pragma once

#include "CoinLoreMetadataFetcher.hpp"
#include "CoinLoreLogoFetcher.hpp"

struct CryptoData {
    std::string name;
    std::string symbol;
    double price;
    double market_cap;
    double change_24h;
    std::vector<uint8_t> logo;
};

class CoinLoreFetcher {
public:
    std::vector<CryptoData> fetchTopCryptos(std::size_t limit);
    std::vector<CryptoData> fetchTop10();
private:
    CoinLoreMetadataFetcher data_fetcher{};
    CoinLoreLogoFetcher logo_fetcher{};
};
