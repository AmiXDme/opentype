import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Dialog {
    id: root

    title: "Account"
    modal: true
    width: 400
    height: 350

    background: Rectangle {
        color: Theme.bg
        radius: Theme.rlg
        border.color: Theme.border
        border.width: 1
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Text {
            text: "Account"
            color: Theme.text
            font.pixelSize: 18
            font.weight: Font.Bold
        }

        Card {
            Layout.fillWidth: true
            pad: 16

            ColumnLayout {
                spacing: 8

                Text {
                    text: "Account ID"
                    color: Theme.textMid
                    font.pixelSize: 12
                }

                Text {
                    text: LicenseController.tier === "pro" ? "Pro License Active" : "Free Tier"
                    color: LicenseController.tier === "pro" ? Theme.good : Theme.text
                    font.pixelSize: 14
                    font.weight: Font.Medium
                }

                Text {
                    text: LicenseController.tier === "pro"
                        ? "All features unlocked"
                        : "Upgrade to Pro for random themes and advanced analytics"
                    color: Theme.textDim
                    font.pixelSize: 12
                }
            }
        }

        Item { Layout.fillHeight: true }

        RowLayout {
            Layout.fillWidth: true

            Item { Layout.fillWidth: true }

            AppButton {
                text: "Close"
                onClicked: root.close()
            }
        }
    }
}
