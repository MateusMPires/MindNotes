import SwiftUI
import WidgetKit

//// MARK: - Widget Previews
//struct MindNotesWidgetPreviews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            // Preview do widget pequeno
//            MindNotesWidget()
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//                .previewDisplayName("Widget Pequeno")
//            
//            // Preview do widget médio (se suportado no futuro)
//            MindNotesWidget()
//                .previewContext(WidgetPreviewContext(family: .systemMedium))
//                .previewDisplayName("Widget Médio")
//        }
//    }
//}
//
//// MARK: - Preview Context Helper
//struct WidgetPreviewContext: WidgetPreviewContext {
//    let family: WidgetFamily
//    let size: CGSize
//    
//    init(family: WidgetFamily) {
//        self.family = family
//        
//        switch family {
//        case .systemSmall:
//            self.size = CGSize(width: 158, height: 158)
//        case .systemMedium:
//            self.size = CGSize(width: 329, height: 158)
//        case .systemLarge:
//            self.size = CGSize(width: 329, height: 345)
//        default:
//            self.size = CGSize(width: 158, height: 158)
//        }
//    }
//} 
