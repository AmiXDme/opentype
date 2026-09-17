#ifndef APPGLOBALS_H
#define APPGLOBALS_H

#include <QObject>
#include "ProfileManager.h"
#include "ThemeCatalog.h"
#include "LicenseController.h"

class AppGlobals : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ProfileManager* profileManager READ profileManager CONSTANT)
    Q_PROPERTY(ThemeCatalog* themeCatalog READ themeCatalog CONSTANT)
    Q_PROPERTY(LicenseController* licenseController READ licenseController CONSTANT)

public:
    explicit AppGlobals(QObject *parent = nullptr)
        : QObject(parent)
        , m_profileManager(new ProfileManager(this))
        , m_themeCatalog(new ThemeCatalog(this))
        , m_licenseController(new LicenseController(this))
    {}

    ProfileManager* profileManager() const { return m_profileManager; }
    ThemeCatalog* themeCatalog() const { return m_themeCatalog; }
    LicenseController* licenseController() const { return m_licenseController; }

private:
    ProfileManager *m_profileManager;
    ThemeCatalog *m_themeCatalog;
    LicenseController *m_licenseController;
};

#endif // APPGLOBALS_H