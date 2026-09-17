#include "LicenseController.h"

LicenseController::LicenseController(QObject *parent)
    : QObject(parent)
{
}

QVariantMap LicenseController::licenseInfo() const
{
    QVariantMap info;
    info["tier"] = m_tier;
    info["isLicensed"] = isLicensed();
    return info;
}
