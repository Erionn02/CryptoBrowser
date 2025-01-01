#include "CoinLoreDataFetcher.hpp"

#include <cpprest/http_client.h>
#include <fmt/format.h>


CryptoDataFetcher::CryptoDataFetcher(): api_base_url("https://api.coinlore.net/api/") {
}

std::vector<nlohmann::json> CryptoDataFetcher::fetchTop100Cryptos() {
    return fetchTopCryptos(100);
}

std::vector<nlohmann::json> CryptoDataFetcher::fetchTopCryptos(std::size_t limit) {
    web::http::client::http_client_config config{};
    config.set_max_redirects(100000);
    web::http::client::http_client client(api_base_url, config);
    std::vector<nlohmann::json> result;

    // this api has a limit of 100 items per request
    std::size_t left_to_fetch = limit;
    while (left_to_fetch > 0) {
        std::size_t this_fetch = std::min(left_to_fetch, 100ul);
        auto response = sendRequest(client, result.size(), this_fetch);
        auto total_coins = response["info"]["coins_num"].get<std::size_t>();
        if (total_coins > limit) {
            limit = total_coins;
            left_to_fetch = std::min(total_coins, left_to_fetch);
        }
        auto crypto_array = response["data"].get<std::vector<nlohmann::json>>();
        result.insert(result.end(), crypto_array.begin(), crypto_array.end());
        left_to_fetch -= this_fetch;
    }


    return result;
}

nlohmann::json CryptoDataFetcher::sendRequest(web::http::client::http_client& client, std::size_t start, std::size_t limit) {
    web::http::http_request request{web::http::methods::GET};
    request.set_request_uri(fmt::format("tickers/?start={}&limit={}", start, limit));
    auto response = client.request(request).get();
    std::string data_str = response.extract_string().get();
    return nlohmann::json::parse(data_str);
}
