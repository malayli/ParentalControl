import SwiftUI

@main
struct ParentalControlApp: App {
    @StateObject var familyControlsManager = FamilyControlsManager.shared
    @StateObject var scheduleViewModel = ScheduleViewModel()

    var body: some Scene {
        WindowGroup {
            VStack {
                if familyControlsManager.isParent {
                    ParentalView(isParent: familyControlsManager.isParent)

                } else {
                    if !familyControlsManager.hasScreenTimePermission {
                        PermissionView()
                    } else {
                        ParentalView(isParent: familyControlsManager.isParent)
                    }
                }
            }
            .onReceive(familyControlsManager.authorizationCenter.$authorizationStatus) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    familyControlsManager.updateAuthorizationStatus(authStatus: newValue)
                }
            }
            .environmentObject(familyControlsManager)
            .environmentObject(scheduleViewModel)
        }
    }
}
