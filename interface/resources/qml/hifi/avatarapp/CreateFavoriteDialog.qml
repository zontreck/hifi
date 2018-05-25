import Hifi 1.0 as Hifi
import QtQuick 2.5
import "../../styles-uit"
import "../../controls-uit" as HifiControlsUit
import "../../controls" as HifiControls

Rectangle {
    id: root;
    visible: false;
    anchors.fill: parent;
    color: Qt.rgba(0, 0, 0, 0.5);
    z: 999;

    property bool keyboardEnabled: true
    property bool keyboardRaised: false
    property bool punctuationMode: false

    property string titleText: 'Create Favorite'
    property string favoriteNameText: favoriteName.text
    property string avatarImageUrl: null
    property int wearablesCount: 0

    property string button1color: hifi.buttons.noneBorderlessGray;
    property string button1text: 'CANCEL'
    property string button2color: hifi.buttons.blue;
    property string button2text: 'CONFIRM'

    property var avatars;
    property var onSaveClicked;
    property var onCancelClicked;

    function open(wearables, thumbnail) {
        favoriteName.text = '';
        favoriteName.forceActiveFocus();

        avatarImageUrl = thumbnail;
        wearablesCount = wearables;

        visible = true;
    }

    function close() {
        console.debug('closing');
        visible = false;
    }

    HifiConstants {
        id: hifi
    }

    // This object is always used in a popup.
    // This MouseArea is used to prevent a user from being
    //     able to click on a button/mouseArea underneath the popup.
    MouseArea {
        anchors.fill: parent;
        propagateComposedEvents: false;
        hoverEnabled: true;
    }

    Rectangle {
        id: mainContainer;
        width: Math.max(parent.width * 0.8, 400)
        property int margin: 30;

        height: childrenRect.height + margin * 2
        onHeightChanged: {
            console.debug('mainContainer: height = ', height)
        }

        anchors.centerIn: parent

        color: "white"

        TextStyle1 {
            id: title
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 30
            anchors.leftMargin: 30
            anchors.rightMargin: 30

            text: root.titleText
        }

        Item {
            id: contentContainer
            width: parent.width - 50
            height: childrenRect.height

            anchors.top: title.bottom
            anchors.topMargin: 20
            anchors.left: parent.left;
            anchors.leftMargin: 30;
            anchors.right: parent.right;
            anchors.rightMargin: 30;

            AvatarThumbnail {
                id: avatarThumbnail
                avatarUrl: avatarImageUrl
                onAvatarUrlChanged: {
                    console.debug('CreateFavoritesDialog: onAvatarUrlChanged: ', avatarUrl);
                }

                wearablesCount: avatarWearablesCount
            }

            InputTextStyle4 {
                id: favoriteName
                anchors.right: parent.right
                height: 40
                anchors.left: avatarThumbnail.right
                anchors.leftMargin: 44
                anchors.verticalCenter: avatarThumbnail.verticalCenter
                placeholderText: "Enter Favorite Name"

                RalewayRegular {
                    id: wrongName
                    anchors.top: parent.bottom;
                    anchors.topMargin: 2

                    anchors.right: parent.right;
                    text: 'Favorite name exists'
                    size: 15
                    color: 'red'
                    visible: {
                        for(var i = 0; i < avatars.count; ++i) {
                            var avatarName = avatars.get(i).name;
                            if(avatarName === favoriteName.text) {
                                return true;
                            }
                        }

                        return false;
                    }
                }
            }

            HifiControlsUit.Keyboard {
                id: keyboard
                raised: root.keyboardEnabled && root.keyboardRaised
                numeric: root.punctuationMode
                anchors {
                    top: avatarThumbnail.bottom
                    topMargin: 20
                    left: parent.left
                    right: parent.right
                }
            }
        }

        DialogButtons {
            anchors.top: contentContainer.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 30

            yesButton.enabled: favoriteNameText !== ''
            yesText: root.button2text
            noText: root.button1text

            onYesClicked: function() {
                if(onSaveClicked) {
                    onSaveClicked();
                } else {
                    root.close();
                }
            }

            onNoClicked: function() {
                if(onCancelClicked) {
                    onCancelClicked();
                } else {
                    root.close();
                }
            }
        }
    }
}
