import SwiftUI

struct ParentalView: View {
    let isParent: Bool

    var body: some View {
        MainTabView(isParent: isParent)
    }
}
