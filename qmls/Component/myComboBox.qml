import QtQuick.Controls 2.5
import QtQuick 2.12
//自定义下拉框
ComboBox {
    id: combobox;
    width: combWidth;
    height: combHeight;
    font.pointSize: fontSize;
    //font.family: gg.getFontFamily()
    model:["小学生","初中生","高中生","大学生","研究生","上班族"]
    signal currentDataChanged(var text);

    property real combHeight: 40;       //复选框高度
    property real combWidth: 160;       //复选框宽度
    property real combRadius: 2;
    property real popupHeight: 150;     //下拉框高度
    property real indHeight: 8;         //下拉按钮高度
    property real indWidth: 12;         //下拉按钮宽度
    property string disColor: "#333";
    property real fontSize: 10;
    property real textLeftPadding: width * 0.3;
    property real beforeIndex: 0;
    property real itemHeight: 40

    delegate: ItemDelegate {
        width: combobox.width
        contentItem: Text {
            text: modelData   //即model中的数据
            color: disColor
            font: control.font
            verticalAlignment: Text.AlignVCenter
            leftPadding: width * 0.28;
        }
//        text: combobox.model

        font.weight: combobox.currentIndex === index ? Font.DemiBold : Font.Normal
        highlighted: combobox.highlightedIndex == index
    }

    //下拉点击三角形
    indicator: Canvas {
        x: combobox.width - width - combobox.rightPadding
        y: combobox.topPadding + (combobox.availableHeight - height) / 2
        width: indWidth
        height: indHeight

        Connections {
            target: combobox
            onPressedChanged: combobox.indicator.requestPaint()
        }

        onPaint: {
            var context = getContext( "2d" );
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = combobox.pressed ? "red": allColor;
            context.fill();
        }
    }

    //显示的文字
    contentItem: Text {
        text: combobox.displayText
        font: combobox.font
        color:"#333";
        leftPadding: textLeftPadding;
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: parent.width;
        implicitHeight: parent.height;
        border.color: allColor;
        border.width: combobox.visualFocus ? 2 : 1
        radius: combRadius
    }

    popup: Popup {
        y: combobox.height - 1
        width: combobox.width
        implicitHeight: contentItem.implicitHeight
        padding: 1
        contentItem:ListView {
            clip: true
            implicitHeight: combobox.model.length * 40 < popupHeight ? combobox.model.length * 40 : popupHeight;
            model: combobox.popup.visible ? combobox.delegateModel : null
            currentIndex: combobox.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    onCurrentIndexChanged: {
        if(combobox.model && parseFloat(currentIndex) !== parseFloat(beforeIndex)) {
            beforeIndex = currentIndex;
            displayText = combobox.model[currentIndex];
            currentDataChanged(displayText);
        }
    }
}

