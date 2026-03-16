import SwiftUI
import WidgetKit

/// Simplified wrapper — for the small liquid-glass design,
/// PissTankView handles the entire layout.
struct PissWidgetView: View {
    let entry: PissTimelineProvider.Entry

    var body: some View {
        PissTankView(pissData: entry.pissData, date: entry.date)
    }
}
