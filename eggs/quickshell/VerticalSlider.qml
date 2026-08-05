import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: wrapper
    implicitHeight: 256
    implicitWidth: slider.width + sideMargins * 2

    property alias value: slider.value
    property alias to: slider.to
    property alias stepSize: slider.stepSize

    property int lineCount: 21
    property int labelCount: 6
    property real sideMargins: Math.max(labels.width + lineIndicators.width, rightIndicator.width)
    property real visualMultiplier: 100
    property real magicNumber: 1.3

    ColumnLayout {
        id: labels
        anchors.right: lineIndicators.left
        y: topPadding
        spacing: (slider.availableHeight - topPadding - labelHeight * labelCount - magicNumber) / (labelCount - 1)

        readonly property real labelHeight: 20
        readonly property real topPadding: 4

        Repeater {
            id: labelRep
            model: labelCount
            delegate: Label {
                Layout.alignment: Qt.AlignRight
                Layout.preferredHeight: labels.labelHeight
                text: Math.round((to - index * to / (labelCount - 1)) * visualMultiplier)
            }
        }
    }

    RowLayout {
        id: lineIndicators
        anchors.right: slider.left
        y: handle.height / 2
        ColumnLayout {
            readonly property real magicNumber: 1.55
            spacing: (slider.availableHeight - lineRep.lineHeight * lineCount - handle.height + magicNumber) / (lineCount - 1)
            Repeater {
                id: lineRep
                readonly property int lineHeight: 1
                model: lineCount
                delegate: Rectangle {
                    property bool isEven: index % 2 === 0
                    color: Theme.mutedForeground
                    Layout.alignment: Qt.AlignRight
                    height: lineRep.lineHeight
                    width: isEven ? 10 : 7
                    opacity: isEven ? 1 : 0.65
                }
            }
        }
    }

    Slider {
        id: slider
        x: sideMargins
        orientation: Qt.Vertical
        snapMode: Slider.SnapAlways
        implicitHeight: wrapper.height
        handle: Rectangle {
            id: handle
            y: parent.visualPosition * (parent.availableHeight - height + 1)
            implicitWidth: 15
            implicitHeight: 26
            color: slider.hovered || slider.pressed ? Theme.muted : Theme.background
            border.color: Theme.border
            Rectangle {
                readonly property int padding: 8
                x: parent.x + padding / 2
                y: parent.height / 2
                height: 1
                width: parent.width - padding
                color: Theme.mutedForeground
            }
            Label {
                id: rightIndicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.right
                text: `${Math.round(slider.value * visualMultiplier)}`
            }
        }
    }
}
