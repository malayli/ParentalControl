import Foundation
import SwiftUI

final class MainTabViewModel: ObservableObject {
    @Published var tabIndex = 0
}

enum MainTab: CaseIterable {
    case settings
    case report
    
    @ViewBuilder
    func view(isParent: Bool) -> some View {
        switch self {
        case .settings:
            SettingsView(isParent: isParent)
        case .report:
            MonitoringView()
        }
    }
    
    var labelInfo: (text: String, icon: String) {
        switch self {
        case .settings:
            (text: "Settings", icon: "person.badge.shield.checkmark.fill")
        case .report:
            (text: "Report", icon: "chart.bar.xaxis")
        }
    }
}
