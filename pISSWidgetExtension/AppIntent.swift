import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "pISS Widget Configuration" }
    static var description: IntentDescription { "Configure your ISS waste tank monitor." }

    @Parameter(title: "Astronaut Emoji", default: "👩‍🚀")
    var astronaut: String
}

extension ConfigurationAppIntent {
    static var woman: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.astronaut = "👩🏻‍🚀"
        return intent
    }

    static var man: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.astronaut = "🧑‍🚀"
        return intent
    }
}
