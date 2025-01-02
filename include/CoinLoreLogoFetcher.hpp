#pragma once

#include <cpprest/http_client.h>
#include <nlohmann/json.hpp>
#include <vector>
#include <string>

using PngImageData = std::vector<uint8_t>;

class CoinLoreLogoFetcher {
public:
    CoinLoreLogoFetcher() : client("https://www.coinlore.com/") {}

    PngImageData fetch(const std::string& name_id);
    std::unordered_map<std::string, PngImageData> fetch(const std::vector<std::string>& name_ids);

private:
    web::http::client::http_client client;
};
