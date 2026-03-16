import SwiftUI

struct ContentView: View {
    @State private var tankLevel: String = "..."
    @State private var isConnected: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("🚀🚽 pISS Widget")
                .font(.title)

            Text("ISS Waste Tank Monitor")
                .font(.headline)
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                HStack {
                    Circle()
                        .fill(isConnected ? .green : .orange)
                        .frame(width: 8, height: 8)
                    Text(isConnected ? "Signal Acquired (AOS)" : "Signal Lost (LOS)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if tankLevel != "..." {
                    Text("\(tankLevel)%")
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color(red: 0.95, green: 0.85, blue: 0.2))
                } else {
                    ProgressView()
                }
            }

            Divider()

            Text("Add the widget to your desktop via\nNotification Center → Edit Widgets → pISS Widget")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)

            Button("Refresh Data") {
                Task { await fetchData() }
            }
            .disabled(isLoading)

            Link("Based on pISSStreamGodot by Stovoy",
                 destination: URL(string: "https://github.com/Stovoy/pISSStreamGodot")!)
                .font(.caption2)
                .foregroundStyle(.blue)
        }
        .padding(30)
        .task {
            await fetchData()
        }
    }

    private func fetchData() async {
        isLoading = true
        defer { isLoading = false }

        let fetcher = LightstreamerFetcher()
        let data = await fetcher.fetch()
        tankLevel = data.pissValue.isEmpty ? "N/A" : data.pissValue
        isConnected = data.isConnected
    }
}
