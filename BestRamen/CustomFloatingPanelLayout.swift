import Foundation
import FloatingPanel

class CustomFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(fractionalInset: 0.9, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.4, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.1, edge: .bottom, referenceGuide: .safeArea),
        ]
    }

}
