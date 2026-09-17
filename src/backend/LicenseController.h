#ifndef LICENSECONTROLLER_H
#define LICENSECONTROLLER_H

#include <QObject>
#include <QVariantMap>

class LicenseController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString tier READ tier NOTIFY tierChanged)
    Q_PROPERTY(bool isLicensed READ isLicensed NOTIFY tierChanged)

public:
    explicit LicenseController(QObject *parent = nullptr);
    ~LicenseController() = default;

    QString tier() const { return m_tier; }
    bool isLicensed() const { return m_tier == "pro"; }

    Q_INVOKABLE QVariantMap licenseInfo() const;

signals:
    void tierChanged();

private:
    QString m_tier = "free";
};

#endif // LICENSECONTROLLER_H
