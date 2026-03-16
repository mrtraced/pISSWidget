import SwiftUI

extension GeometryProxy {
    var minSize: CGFloat {
        min(size.width, size.height)
    }

    var maxSize: CGFloat {
        max(size.width, size.height)
    }
}
