/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Item{
    id: phonesRect
    height: childrenRect.height
    width: parent.width
    anchors {left: parent.left; right: parent.right}

    property variant newDetailsModel: null
    property int rIndex: -1
    property bool updateMode: false 
    property bool validInput: false 
    property int itemMargins: 10

    property string homeContext: qsTr("Home")
    property string workContext: qsTr("Work")
    property string otherContext: qsTr("Other")
    property string mobileContext: qsTr("Mobile")
    property string phoneHeaderLabel: qsTr("Phone numbers")
    property string addPhone: qsTr("Add number")
    property string defaultPhone: qsTr("Phone number")
    property string cancelLabel: qsTr("Cancel")
    property string addLabel: qsTr("Add")

    function parseDetailsModel(existingDetailsModel, contextModel) {
        var arr = new Array();
        for (var i = 0; i < existingDetailsModel.length; i++)
            arr[i] = {"phone": existingDetailsModel[i], "type": contextModel[i]};

        return arr;
    }

    function getInitFields() {
        return {"phone" : "", "type" : ""};
    }

    function getNewDetailValues() {
        var phoneNumList = new Array();
        var phoneTypeList = new Array();
        var count = 0;
        for (var i = 0; i < newDetailsModel.count; i++) {
            if (newDetailsModel.get(i).phone != "") {
                phoneNumList[count] = newDetailsModel.get(i).phone;
                phoneTypeList[count] = newDetailsModel.get(i).type;
                count = count + 1;
            }
        }

        return {"numbers": phoneNumList, "types": phoneTypeList};
    }

    function getDetails(reset) {
        var arr = {"phone": data_phone.text, 
                   "type": phoneComboBox.model[phoneComboBox.selectedIndex]};

        if (reset)
            resetFields();

        return arr;
    }

    function resetFields() {
       data_phone.text = "";
       phoneComboBox.title = mobileContext;
    }

    function getIndexVal(type) {
        if (updateMode) {
            for (var i = 0; i < phoneComboBox.model.length; i++) {
                if (phoneComboBox.model[i] == newDetailsModel.get(rIndex).type)
                    return i;
            }
        }
        return 0;
    }

    DropDown {
        id: phoneComboBox

        property int marginTotal: 4*anchors.leftMargin

        anchors {left: parent.left; leftMargin: itemMargins;}
        titleColor: theme_fontColorNormal

        width: Math.round(parent.width/2) - marginTotal
        maxWidth: (width > 0) ? width : Math.round(window.width/2) - marginTotal

        model: [mobileContext, homeContext, workContext, otherContext]

        title: (updateMode) ? newDetailsModel.get(rIndex).type : mobileContext
        selectedIndex: (updateMode) ? getIndexVal(newDetailsModel.get(rIndex).type) : 0
        replaceDropDownTitle: true
    }

    TextEntry {
        id: data_phone
        text: (updateMode) ? (newDetailsModel ? newDetailsModel.get(rIndex).phone : "") : ""
        defaultText: defaultPhone
        width: Math.round(parent.width/2) - 4*anchors.leftMargin
        anchors {left:phoneComboBox.right; leftMargin: itemMargins;}
        inputMethodHints: Qt.ImhDialableCharactersOnly
    }

    Binding {target: phonesRect; property: "validInput"; value: true;
             when: (data_phone.text != "")
            }

    Binding {target: phonesRect; property: "validInput"; value: false;
             when: (data_phone.text == "")
            }
}
