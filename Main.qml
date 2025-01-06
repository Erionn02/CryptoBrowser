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
                visible: false
                policy: ScrollBar.AlwaysOn
                width: 20
                background: Rectangle {
                    color: "lightgrey"
                    radius: 5
                }
                contentItem: Rectangle {
                    implicitWidth: 20
                    implicitHeight: 20
                    radius: 5
                    color: "grey"
                }
            }
            onCountChanged: scrollBar.visible = count > 0

            delegate: CryptoItem {}
        }
    }
}
