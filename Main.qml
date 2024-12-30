import QtQuick
import QtQuick.Controls

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
        }



    }

}
