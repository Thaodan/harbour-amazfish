import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait

    ConfigurationValue {
        id: appNotifyConnect
        key: "/uk/co/piggz/amazfish/app/notifyconnect"
        defaultValue: true
    }

    ConfigurationValue {
        id: appRefreshWeather
        key: "/uk/co/piggz/amazfish/app/refreshweather"
        defaultValue: 60
    }

    ConfigurationValue {
        id: appAutoSyncData
        key: "/uk/co/piggz/amazfish/app/autosyncdata"
        defaultValue: true
    }

    ConfigurationValue {
        id: appNotifyLowBattery
        key: "/uk/co/piggz/amazfish/app/notifylowbattery"
        defaultValue: false
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView


        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            x: Theme.horizontalPageMargin
            width: page.width - 2*Theme.horizontalPageMargin
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Application Settings")
            }

            TextSwitch {
                id: chkNotifyConnect
                width: parent.width
                text: qsTr("Notify on connect")
            }

            Slider {
                id: sldWeatherRefresh
                width: parent.width
                minimumValue: 15
                maximumValue: 120
                stepSize: 15
                label: qsTr("Refresh weather every (") + value + qsTr(") minutes")
            }

            TextSwitch {
                id: chkAutoSyncData
                width: parent.width
                text: qsTr("Sync activity data each hour")
            }

            TextSwitch {
                id: chkNotifyLowBattery
                width: parent.width
                text: qsTr("Low battery notification")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Save Settings")
                onClicked: {
                    saveSettings();
                }
            }

            TextSwitch {
                id: autostart
                //% "Start Daemon on bootup"
                text: qsTr("Start Daemon on bootup")
                description: qsTr("When this is off, the app won't work without starting the daemon first")
                automaticCheck: false
                checked: serviceEnabledState
                onClicked: {
                    if (serviceEnabledState) {
                        systemdManager.disableService();
                    } else {
                        systemdManager.enableService();
                    }
                 }
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: serviceActiveState == false ? qsTr("Start Service") : qsTr("Stop Service")

                onClicked: {
                    systemdServiceIface.call(serviceActiveState ? "Stop" : "Start", ["replace"])                }
            }

        }
    }
    Component.onCompleted: {
        chkNotifyConnect.checked = appNotifyConnect.value;
        sldWeatherRefresh.value = appRefreshWeather.value;
        chkAutoSyncData.checked = appAutoSyncData.value;
        chkNotifyLowBattery.checked = appNotifyLowBattery.value;
    }

    function saveSettings() {
        appNotifyConnect.value = chkNotifyConnect.checked;
        appRefreshWeather.value = sldWeatherRefresh.value;
        appAutoSyncData.value = chkAutoSyncData.checked;
        appNotifyLowBattery.value = chkNotifyLowBattery.checked;

        weather.refresh();
    }

}
