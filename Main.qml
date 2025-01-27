import QtQuick
import QtQuick.Controls
import com.company.QtCryptoController
import QtCharts

ApplicationWindow {
    width: 1024
    height: 768
    visible: true
    title: qsTr("CryptoBrowser")

    Rectangle {
        id: header
        color: "#2c3e50"
        height: 80
        width: parent.width
        anchors.top: parent.top

        Text {
            id: title
            text: "CryptoBrowser"
            color: "white"
            font.pixelSize: 28 // Slightly larger font
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
        }

        Row {
            id: fetchSection
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: title.right
            anchors.leftMargin: 30
            spacing: 10

            TextField {
                id: fetchField
                width: 200
                placeholderText: "Number of cryptos to fetch..."
                text: "10"
                font.pixelSize: 16
                padding: 12
                background: Rectangle {
                    color: "white"
                    radius: 8
                    border.color: "#3498db"
                    border.width: 1
                }
            }

            Button {
                id: fetchButton
                text: "Fetch"
                font.pixelSize: 16
                padding: 12
                background: Rectangle {
                    color: "#3498db"
                    radius: 8
                }
                contentItem: Text {
                    text: fetchButton.text
                    font: fetchButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    QtCryptoController.fetchTopCryptos(fetchField.text, "1d")
                }
            }
        }

        Row {
            id: searchSection
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 30
            spacing: 10

            TextField {
                id: searchField
                width: 300
                placeholderText: "Search for a crypto..."
                font.pixelSize: 16
                padding: 12
                background: Rectangle {
                    color: "white"
                    radius: 8
                    border.color: "#3498db"
                    border.width: 1
                }
            }

            Button {
                id: searchButton
                text: "Search"
                font.pixelSize: 16
                padding: 12
                background: Rectangle {
                    color: "#3498db"
                    radius: 8
                }
                contentItem: Text {
                    text: searchButton.text
                    font: searchButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    QtCryptoController.search(searchField.text)
                }
            }
        }
    }

    Rectangle {
        id: mainSection
        color: "#f5f6fa"
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
                visible: false
                policy: ScrollBar.AlwaysOn
                width: 10
                background: Rectangle {
                    color: "lightgrey"
                }
                contentItem: Rectangle {
                    implicitWidth: 10
                    implicitHeight: 50
                    radius: 5
                    color: "#3498db"
                }
            }
            onCountChanged: scrollBar.visible = count > 0

            delegate: CryptoItem {}
        }
    }
}