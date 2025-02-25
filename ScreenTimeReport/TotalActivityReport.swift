import DeviceActivity
import SwiftUI

struct TotalActivityReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .totalChildrenActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (ActivityReport) -> TotalActivityView

    func makeConfiguration(
        representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityReport {
        // Reformat the data into a configuration that can be used to create
        // the report's view.
        var totalActivityDuration: Double = 0
        var list: [AppDeviceActivity] = []

        for await eachData in data {
            for await activitySegment in eachData.activitySegments {
                for await categoryActivity in activitySegment.categories {
                    for await applicationActivity in categoryActivity.applications {
                        let appName = (applicationActivity.application.localizedDisplayName ?? "nil")
                        let bundle = (applicationActivity.application.bundleIdentifier ?? "nil")
                        let duration = applicationActivity.totalActivityDuration
                        totalActivityDuration += duration
                        let numberOfPickups = applicationActivity.numberOfPickups
                        let token = applicationActivity.application.token
                        let appActivity = AppDeviceActivity(
                            id: bundle,
                            displayName: appName,
                            duration: duration,
                            numberOfPickups: numberOfPickups,
                            token: token
                        )
                        list.append(appActivity)
                    }
                }

            }
        }
        return ActivityReport(totalDuration: totalActivityDuration, apps: list)
    }
}
