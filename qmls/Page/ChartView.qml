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
    property var topdot: 20
    property var currentday: 0

    background: Rectangle{
        anchors.fill: parent
        color: backcolor
    }
    //添加饼状图分析
    Rectangle
    {
        id:bztRec
        width: parent.width
        height: parent.height * 0.499
        color: "transparent"
        anchors.top: parent.top
        ChartView {
            id:chartPage
            anchors.fill: parent
            title: "单词记忆统计图"
            titleColor: "black"
            titleFont.pixelSize: dp(8)
            titleFont.bold: true
            legend.visible: false
            theme: ChartView.ChartThemeQt
            antialiasing: true						//抗锯齿
            backgroundColor: backcolor
            PieSeries {
                id: pieSeries
                //value的值并不是百分比，而是你任意指定的值，指定值 / 所有值 = 百分比
                PieSlice {id:p1;  label: "陌生:"; color: "#e6a0c4"; labelVisible: true
                    onClicked: labelVisible = !labelVisible
                }                    //0
                PieSlice {id:p2;  label: "一般:"; color: "#c6cdf7"; labelVisible: true
                    onClicked: labelVisible = !labelVisible}                    //1-2
                PieSlice {id:p3;  label: "熟悉:"; color: "#ffbb27"; labelVisible: true
                    onClicked: labelVisible = !labelVisible}                    //2-4
                PieSlice {id:p4;  label: "牢记:"; color: "#7294d4"; labelVisible: true
                    onClicked: labelVisible = !labelVisible}                    //5
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
                    ListElement{recColor:"#e6a0c4";name:"陌生"}
                    ListElement{recColor:"#c6cdf7";name:"一般"}
                    ListElement{recColor:"#ffbb27";name:"熟悉"}
                    ListElement{recColor:"#7294d4";name:"牢记"}
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

    Rectangle{
        id:tmprec
        width: parent.width
        height: dp(0.15)
        anchors.top: bztRec.bottom
    }

    //折线图分析
    ChartView{
        id:cp
        width: parent.width
        height: parent.height * 0.48
        anchors.top: tmprec.bottom
        backgroundColor: "transparent"
        title: "单词默写统计图"
        DateTimeAxis{
            id:myDateTimeAxis
            min:dateManager.getTime(-6)
            max:dateManager.getTime(0)
            tickCount: 7
            labelsFont.pointSize: 9
            labelsFont.bold: true
            format: "MM-dd"
        }

        ValueAxis{
            id:axisy
            max:50;
            min:0;
        }
        LineSeries {
            id:sp
            color: "#7ae677"
            width: 2
            name:"答题总数"
            axisX: myDateTimeAxis
            axisY: axisy
        }
        LineSeries {
            id:sp2
            color: "#dd3032"
            width: 2
            name:"正确题数"
            axisX: myDateTimeAxis
            axisY: axisy
        }
    }

    //左箭头
    Canvas{
        id:canvasleft
        height: dp(400)
        width: dp(400)

        onPaint: {
            var ctx = canvasleft.getContext("2d")
            //左箭头
            ctx.moveTo(120,450)
            ctx.lineTo(105,458)
            ctx.lineTo(120,466)
            //右箭头
            ctx.moveTo(360,450)
            ctx.lineTo(375,458)
            ctx.lineTo(360,466)
            ctx.lineWidth = 2;
            ctx.strokeStyle = 'black';
            ctx.stroke();
        }
        //左
        Rectangle{
            width: 20
            height: 20
            x: 105
            y: 450
            color: "transparent"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    currentday = currentday - 7
                    insertDateToSP(currentday)
                }
            }
        }
        //右
        Rectangle{
            width: 20
            height: 20
            x: 360
            y: 450
            color: "transparent"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(currentday < 0)
                    {
                        currentday += 7
                        insertDateToSP(currentday)
                    }
                }
            }
        }
    }

    function insertDateToSP(day)
    {
        myDateTimeAxis.min = dateManager.getTime(day -6)
        myDateTimeAxis.max = dateManager.getTime(day)
        sp.clear()
        for(var i = 0 ; i < 7 ; ++i)
        {
            var tmp = dateManager.getNum(root.userSno,day + i - 6 , true);
            topdot = topdot > tmp ? topdot : tmp;
            sp.insert(i,dateManager.getTime(day + i - 6).getTime(),tmp);
        }

        sp2.clear()
        for(var j = 0 ; j < 7 ; ++j)
        {
            var tmp2 = dateManager.getNum(root.userSno,day + j - 6 , false);
            topdot = topdot > tmp2 ? topdot : tmp2;
            sp2.insert(i,dateManager.getTime(day + j - 6).getTime(),tmp2);
        }
    }


    onVisibleChanged: {
        if(visible)
        {
            //折线图
            insertDateToSP(currentday)
            axisy.max = topdot

            //扇形图
            bl = []
            var tmp = wordDB.calculateWord(root.userSno);
            var sum = 0;
            for(var i = 0; i < 4; ++i)
            {
                bl.push(tmp[i])
                sum += bl[i];
                console.log("The result is = ",bl[i])
            }
            p1.value = bl[0];
            p1.label = (bl[0]/sum * 100).toFixed(2) + "%"
            console.log("陌生:"  ,p1.label)
            p1.labelVisible = p1.value != 0
            p2.value = bl[1];
            p2.label = (bl[1]/sum * 100).toFixed(2) + "%"
            console.log("一般:"  ,p2.label,"and ", p2.value )
            p2.labelVisible = p2.value != 0
            p3.value = bl[2];
            p3.label = (bl[2]/sum * 100).toFixed(2) + "%"
            console.log("熟悉:"  ,p3.label,"and ",p3.value )
            p3.labelVisible = p3.value != 0
            p4.value = bl[3];
            p4.label = (bl[3]/sum * 100).toFixed(2) + "%"
            console.log("牢记:"  ,p4.label )
            p4.labelVisible = p4.value != 0
        }
    }
}
