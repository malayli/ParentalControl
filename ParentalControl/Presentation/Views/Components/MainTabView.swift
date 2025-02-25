import SwiftUI

struct MainTabView: View {
    @StateObject var mainTabViewModel = MainTabViewModel()
    let isParent: Bool

    var body: some View {
        TabView(selection: $mainTabViewModel.tabIndex) {
            ForEach(MainTab.allCases, id: \.self) { mainTab in
                mainTab.view(isParent: isParent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Label(
                            mainTab.labelInfo.text,
                            systemImage: mainTab.labelInfo.icon
                        )
                    }
                    .tag(mainTab.hashValue)
            }
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
