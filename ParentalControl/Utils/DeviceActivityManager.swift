import Foundation
import DeviceActivity
import ManagedSettings
import PLogger

final class DeviceActivityManager: ObservableObject {
    static let shared = DeviceActivityManager()

    private init() {}

    let deviceActivityCenter = DeviceActivityCenter()

    /// https://github.com/DeveloperAcademy-POSTECH/MC2-Team18-sunghoyazaza
    func handleStartDeviceActivityMonitoring(
        startTime: DateComponents,
        endTime: DateComponents,
        deviceActivityName: DeviceActivityName = .daily,
        warningTime: DateComponents = DateComponents(minute: 5)
    ) {
        let schedule: DeviceActivitySchedule
        
        if deviceActivityName == .daily {
            schedule = DeviceActivitySchedule(
                intervalStart: startTime,
                intervalEnd: endTime,
                repeats: true,
                warningTime: warningTime
            )
            
            do {
                try deviceActivityCenter.startMonitoring(deviceActivityName, during: schedule)

                PLogger.debug("\n\n")
                PLogger.debug("Start monitoring --> \(deviceActivityCenter.activities.description)")
                PLogger.debug("Schedule --> \(schedule)")
                PLogger.debug("\n\n")

            } catch {
                PLogger.error("Unexpected error: \(error).")
            }
        }
    }

    func handleStopDeviceActivityMonitoring() {
        deviceActivityCenter.stopMonitoring()
        PLogger.debug("\n\n")
        PLogger.debug("Stop monitoring --> \(deviceActivityCenter.activities.description)")
        PLogger.debug("\n\n")
    }
}

extension DeviceActivityName {
    static let daily = Self("daily")
}

extension ManagedSettingsStore.Name {
    static let daily = Self("daily")
}
