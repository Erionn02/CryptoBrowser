#include "CryptoLogoFetcher.hpp"

#include <cpprest/http_client.h>
#include <fmt/format.h>

CryptoLogoFetcher::CryptoLogoFetcher(std::string source) : source(std::move(source)) {
}

std::vector<unsigned char> CryptoLogoFetcher::fetch(const std::string &crypto_full_name, const std::string &crypto_symbol) {
    web::http::client::http_client_config config{};
    config.set_max_redirects(100000);
    web::http::client::http_client client(source, config);
    web::http::http_request request{web::http::methods::GET};
    request.set_request_uri(fmt::format("logos/{}-{}-logo.png", crypto_full_name, crypto_symbol));
    auto response = client.request(request).get();
    return response.extract_vector().get();
}
