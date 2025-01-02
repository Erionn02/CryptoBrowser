#pragma once

#include <vector>
#include <string>
#include <nlohmann/json.hpp>

namespace web::http::client {
    class http_client;
}

class CoinLoreMetadataFetcher {
public:
    CoinLoreMetadataFetcher();

    std::vector<nlohmann::json> fetchTop100Cryptos();
    std::vector<nlohmann::json> fetchTopCryptos(std::size_t limit);

private:
    nlohmann::json sendRequest(web::http::client::http_client& client, std::size_t start, std::size_t limit);

    std::string api_base_url;
};
