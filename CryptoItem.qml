import QtQuick
import QtQuick.Controls
import QtCharts
import Qt5Compat.GraphicalEffects
import com.company.QtCryptoController

Rectangle {
    id: delegate

    width: cryptoList.width - 20

    property int baseHeight: 120
    property int expandedHeight: 500

    height: baseHeight
    color: "white"
    radius: 10
    border.color: "lightgrey"
    border.width: 1
    anchors.margins: 10

    layer.enabled: true
    layer.effect: DropShadow {
        id: shadowEffect
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 8
        samples: 16
        color: "#80000000"
    }

    // Gradient background for the card
    gradient: Gradient {
        GradientStop {
            position: 0.0; color: "#FFFFFF"
        }
        GradientStop {
            position: 1.0; color: "#F0F0F0"
        }
    }

    required property string cryptoName
    required property string cryptoSymbol
    required property double cryptoPrice
    required property double cryptoMarketCap
    required property double cryptoChange24H
    required property string cryptoLogo
    required property string interval
    required property int index
    required property list<point> cryptoChartData


    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: delegate
                scale: 1.02
            }
            PropertyChanges {
                target: layer.effect
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            properties: "scale"; duration: 200
        }
        NumberAnimation {
            target: layer.effect; properties: "radius"; duration: 200
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    Row {
        id: baseDataRow
        spacing: 15
        padding: 15

        // Circular mask for the logo
        Rectangle {
            width: 80
            height: 80
            radius: width / 2
            color: "transparent"
            clip: true

            Image {
                source: "data:image/png;base64," + delegate.cryptoLogo
                fillMode: Image.PreserveAspectFit
                width: 80
                height: 80
            }

            // Glow effect for the logo
            layer.enabled: true
            layer.effect: Glow {
                radius: 8
                samples: 16
                color: "#80000000"
                transparentBorder: true
            }
        }

        Column {
            spacing: 5
            Text {
                text: delegate.cryptoName
                font.bold: true
                font.pixelSize: 20
                font.family: "Arial"
                color: "#333333"
            }
            Text {
                text: delegate.cryptoSymbol.toUpperCase()
                color: "#666666"
                font.pixelSize: 16
                font.family: "Arial"
            }
        }
        Column {
            spacing: 5
            Text {
                text: "Price: $" + delegate.cryptoPrice.toFixed(2)
                font.pixelSize: 16
                font.family: "Arial"
                color: "#333333"
            }
            Text {
                text: "Market Cap: $" + formatMarketCap(delegate.cryptoMarketCap)
                font.pixelSize: 16
                font.family: "Arial"
                color: "#333333"
            }
            Text {
                text: "24H Change: " + delegate.cryptoChange24H.toFixed(2) + "%"
                color: delegate.cryptoChange24H >= 0 ? "#4CAF50" : "#F44336"
                font.pixelSize: 16
                font.family: "Arial"
                font.bold: true
            }
        }
    }

    Text {
        text: "Press to expand"
        font.pixelSize: 14
        font.family: "Arial"
        color: "#666666"
        anchors.verticalCenter: expandButton.verticalCenter
        anchors.right: expandButton.left
        anchors.rightMargin: 15
    }

    Image {
        id: expandButton
        source: "qrc:/CryptoBrowser/assets/expand_down_icon.png"
        width: 32
        height: 32
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15

        // Rotate animation for the expand button
        RotationAnimation on rotation {
            id: expandAnimation
            from: 0
            to: 180
            duration: 300
            running: false
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!chartSpace.visible) {
                    delegate.height = delegate.expandedHeight
                    expandAnimation.running = true
                } else {
                    delegate.height = delegate.baseHeight
                    expandAnimation.running = false
                    expandButton.rotation = 0
                }
                chartSpace.visible = !chartSpace.visible
                chartFormatSelector.visible = chartSpace.visible
            }
        }
    }

    Rectangle {
        id: chartSpace
        visible: false
        y: delegate.baseHeight
        radius: delegate.radius
        anchors.bottom: chartFormatSelector.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: baseDataRow.bottom
        anchors.topMargin: 10
        color: "#F5F5F5"

        // Gradient overlay for the chart area
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0.0; color: "#F5F5F5"
                }
                GradientStop {
                    position: 1.0; color: "#E0E0E0"
                }
            }
        }

        ToolTip {
            id: toolTip
            visible: false
            background: Rectangle {
                color: "#333333"
                radius: 4
            }
            contentItem: Text {
                text: toolTip.text
                color: "white"
                font.pixelSize: 12
                font.family: "Arial"
            }
        }

        ChartView {
            id: chart
            title: "Price Chart, interval: " + delegate.interval
            anchors.fill: parent
            legend.visible: false
            antialiasing: true
            backgroundColor: "transparent"

            LineSeries {
                id: series
                axisX: DateTimeAxis {
                    id: axisX
                    format: "dd.MM.yyyy" // Default format
                    tickCount: 10
                    labelsColor: "#333333"
                }
                axisY: ValueAxis {
                    id: axisY
                    labelFormat: "%.2f"
                    labelsColor: "#333333"
                }

                onHovered: function (point, state) {
                    let date = new Date(point.x);
                    if (axisX.format == "dd.MM.yyyy") {
                        toolTip.text = point.y.toFixed(2) + " $ " + date.getDate() + "." + (date.getMonth() + 1) + "." + date.getFullYear()
                    } else {
                        toolTip.text = point.y.toFixed(2) + " $ " + date.getDate() + "." + (date.getMonth() + 1) + " " + date.getHours() + ":" + date.getMinutes()
                    }
                    toolTip.visible = state
                    let p = chart.mapToPosition(point, series)
                    toolTip.x = p.x
                    toolTip.y = p.y - toolTip.height
                }
            }
        }
    }

    Row {
        id: chartFormatSelector
        visible: false
        spacing: 10
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10

        Button {
            text: "Day"
            onClicked: updateChartFormat("1d")
        }
        Button {
            text: "Hour"
            onClicked: updateChartFormat("1h")
        }
        Button {
            text: "Minute"
            onClicked: updateChartFormat("5m")
        }
    }

    function updateChartFormat(format) {
        switch (format) {
            case "1d":
                axisX.format = "dd.MM.yyyy";
                break;
            case "1h":
                axisX.format = "dd.MM  hh:mm";
                break;
            case "5m":
                axisX.format = "dd.MM  hh:mm";
                break;
        }
        QtCryptoController.updateChartInterval(index, format);
    }

    // Function to update the chart data
    function updateChartData() {
        series.clear();
        let min = Number.MAX_VALUE;
        let max = Number.MIN_VALUE;
        let minTimestamp = Number.MAX_VALUE;
        let maxTimestamp = Number.MIN_VALUE;
        for (var i = 0; i < delegate.cryptoChartData.length; i++) {
            let timestamp = delegate.cryptoChartData[i].x;
            if (timestamp < minTimestamp) {
                minTimestamp = timestamp;
            }
            if (timestamp > maxTimestamp) {
                maxTimestamp = timestamp;
            }
            let date = new Date(timestamp);
            let price = delegate.cryptoChartData[i].y;
            if (price < min) {
                min = price;
            }
            if (price > max) {
                max = price;
            }
            series.append(date.getTime(), price);
        }
        let delta = max - min;
        axisY.min = min - delta * 0.3;
        axisY.max = max + delta * 0.3;
        axisX.min = new Date(minTimestamp);
        axisX.max = new Date(maxTimestamp);
    }

    onCryptoChartDataChanged: {
        updateChartData();
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