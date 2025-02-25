import DeviceActivity
import ManagedSettings
import SwiftUI

/// Monitors the device activity.
///
/// - Note: Optionally override any of the functions below. Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
final class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store = ManagedSettingsStore(named: .daily)
    @StateObject var scheduleViewModel = ScheduleViewModel()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        if activity == .daily {
            let appTokens = scheduleViewModel.selection.applicationTokens
            let categoryTokens = scheduleViewModel.selection.categoryTokens
            let webDomainTokens = scheduleViewModel.selection.webDomainTokens

            // Applications
            if appTokens.isEmpty {
                store.shield.applications = nil
            } else {
                store.shield.applications = appTokens
            }

            // Category
            if categoryTokens.isEmpty {
                store.shield.applicationCategories = nil
            } else {
                store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categoryTokens)
            }

            // Web domains
            if webDomainTokens.isEmpty {
                store.shield.webDomains = nil
            } else {
                store.shield.webDomains = webDomainTokens
            }
        }
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)

        if activity == .daily {
            store.clearAllSettings()
        }
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
    }

    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
    }

    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
    }

    override func eventWillReachThresholdWarning(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
    }
}
