import QtQuick 2.0
import QtCharts 2.3
import QtQuick.Controls 2.5
import QtQuick 2.12
Page
{
    id:page
    anchors.fill: parent
    property var backcolor: "#b5a6b7"
    opacity: 0
    visible: opacity > 0
    enabled: visible
    property var bl: []
    background: Rectangle{
        anchors.fill: parent
        color: backcolor
    }

    Rectangle
    {
        width: parent.width
        height: parent.height * 0.5
        color: "transparent"
        anchors.top: parent.top
        //添加饼状图分析
        ChartView {
            id:chartPage
            anchors.fill: parent
            title: "单词记忆统计图"
            titleColor: "black"
            titleFont.pixelSize: dp(10)
            titleFont.bold: true
            legend.visible: false
            theme: ChartView.ChartThemeQt
            antialiasing: true						//抗锯齿
            backgroundColor: backcolor
            PieSeries {
                id: pieSeries
                //value的值并不是百分比，而是你任意指定的值，指定值 / 所有值 = 百分比
                PieSlice {id:p1;  label: "陌生:"; color: "#c6c6bc"; labelVisible: true}                    //0
                PieSlice {id:p2;  label: "一般:"; color: "#e3ddbd"; labelVisible: true}                    //1-2
                PieSlice {id:p3;  label: "熟悉:"; color: "#d3c2ba"; labelVisible: true}                    //2-4
                PieSlice {id:p4;  label: "牢记:"; color: "#869f82"; labelVisible: true}                    //5
            }
        }
        Row{
            width: dp(16) * 4 + dp(3) * 3
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: (parent.width - width) / 2
            height: dp(10)
            spacing: dp(3)
            Repeater{
                model: ListModel{
                    ListElement{recColor:"#c6c6bc";name:"陌生"}
                    ListElement{recColor:"#e3ddbd";name:"一般"}
                    ListElement{recColor:"#d3c2ba";name:"熟悉"}
                    ListElement{recColor:"#869f82";name:"牢记"}
                }
                Rectangle{
                    color: "transparent"
                    width: dp(16)
                    height: dp(5)
                    //色块图
                    Rectangle{
                        id:crec
                        width: dp(5)
                        height: parent.height
                        color: recColor
                        anchors.left: parent.left
                    }
                    //显示
                    Rectangle{
                        color: "transparent"
                        height: parent.height
                        width: parent.width - crec.width
                        anchors.right: parent.right
                        Text {
                            anchors.centerIn: parent
                            text: name
                        }
                    }
                }
            }
        }
    }
    onVisibleChanged: {
        if(visible)
        {
            var tmp = wordDB.calculateWord(root.userSno);
            var sum = 0;
            for(var i = 0; i < 4; ++i)
            {
                bl.push(tmp[i])
                sum += bl[i];
                console.log("The result is = ",bl[i])
            }
            p1.value = bl[0];
            p1.label = "陌生:" + (bl[0]/sum).toFixed(4) * 100 + "%"
            p1.labelVisible = p1.value != 0
            p2.value = bl[1];
            p2.label = "一般:" + (bl[1]/sum).toFixed(4) * 100 + "%"
            p2.labelVisible = p2.value != 0
            p3.value = bl[2];
            p3.label = "熟悉:" + (bl[2]/sum).toFixed(4) * 100 + "%"
            p3.labelVisible = p3.value != 0
            p3.value = bl[3];
            p4.label = "牢记:" + (bl[3]/sum).toFixed(4) * 100 + "%"
            p4.labelVisible = p4.value != 0
        }
    }
}
