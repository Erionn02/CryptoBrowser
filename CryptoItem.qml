import QtQuick
import QtQuick.Controls
import QtCharts

Rectangle {
    id: delegate

    width: cryptoList.width - 20

    property int baseHeight: 100
    property int expandedHeight: 500

    height: baseHeight
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
        id: baseDataRow
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

    Image {
        source: "qrc:/CryptoBrowser/assets/expand_down_icon.png"

        width: 64
        height: 64

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!chart.visible) {
                    delegate.height = delegate.expandedHeight
                } else {
                    delegate.height = delegate.baseHeight
                }
                chart.visible = !chart.visible
            }
        }
    }

    Rectangle {
        id: chart
        visible: false
        y: delegate.baseHeight
        radius: delegate.radius
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: baseDataRow.bottom
        color: "red"
        // ChartView {
        //     id: chart
        //     visible: false
        //     anchors.fill: parent
        //     antialiasing: true
        //
        //     LineSeries {
        //         name: "Example Data"
        //         XYPoint { x: 0; y: 1 }
        //         XYPoint { x: 1; y: 3 }
        //         XYPoint { x: 2; y: 2 }
        //         XYPoint { x: 3; y: 5 }
        //         XYPoint { x: 4; y: 4 }
        //     }
        //
        //     ValueAxis {
        //         id: axisX
        //         min: 0
        //         max: 4
        //     }
        //
        //     ValueAxis {
        //         id: axisY
        //         min: 0
        //         max: 5
        //     }
        //
        //     axes: [axisX, axisY]
        // }
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