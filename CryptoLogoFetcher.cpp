#include "CryptoLogoFetcher.hpp"
#include <format>

CryptoLogoFetcher::CryptoLogoFetcher(std::string source) : source(std::move(source)) {
}

std::vector<char> CryptoLogoFetcher::fetch(const std::string &crypto_full_name, const std::string &crypto_symbol) {

}
