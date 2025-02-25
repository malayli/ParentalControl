import Foundation
import FamilyControls
import SwiftUI

enum ScheduleSectionInfo {
    case time
    case apps
    case monitoring
    case revoke
    
    var header: String {
        switch self {
        case .time:
            "Setup Time"
        case .apps:
            "Setup Apps"
        case .monitoring:
            "Stop Schedule Monitoring"
        case .revoke:
            "Revoke Authorization"
        }
    }
    
    var footer: String {
        switch self {
        case .time:
            "You can set a schedule time when you want to limit app usage by setting a start time and end time."
        case .apps:
            "You can select the apps and web domains you want to restrict usage for during the selected time by clicking the Change button."
        case .monitoring:
            "Stops monitoring the schedule that is currently being monitored."
        case .revoke:
            ""
        }
    }
}

class ScheduleViewModel: ObservableObject {
    @AppStorage("scheduleStartTime", store: UserDefaults(suiteName: Bundle.main.appGroupName))
    var scheduleStartTime = Date()
    @AppStorage("scheduleEndTime", store: UserDefaults(suiteName: Bundle.main.appGroupName))
    var scheduleEndTime = Date() + 900
    @AppStorage("selection", store: UserDefaults(suiteName: Bundle.main.appGroupName))
    var selection = FamilyActivitySelection()

    @Published var isFamilyActivitySectionActive = false
    @Published var isSaveAlertActive = false
    @Published var isRevokeAlertActive = false
    @Published var isStopMonitoringAlertActive = false
    
    private func resetAppGroupData() {
        scheduleStartTime = Date()
        scheduleEndTime = Date() + 900
        selection = FamilyActivitySelection()
    }
}

extension ScheduleViewModel {
    func showFamilyActivitySelection() {
        isFamilyActivitySectionActive = true
    }

    func showRevokeAlert() {
        isRevokeAlertActive = true
    }

    func saveSchedule(selectedApps: FamilyActivitySelection) {
        selection = selectedApps
        
        let startTime = Calendar.current.dateComponents([.hour, .minute], from: scheduleStartTime)
        let endTime = Calendar.current.dateComponents([.hour, .minute], from: scheduleEndTime)
        
        DeviceActivityManager.shared.handleStartDeviceActivityMonitoring(
            startTime: startTime,
            endTime: endTime
        )
        
        isSaveAlertActive = true
    }

    func stopScheduleMonitoring() {
        DeviceActivityManager.shared.handleStopDeviceActivityMonitoring()
        resetAppGroupData()
    }

    func showStopMonitoringAlert() {
        isStopMonitoringAlertActive = true
    }
}

// MARK: - FamilyActivitySelection Parser
extension FamilyActivitySelection: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
// MARK: - Date Parser
extension Date: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(Date.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
