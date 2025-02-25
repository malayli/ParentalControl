import Foundation
import SwiftUI
import FamilyControls

class PermissionViewModel: ObservableObject {
    @Published var isViewLoaded = false
    @Published var isSheetActive = false
    
    let HEADER_ICON_LABEL = "info.circle.fill"
    
    let DECORATION_TEXT_INFO = (
        imgSrc: "AppSymbol",
        title: "ParentalControl",
        subTitle: "Let's learn the basic functions of Screen Time API"
    )
    
    let PERMISSION_BUTTON_LABEL = "Get started"

    let SHEET_INFO_LIST = "ScreenTime API: You can use it to limit and monitor app/web usage at specific times."
}

extension PermissionViewModel {
    func handleTranslationView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.isViewLoaded = true
            }
        }
    }
    
    func showIsSheetActive() {
        isSheetActive = true
    }
    
    @MainActor
    func handleRequestAuthorization(for member: FamilyControlsMember,
                                    errorCompletion: @escaping (Error) -> Void) {
        FamilyControlsManager.shared.requestAuthorization(for: member, errorCompletion: errorCompletion)
    }
}
