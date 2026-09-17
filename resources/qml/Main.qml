import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import OpenType 1.0

Window {
    id: appWindow
    visible: true
    width: 1024
    height: 640
    minimumWidth: 800
    minimumHeight: 500
    title: "OpenType"
    color: theme.bg

    Theme { id: theme }

    Loader {
        id: screenLoader
        anchors.fill: parent
        sourceComponent: homeScreen
    }

    Component {
        id: homeScreen
        HomeScreen {
            onStartPractice: screenLoader.sourceComponent = practiceScreen
            onGoStats: screenLoader.sourceComponent = statsScreen
        }
    }

    Component {
        id: practiceScreen
        PracticeScreen {
            onGoHome: screenLoader.sourceComponent = homeScreen
            onGoResults: function(data) { screenLoader.sourceComponent = resultsView }
        }
    }

    Component {
        id: statsScreen
        StatsScreen {
            onGoHome: screenLoader.sourceComponent = homeScreen
        }
    }

    Component {
        id: resultsView
        ResultsView {
            onGoHome: screenLoader.sourceComponent = homeScreen
            onRestart: screenLoader.sourceComponent = practiceScreen
        }
    }
}
