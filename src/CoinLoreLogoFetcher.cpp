#include "CoinLoreLogoFetcher.hpp"

#include <fmt/format.h>

std::vector<uint8_t> CoinLoreLogoFetcher::fetch(const std::string &name_id) {
    web::http::http_request request{web::http::methods::GET};
    request.set_request_uri(fmt::format("/img/{}.png", name_id));


    auto response = client.request(request).get();
    if (response.status_code() != web::http::status_codes::OK) {
        throw std::runtime_error(fmt::format("Failed to fetch logo {}: {}", name_id, response.status_code()));
    }
    return response.extract_vector().get();
}

std::unordered_map<std::string, PngImageData> CoinLoreLogoFetcher::fetch(const std::vector<std::string> &name_ids) {
    std::vector<std::pair<std::string, pplx::task<web::http::http_response>>> responses{};
    responses.reserve(name_ids.size());

    for (const auto& name_id : name_ids) {
        web::http::http_request request{web::http::methods::GET};
        request.set_request_uri(fmt::format("/img/{}.png", name_id));
        responses.emplace_back(name_id, client.request(request));
    }

    std::unordered_map<std::string, PngImageData> result{};
    for (auto& [name_id, response_task] : responses) {
        auto response = response_task.get();
        result[name_id] = response.extract_vector().get();
    }
    return result;
}

