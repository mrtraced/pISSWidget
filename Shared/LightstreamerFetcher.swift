import Foundation
import os

/// Fetches ISS telemetry data from NASA's Lightstreamer endpoint.
/// Based on the protocol used by pISSStreamGodot (https://github.com/Stovoy/pISSStreamGodot)
/// and pISSStream (https://github.com/Jaennaet/pISSStream).
///
/// Uses HTTP polling (TLCP 2.5.0) since WidgetKit extensions cannot maintain
/// persistent WebSocket connections.
struct LightstreamerFetcher {
    private let logger = Logger(
        subsystem: "com.pisswidget.app.widget",
        category: "LightstreamerFetcher"
    )

    /// ISS telemetry items
    private enum TelemetryItem: String {
        /// Urine tank level on Node 3 (WHC)
        case urineTank = "NODE3000005"
        /// ISS time/signal status (AOS/LOS indicator)
        case signalStatus = "TIME_000001"
    }

    struct PissData {
        let isConnected: Bool
        let pissValue: String

        var statusText: String {
            isConnected ? "Signal Acquired (AOS)" : "Signal Lost (LOS)"
        }

        var shortStatusText: String {
            isConnected ? "AOS" : "LOS"
        }
    }

    /// Fetch current ISS urine tank level and signal status.
    func fetch() async -> PissData {
        async let pissResult = fetchItem(.urineTank, schema: "Value")
        async let statusResult = fetchItem(.signalStatus, schema: "Status.Class")

        let pissValue = await pissResult
        let statusValue = await statusResult

        let isConnected = statusValue == "24"
        logger.debug("Fetched: tank=\(pissValue), signal=\(statusValue), connected=\(isConnected)")

        return PissData(isConnected: isConnected, pissValue: pissValue)
    }

    /// Fetch a single telemetry item from Lightstreamer via HTTP polling.
    private func fetchItem(_ item: TelemetryItem, schema: String) async -> String {
        guard let url = URL(
            string: "https://push.lightstreamer.com/lightstreamer/create_session.txt?LS_protocol=TLCP-2.5.0"
        ) else {
            logger.error("Invalid Lightstreamer URL")
            return ""
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10

        let body = [
            "LS_user=",
            "LS_adapter_set=ISSLIVE",
            "LS_cid=mgQkwtwdysogQz2BJ4Ji%20kOj2Bg",
            "LS_op=add",
            "LS_subId=1",
            "LS_group=\(item.rawValue)",
            "LS_schema=\(schema)",
            "LS_mode=MERGE",
            "LS_snapshot=true",
            "LS_polling=true",
            "LS_polling_millis=1000",
        ].joined(separator: "&")

        request.httpBody = body.data(using: .utf8)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let raw = String(data: data, encoding: .utf8) {
                return parseLightstreamerResponse(raw)
            }
        } catch {
            logger.error("Fetch failed for \(item.rawValue): \(error.localizedDescription)")
        }

        return ""
    }

    /// Parse the Lightstreamer TLCP response to extract the data value.
    /// Response contains lines like: U,1,1,<value>
    private func parseLightstreamerResponse(_ response: String) -> String {
        let lines = response.split(whereSeparator: \.isNewline)
        guard let updateLine = lines.first(where: { $0.hasPrefix("U,") }) else {
            return ""
        }
        let parts = updateLine.split(separator: ",")
        guard parts.count >= 4 else { return "" }
        return String(parts[3])
    }
}
