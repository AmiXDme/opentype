pragma Singleton
import QtQuick
import OpenType 1.0

QtObject {
    id: appGlobals

    property ProfileManager profileManager
    property ThemeCatalog themeCatalog
    property LicenseController licenseController
}