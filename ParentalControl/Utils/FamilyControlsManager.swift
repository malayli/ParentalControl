import Foundation
import FamilyControls
import PLogger

class FamilyControlsManager: ObservableObject {
    let authorizationCenter = AuthorizationCenter.shared
    @Published var hasScreenTimePermission: Bool = false
    private(set) var isParent: Bool = UserDefaults.standard.bool(forKey: "isParent")
    static let shared = FamilyControlsManager()

    private init() {}

    @MainActor
    func requestAuthorization(for member: FamilyControlsMember, errorCompletion: @escaping (Error) -> Void) {
        if authorizationCenter.authorizationStatus == .approved {
            PLogger.debug("ScreenTime Permission approved")

        } else {
            Task {
                do {
                    try await authorizationCenter.requestAuthorization(for: member)
                    hasScreenTimePermission = true
                    UserDefaults.standard.set(member == .individual, forKey: "isParent")
                    isParent = UserDefaults.standard.bool(forKey: "isParent")

                } catch {
                    hasScreenTimePermission = false
                    errorCompletion(error)
                }
            }
        }
    }

    func requestAuthorizationStatus() -> AuthorizationStatus {
        authorizationCenter.authorizationStatus
    }

    func requestAuthorizationRevoke() {
        authorizationCenter.revokeAuthorization(completionHandler: { result in
            switch result {
            case .success:
                PLogger.debug("Success")
            case .failure(let failure):
                PLogger.error("\(failure) - failed revoke Permission")
            }
        })
    }

    func updateAuthorizationStatus(authStatus: AuthorizationStatus) {
        switch authStatus {
        case .notDetermined:
            hasScreenTimePermission = false
        case .denied:
            hasScreenTimePermission = false
        case .approved:
            hasScreenTimePermission = true
        @unknown default:
            fatalError("There is no processing for the requested permission type.")
        }
    }
}
