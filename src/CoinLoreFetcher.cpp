#include "CoinLoreFetcher.hpp"



std::vector<CryptoData> CoinLoreFetcher::fetchTopCryptos(std::size_t limit, const std::string& interval) {
    auto cryptos = data_fetcher.fetchTopCryptos(limit);
    std::vector<std::string> crypto_ids{};
    for (const auto& crypto : cryptos) {
        crypto_ids.push_back(crypto["nameid"].get<std::string>());
    }
    auto logos = logo_fetcher.fetch(crypto_ids);

    std::vector<CryptoData> result{};
    result.reserve(cryptos.size());

    std::vector<std::string> symbols{};
    for (auto& crypto_data: cryptos) {
        CryptoData data{};
        data.name = crypto_data["name"].get<std::string>();
        data.symbol = crypto_data["symbol"].get<std::string>();
        data.price = std::stod(crypto_data["price_usd"].get<std::string>());
        data.market_cap = std::stod(crypto_data["market_cap_usd"].get<std::string>());
        data.change_24h = std::stod(crypto_data["percent_change_24h"].get<std::string>());\

        symbols.push_back(data.symbol);
        if (logos.contains(crypto_data["nameid"].get<std::string>())) {
            data.logo = logos.at(crypto_data["nameid"].get<std::string>());
        }
        data.interval = interval;
        result.push_back(data);
    }

    auto symbols_chart_data = chart_data_fetcher.fetch(symbols, interval);
    for (auto& crypto: result) {
        crypto.chart_data = symbols_chart_data.at(crypto.symbol);
    }

    return result;
}

std::vector<CryptoData> CoinLoreFetcher::fetchTop10() {
    return fetchTopCryptos(10, "1d");
}
