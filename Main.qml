import QtQuick
import QtQuick.Controls
import com.company.QtCryptoController

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("CryproBrowser")

    // generate appealing ui that will contain search bar and search results, the results can be added to some storage
    // that is not really appealing, make it prettier, also the search button does not fit the search field
    // make it prettier

    Rectangle {
        id: searchSection
        color: "lightgrey"
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 50

        TextField {
            id: searchField
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 20
            }
            width: 200
            placeholderText: "Search"
        }

        Button {
            id: searchButton
            anchors {
                left: searchField.right
                verticalCenter: parent.verticalCenter
                leftMargin: 10
            }
            text: "Search"
            onClicked: {
                QtCryptoController.fetchSome()
            }
        }
    }

    Rectangle {
        id: mainSection
        color: "red"
        anchors {
            top: searchSection.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        ListView {
            id: cryptoList
            anchors.fill: parent
            model: QtCryptoController

            delegate: Rectangle {
                id: delegate

                width: cryptoList.width
                height: 50

                required property string cryptoName
                required property string cryptoSymbol
                required property double cryptoPrice
                required property double cryptoMarketCap;
                required property double cryptoChange24H;
                required property string cryptoLogo;
                Flow {
                    anchors.fill: parent
                    spacing: 10
                    Image {
                        source: "data:image/png;base64," + delegate.cryptoLogo
                    }
                    Text {
                        text: delegate.cryptoName
                    }
                    Text {
                        text: delegate.cryptoSymbol
                    }
                    Text {
                        text: delegate.cryptoPrice
                    }
                    Text {
                        text: delegate.cryptoMarketCap
                    }
                    Text {
                        text: delegate.cryptoChange24H
                    }
                }
            }
        }
    }

}
