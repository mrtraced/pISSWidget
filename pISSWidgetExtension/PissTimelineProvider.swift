import Foundation
import WidgetKit
import SwiftUI
import os

struct PissEntry: TimelineEntry {
    let date: Date
    let pissData: LightstreamerFetcher.PissData
    let configuration: ConfigurationAppIntent
}

struct PissTimelineProvider: AppIntentTimelineProvider {
    private let logger = Logger(
        subsystem: "com.pisswidget.app.widget",
        category: "PissTimelineProvider"
    )
    private let fetcher = LightstreamerFetcher()

    func placeholder(in context: Context) -> PissEntry {
        PissEntry(
            date: Date(),
            pissData: .init(isConnected: false, pissValue: "75"),
            configuration: ConfigurationAppIntent()
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> PissEntry {
        PissEntry(
            date: Date(),
            pissData: .init(isConnected: true, pissValue: "75"),
            configuration: configuration
        )
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<PissEntry> {
        logger.debug("Fetching timeline data...")
        let data = await fetcher.fetch()

        let entry = PissEntry(date: Date(), pissData: data, configuration: configuration)

        // Refresh every 15 minutes (WidgetKit minimum practical interval)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        logger.debug("Next update scheduled for \(nextUpdate)")

        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        [
            AppIntentRecommendation(intent: .woman, description: "Astronaut 1"),
            AppIntentRecommendation(intent: .man, description: "Astronaut 2"),
        ]
    }
}
