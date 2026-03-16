import WidgetKit
import SwiftUI

struct pISSWidgetEntryView: View {
    var entry: PissTimelineProvider.Entry

    var body: some View {
        PissWidgetView(entry: entry)
    }
}

struct pISSWidget: Widget {
    let kind: String = "pISSWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: PissTimelineProvider()
        ) { entry in
            pISSWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("🚀🚽 pISS Widget")
        .description("Real-time ISS waste tank level from NASA telemetry.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview("Small — Low", as: .systemSmall) {
    pISSWidget()
} timeline: {
    PissEntry(date: .now, pissData: .init(isConnected: true, pissValue: "12"), configuration: .woman)
}

#Preview("Small — Mid", as: .systemSmall) {
    pISSWidget()
} timeline: {
    PissEntry(date: .now, pissData: .init(isConnected: true, pissValue: "54"), configuration: .woman)
}

#Preview("Small — High", as: .systemSmall) {
    pISSWidget()
} timeline: {
    PissEntry(date: .now, pissData: .init(isConnected: true, pissValue: "91"), configuration: .woman)
}

#Preview("Small — LOS", as: .systemSmall) {
    pISSWidget()
} timeline: {
    PissEntry(date: .now, pissData: .init(isConnected: false, pissValue: "67"), configuration: .woman)
}
