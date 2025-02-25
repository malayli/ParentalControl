import Foundation
import ManagedSettings

struct SettingsViewModel {
    private let store = ManagedSettingsStore(named: .daily)

    // MARK: - WebContentSettings

    func blockWebDomain(urlString: String) {
        let setWebDomain: Set<WebDomain> = [WebDomain(domain: urlString)]
        store.webContent.blockedByFilter = .specific(setWebDomain)
    }

    func blockAllWebDomains() {
        store.webContent.blockedByFilter = .all(except: [])
    }

    // MARK: - ApplicationSettings

    func blockApp(with bundleIdentifier: String) {
        let apps: Set<Application> = [Application(bundleIdentifier: bundleIdentifier)]
        store.application.blockedApplications = .init(apps)
    }

    func denyAppRemoval(_ value: Bool) {
        store.application.denyAppRemoval = value
    }

    func denyAppInstallation(_ value: Bool) {
        store.application.denyAppInstallation = value
    }

    // MARK: - AppStoreSettings

    func denyInAppPurchases(_ value: Bool) {
        store.appStore.denyInAppPurchases = value
    }

    func requirePasswordForPurchases(_ value: Bool) {
        store.appStore.requirePasswordForPurchases = value
    }

    func set(maximumRating: Int) {
        store.appStore.maximumRating = maximumRating
    }

    // MARK: - PasscodeSettings

    func lockPasscode(_ value: Bool) {
        store.passcode.lockPasscode = value
    }

    // MARK: - SafariSettings

    func set(cookiePolicy: SafariSettings.CookiePolicy) {
        store.safari.cookiePolicy = cookiePolicy
    }

    func denyAutoFill(_ value: Bool) {
        store.safari.denyAutoFill = value
    }

    // MARK: - AccountSettings

    func lockAccounts(_ value: Bool) {
        store.account.lockAccounts = value
    }
}
