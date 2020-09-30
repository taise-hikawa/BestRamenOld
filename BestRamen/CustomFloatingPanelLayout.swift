import Foundation
import FloatingPanel

class CustomFloatingPanelLayout: FloatingPanelLayout {
    // カスタマイズした高さ
       func insetFor(position: FloatingPanelPosition) -> CGFloat? {
           switch position {
           case .full: return 16.0
           case .half: return 216.0
           case .tip: return 44.0
           default: return nil
           }
       }
    
   
   // 初期位置
   var initialPosition: FloatingPanelPosition {
       return .half
   }
 
   // サポートする位置
   var supportedPositions: Set<FloatingPanelPosition> {
    return [.half,.tip]
   }
}
