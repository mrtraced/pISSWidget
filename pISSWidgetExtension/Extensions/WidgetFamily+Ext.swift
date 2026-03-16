import WidgetKit

extension WidgetFamily {
    func isSmall() -> Bool {
        self == .systemSmall
    }

    func isMedium() -> Bool {
        self == .systemMedium
    }
}
