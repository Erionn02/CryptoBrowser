#pragma once

#include <vector>
#include <string>
#include <cstdint>

#include <cpprest/http_client.h>


struct Point {
    std::uint64_t timestamp;
    double value;
};

using ChartData = std::vector<Point>;

using SymbolAndInterval = std::pair<std::string, std::string>;
struct PairHash {
    template <class T1, class T2>
    std::size_t operator () (const std::pair<T1,T2> &p) const {
        auto h1 = std::hash<T1>{}(p.first);
        auto h2 = std::hash<T2>{}(p.second);

        return h1 ^ h2;
    }
};


class CryptoChartDataFetcher {
public:
    CryptoChartDataFetcher(std::string cache_file = "/home/kuba/chart_data_cache.json");
    ~CryptoChartDataFetcher();
    ChartData fetch(const std::string& symbol, const std::string& interval = "1d", bool use_cache = true);

private:
    ChartData fetchFromNetwork(const std::string &symbol, const std::string& time_frame);


    std::string cache_file;
    std::unordered_map<SymbolAndInterval, ChartData, PairHash> cache{};
    web::http::client::http_client client;
};
