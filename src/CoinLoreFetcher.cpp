#include "CoinLoreFetcher.hpp"

std::vector<CryptoData> CoinLoreFetcher::fetchTopCryptos(std::size_t limit) {
    auto cryptos = data_fetcher.fetchTopCryptos(limit);
    std::vector<std::string> crypto_ids{};
    for (const auto& crypto : cryptos) {
        crypto_ids.push_back(crypto["nameid"].get<std::string>());
    }
    auto logos = logo_fetcher.fetch(crypto_ids);

    std::vector<CryptoData> result{};
    result.reserve(cryptos.size());

    for (auto& crypto_data: cryptos) {
        CryptoData data{};
        data.name = crypto_data["name"].get<std::string>();
        data.symbol = crypto_data["symbol"].get<std::string>();
        data.price = std::stod(crypto_data["price_usd"].get<std::string>());
        data.market_cap = std::stod(crypto_data["market_cap_usd"].get<std::string>());
        data.change_24h = std::stod(crypto_data["percent_change_24h"].get<std::string>());
        if (logos.contains(crypto_data["nameid"].get<std::string>())) {
            data.logo = logos.at(crypto_data["nameid"].get<std::string>());
        }
        result.push_back(data);
    }

    return result;
}

std::vector<CryptoData> CoinLoreFetcher::fetchTop10() {
    return fetchTopCryptos(10);
}
