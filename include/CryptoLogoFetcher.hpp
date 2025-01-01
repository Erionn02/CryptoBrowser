#pragma once

#include <string>
#include <vector>

class CryptoLogoFetcher {
public:
    CryptoLogoFetcher(std::string source);


    std::vector<unsigned char> fetch(const std::string& crypto_full_name, const std::string& crypto_symbol);

private:
    std::string source;
};
