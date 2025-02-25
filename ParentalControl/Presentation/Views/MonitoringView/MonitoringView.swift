import DeviceActivity
import SwiftUI
import ManagedSettings

struct MonitoringView: View {
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @State private var filter = DeviceActivityFilter(
        segment: .daily(during: .present)
    )

    var body: some View {
        VStack {
            DeviceActivityReport(.totalChildrenActivity, filter: filter)
            Text("Start: \(scheduleViewModel.scheduleStartTime)")
            Text("End: \(scheduleViewModel.scheduleEndTime)")
        }
        .onAppear {
            filter = DeviceActivityFilter(segment: .daily(during: .present),
                                          users: .children,
                                          devices: .all,
                                          applications: scheduleViewModel.selection.applicationTokens,
                                          categories: scheduleViewModel.selection.categoryTokens,
                                          webDomains: scheduleViewModel.selection.webDomainTokens
            )
        }
    }
}
