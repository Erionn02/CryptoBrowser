import QtQuick
import QtQuick.Controls
import com.company.QtCryptoController

ApplicationWindow {
    width: 1024
    height: 768
    visible: true
    title: qsTr("CryptoBrowser")

    property var watchlist: []

    Rectangle {
        id: header
        color: "#2c3e50"
        height: 60
        width: parent.width
        anchors.top: parent.top

        Text {
            text: "CryptoBrowser"
            color: "white"
            font.pixelSize: 24
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        TextField {
            id: searchField
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
            width: 300
            placeholderText: "Search"
            font.pixelSize: 16
            padding: 10
            background: Rectangle {
                color: "white"
                radius: 10
            }
        }

        Button {
            id: searchButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: searchField.left
            anchors.rightMargin: 10
            text: "Search"
            font.pixelSize: 16
            padding: 10
            background: Rectangle {
                color: "#3498db"
                radius: 10
            }
            onClicked: {
                QtCryptoController.fetchSome()
            }
        }

        Button {
            id: watchlistButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: searchButton.left
            anchors.rightMargin: 10
            text: "Watchlist"
            font.pixelSize: 16
            padding: 10
            background: Rectangle {
                color: "#e74c3c"
                radius: 10
            }
            onClicked: {
                watchlistView.visible = !watchlistView.visible
            }
        }
    }

    Rectangle {
        id: mainSection
        color: "#ecf0f1"
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true

        ListView {
            id: cryptoList
            anchors.fill: parent
            model: QtCryptoController

            Keys.onUpPressed: scrollBar.decrease()
            Keys.onDownPressed: scrollBar.increase()
            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                policy: ScrollBar.AlwaysOn
                width: 20
            }

            delegate: Rectangle {
                id: delegate
                width: cryptoList.width - 20
                height: 100
                color: "white"
                radius: 10
                border.color: "lightgrey"
                border.width: 1
                anchors.margins: 10

                required property string cryptoName
                required property string cryptoSymbol
                required property double cryptoPrice
                required property double cryptoMarketCap
                required property double cryptoChange24H
                required property string cryptoLogo

                Row {
                    anchors.fill: parent
                    spacing: 10
                    padding: 10

                    Image {
                        source: "data:image/png;base64," + delegate.cryptoLogo
                        fillMode: Image.PreserveAspectFit
                        width: 80
                        height: 80
                    }
                    Column {
                        spacing: 2
                        Text {
                            text: delegate.cryptoName
                                font.bold: true
                                font.pixelSize: 18
                        }
                        Text {
                            text: delegate.cryptoSymbol
                                color: "grey"
                                font.pixelSize: 16
                        }
                    }
                    Column {
                        spacing: 2
                    Text {
                            text: "Price: $" + delegate.cryptoPrice.toFixed(2)
                            font.pixelSize: 16
                    }
                    Text {
                            text: "Market Cap: $" + formatMarketCap(delegate.cryptoMarketCap)
                            font.pixelSize: 16
                    }
                    Text {
                            text: "24H Change: " + delegate.cryptoChange24H.toFixed(2) + "%"
                            color: delegate.cryptoChange24H >= 0 ? "green" : "red"
                            font.pixelSize: 16
                        }
                    }
                    Button {
                        text: "Add to Watchlist"
                        onClicked: {
                            if (!watchlist.includes(delegate.cryptoSymbol)) {
                                watchlist.push({
                                    name: delegate.cryptoName,
                                    symbol: delegate.cryptoSymbol,
                                    price: delegate.cryptoPrice,
                                    marketCap: delegate.cryptoMarketCap,
                                    change24H: delegate.cryptoChange24H,
                                    logo: delegate.cryptoLogo
                                });
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: watchlistView
        color: "#ecf0f1"
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: false

        ListView {
            id: watchlistList
            anchors.fill: parent
            model: watchlist

            delegate: Rectangle {
                id: watchlistDelegate
                width: watchlistList.width - 20
                height: 100
                color: "white"
                radius: 10
                border.color: "lightgrey"
                border.width: 1
                anchors.margins: 10

                required property string name
                required property string symbol
                required property double price
                required property double marketCap
                required property double change24H
                required property string logo

                Row {
                    anchors.fill: parent
                    spacing: 10
                    padding: 10

                    Image {
                        source: "data:image/png;base64," + watchlistDelegate.logo
                        fillMode: Image.PreserveAspectFit
                        width: 80
                        height: 80
                    }
                    Column {
                        spacing: 2
                        Text {
                            text: watchlistDelegate.name
                            font.bold: true
                            font.pixelSize: 18
                        }
                        Text {
                            text: watchlistDelegate.symbol
                            color: "grey"
                            font.pixelSize: 16
                        }
                    }
                    Column {
                        spacing: 2
                        Text {
                            text: "Price: $" + watchlistDelegate.price.toFixed(2)
                            font.pixelSize: 16
                        }
                        Text {
                            text: "Market Cap: $" + formatMarketCap(watchlistDelegate.marketCap)
                            font.pixelSize: 16
                        }
                        Text {
                            text: "24H Change: " + watchlistDelegate.change24H.toFixed(2) + "%"
                            color: watchlistDelegate.change24H >= 0 ? "green" : "red"
                            font.pixelSize: 16
                        }
                    }
                }
            }
        }
    }

    function formatMarketCap(value) {
        if (value >= 1e12) {
            return (value / 1e12).toFixed(2) + "T";
        } else if (value >= 1e9) {
            return (value / 1e9).toFixed(2) + "B";
        } else if (value >= 1e6) {
            return (value / 1e6).toFixed(2) + "M";
        } else if (value >= 1e3) {
            return (value / 1e3).toFixed(2) + "K";
        } else {
            return value.toString();
        }
    }
}
