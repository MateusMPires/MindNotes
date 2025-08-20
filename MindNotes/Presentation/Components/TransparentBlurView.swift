//
//  TransparentBlurView.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 13/08/25.
//

import SwiftUI

struct TransparentBlurView: UIViewRepresentable {
    
    var removeAllFilters: Bool = false
    
    func makeUIView(context: Context) -> TransparentBluerViewHelper {
        return TransparentBluerViewHelper(removeAllFilters: removeAllFilters)
    }
    
    func updateUIView(_ uiView: TransparentBluerViewHelper, context: Context) {
        
    }
}

// Disabling Trait Changes for Our Transparent Blur View
class TransparentBluerViewHelper: UIVisualEffectView {
    init(removeAllFilters: Bool) {
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        if let backdropLayer = layer.sublayers?.first {
            if removeAllFilters {
                backdropLayer.filters = []
            } else {
                // Removing all Expect Blur Filter
                backdropLayer.filters?.removeAll(where: { filter in
                    String(describing: filter) != "gaussianBlur"
                })
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Disabling Trait Changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
}

#Preview {
    TransparentBlurView()
}
