import DeviceActivity
import SwiftUI

@main
struct ScreenTimeReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        TotalActivityReport { totalChildrenActivity in
            TotalActivityView(activityReport: totalChildrenActivity)
        }
    }
}
