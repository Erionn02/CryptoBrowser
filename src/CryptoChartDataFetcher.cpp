#include "CryptoChartDataFetcher.hpp"

#include <fmt/format.h>
#include <nlohmann/json.hpp>
#include <spdlog/spdlog.h>

CryptoChartDataFetcher::CryptoChartDataFetcher(std::string cache_file): cache_file(std::move(cache_file)), client("https://api.binance.com") {
    std::ifstream file{cache_file};
    if (file.is_open()) {
        auto result = nlohmann::json::parse(file);
        for (const auto& [crypto_name, interval_data] : result.items())
        {
            for (auto&[interval, data]: interval_data.items()) {
                ChartData loaded_data;
                for (auto& [_, el]: data.items()) {
                    loaded_data.emplace_back(el.at(0).get<double>(), el.at(1).get<std::uint64_t>());
                }
                cache[{crypto_name, interval}] = std::move(loaded_data);
            }
        }
    }

}

CryptoChartDataFetcher::~CryptoChartDataFetcher() {
    std::ofstream file{cache_file};
    nlohmann::json cache_json;
    for (const auto& [key, data] : cache) {
        nlohmann::json data_json;
        for (const auto& point : data) {
            data_json.push_back({point.value, point.timestamp});
        }
        const auto& [symbol, time_frame] = key;
        cache_json[symbol][time_frame] = data_json;
    }
    file << cache_json.dump(4);
    file.close();
}

ChartData CryptoChartDataFetcher::fetch(const std::string& symbol, const std::string& interval, bool use_cache) {
    if (use_cache && cache.contains({symbol, interval})) {
        return cache.at({symbol, interval});
    }
    return fetchFromNetwork(symbol, interval);
}

std::unordered_map<std::string, ChartData> CryptoChartDataFetcher::fetch(const std::vector<std::string> &symbols,
    const std::string &interval, bool use_cache) {
    std::unordered_map<std::string, ChartData> result{};

    std::vector<std::pair<std::string, pplx::task<web::http::http_response>>> responses{};
    responses.reserve(symbols.size());
    for (const auto& symbol : symbols) {
        if (use_cache && cache.contains({symbol, interval})) {
            result[symbol] = cache.at({symbol, interval});
        } else {
            web::http::http_request request{web::http::methods::GET};
            request.set_request_uri(fmt::format("/api/v3/klines?symbol={}USDT&interval={}&limit=30", symbol, interval));
            responses.emplace_back(symbol, client.request(request));
        }
    }

    for (auto& [symbol, response_task] : responses) {
        auto response = response_task.get();
        ChartData chart_data{};
        if (response.status_code() == web::http::status_codes::OK) {
            std::string data_str = response.extract_string().get();
            auto items_array = nlohmann::json::parse(data_str);
            for (auto&[_, el] : items_array.items()) {
                chart_data.push_back({el[0].get<std::uint64_t>(), std::stod(el[1].get<std::string>())});
            }
            cache[{symbol, interval}] = chart_data;
        }
        result[symbol] = chart_data;
    }

    return result;
}

ChartData CryptoChartDataFetcher::fetchFromNetwork(const std::string &symbol, const std::string& interval) {
    web::http::http_request request{web::http::methods::GET};
    request.set_request_uri(fmt::format("/api/v3/klines?symbol={}USDT&interval={}&limit=30", symbol, interval));
    auto response = client.request(request).get();
    if (response.status_code() != web::http::status_codes::OK) {
        spdlog::warn("Failed to fetch chart data for {}: {}, response: {}", symbol, response.status_code(), response.extract_string().get());
        return {};
    }
    std::string data_str = response.extract_string().get();
    auto items_array = nlohmann::json::parse(data_str);
    ChartData result{};
    for (auto&[_, el] : items_array.items()) {
        result.push_back({el[0].get<std::uint64_t>(), std::stod(el[1].get<std::string>())});
    }
    cache[{symbol, interval}] = result;
    return result;
}
