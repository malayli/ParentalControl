import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.

// MARK: - ShieldView
class ShieldConfigurationExtension: ShieldConfigurationDataSource {

    ///  https://developer.apple.com/documentation/managedsettingsui/shieldconfiguration
    private func setShieldConfig(
        _ tokenName: String,
        hasSecondaryButton: Bool = false) -> ShieldConfiguration {
            let CUSTOM_ICON = UIImage(named: "AppSymbol.png")
        let CUSTOM_TITLE = ShieldConfiguration.Label(
            text: "ParentalControl",
            color: ColorManager.accentColor
        )
        let CUSTOM_SUBTITLE = ShieldConfiguration.Label(
            text: "\(tokenName) has restricted use.",
            color: .black
        )
        let CUSTOM_PRIMARY_BUTTON_LABEL = ShieldConfiguration.Label(
            text: "Exit",
            color: .white
        )
        let CUSTOM_PRIAMRY_BUTTON_BACKGROUND: UIColor = ColorManager.accentColor
        let CUSTOM_SECONDARY_BUTTON_LABEL = ShieldConfiguration.Label(
            text: "Pressing has no effect",
            color: ColorManager.accentColor
        )
        
        let ONE_BUTTON_SHIELD_CONFIG = ShieldConfiguration(
            backgroundBlurStyle: .systemChromeMaterialLight,
            backgroundColor: .white,
            icon: CUSTOM_ICON,
            title: CUSTOM_TITLE,
            subtitle: CUSTOM_SUBTITLE,
            primaryButtonLabel: CUSTOM_PRIMARY_BUTTON_LABEL,
            primaryButtonBackgroundColor: CUSTOM_PRIAMRY_BUTTON_BACKGROUND
        )
        
        let TWO_BUTTON_SHIELD_CONFIG = ShieldConfiguration(
            backgroundBlurStyle: .systemChromeMaterialLight,
            backgroundColor: .white,
            icon: CUSTOM_ICON,
            title: CUSTOM_TITLE,
            subtitle: CUSTOM_SUBTITLE,
            primaryButtonLabel: CUSTOM_PRIMARY_BUTTON_LABEL,
            primaryButtonBackgroundColor: CUSTOM_PRIAMRY_BUTTON_BACKGROUND,
            secondaryButtonLabel: CUSTOM_SECONDARY_BUTTON_LABEL
        )
        
        return hasSecondaryButton ? TWO_BUTTON_SHIELD_CONFIG : ONE_BUTTON_SHIELD_CONFIG
    }

    // MARK: - Apps with limited applications only
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        guard let displayName = application.localizedDisplayName else {
            return setShieldConfig("Unverified app")
        }
        return setShieldConfig(displayName)
    }

    // MARK: - Apps restricted by category
    override func configuration(
        shielding application: Application,
        in category: ActivityCategory) -> ShieldConfiguration {
            // Customize the shield as needed for applications shielded because of their category.
        guard let displayName = application.localizedDisplayName,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig("Unverified app")
        }
        return setShieldConfig(categoryName + " " + displayName, hasSecondaryButton: true)
    }

    // MARK: - Apps restricted to web domain only
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        guard let displayName = webDomain.domain else {
            return setShieldConfig("Unverified web domain")
        }
        return setShieldConfig(displayName)
    }

    // MARK: - Apps with restricted web domains via categories
    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory) -> ShieldConfiguration {
            // Customize the shield as needed for web domains shielded because of their category.
        guard let displayName = webDomain.domain,
              let categoryName = category.localizedDisplayName else {
            return setShieldConfig("Unverified web domain")
        }
        return setShieldConfig(categoryName + " " + displayName)
    }
}
