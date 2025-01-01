cmake_minimum_required(VERSION 3.16)

include(${CMAKE_SOURCE_DIR}/cmake/CMakeHelpers.cmake)
setup_conan()

project(CryptoBrowser VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(cpprestsdk REQUIRED)
add_definitions(-D_TURN_OFF_PLATFORM_STRING)
list(APPEND CONAN_LIBS "cpprestsdk::cpprest")

find_package(fmt REQUIRED)
list(APPEND CONAN_LIBS "fmt::fmt")

find_package(GTest REQUIRED)
list(APPEND CONAN_LIBS "GTest::GTest")

find_package(Boost REQUIRED)
list(APPEND CONAN_LIBS "boost::boost")

find_package(OpenSSL REQUIRED)
list(APPEND CONAN_LIBS "OpenSSL::SSL")
list(APPEND CONAN_LIBS "OpenSSL::Crypto")

find_package(nlohmann_json REQUIRED)
list(APPEND CONAN_LIBS "nlohmann_json::nlohmann_json")


list(APPEND CMAKE_PREFIX_PATH "~/Qt/6.8.1/gcc_64")

find_package(Qt6 REQUIRED COMPONENTS Quick)

include_directories(include)

FILE(GLOB_RECURSE Resources_list RELATIVE ${CMAKE_SOURCE_DIR} "./assets/*")

MESSAGE("RESOURCES: ${Resources_list}")
qt_add_executable(appCryptoBrowser
        main.cpp
        src/CryptoLogoFetcher.cpp
        include/CryptoLogoFetcher.hpp
        src/CoinLoreDataFetcher.cpp
        include/CoinLoreDataFetcher.hpp
)

qt_add_qml_module(appCryptoBrowser
        URI CryptoBrowser
        VERSION 1.0
        QML_FILES
        Main.qml
        #    RESOURCES
        #        ${Resources_list}
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appCryptoBrowser PROPERTIES
        #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCryptoBrowser
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCryptoBrowser
        PRIVATE
        Qt6::Quick
        ${CONAN_LIBS}
)

include(GNUInstallDirs)
install(TARGETS appCryptoBrowser
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
