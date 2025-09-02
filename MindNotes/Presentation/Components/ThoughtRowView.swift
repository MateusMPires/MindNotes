//
//  ThoughtRowView.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 15/08/25.
//

import SwiftUI

struct ThoughtRowView: View {
    
    let thought: Thought
    let showBanner: Bool
    
    var body: some View {
        
        // Entire Row..
        VStack(alignment: .center, spacing: 8) {
            
                // Chapter Banner + Content...
                HStack(spacing: 8) {
                    
                    // Banner...
                    VStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 4, height: 12)
                            .foregroundStyle(Color(hex: thought.chapter?.colorHex ?? "488D84"))
                            .opacity(showBanner ? 1 : 0)
                    
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    //.background(.pink)

                    
                    // Content + Tags...
                    VStack(alignment: .leading, spacing: 12) {
                        Text(thought.content)
                        //Text("Uma frase bem legal. E mais uma frase bem legal.")
                            .font(DesignTokens.Typography.body)
                            .foregroundStyle(DesignTokens.Colors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        // Tag...
                        HStack(spacing: 6) {
                            //if !thought.tags.isEmpty {
                            //ForEach(thought.tags, id: \.self) { tag in
                            Text("#conclusão")
                                .font(DesignTokens.Typography.tag)
                                .textCase(.lowercase)
                                //.padding(.leading, 8)
                                //.padding(.vertical, 3)
                                .foregroundColor(DesignTokens.Colors.tag)
                                
                            // }
                            // }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                if thought.isFavorite {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(DesignTokens.Colors.primaryText)
                                        .font(.caption)
                                }
                                
                                if thought.shouldRemind {
                                    Image(systemName: "wave.3.right")
                                        .foregroundColor(DesignTokens.Colors.primaryText)
                                        .font(.caption2)
                                }
                            }
                        }
                        //.padding(.horizontal, 1)
                        .foregroundColor(.secondary)

                    }
                    //.background(.green)
                }
            
            
            Divider()
            
        }
        .padding()
        //.background(.yellow)
//        .background {
//            TransparentBlurView(removeAllFilters: true)
//                .blur(radius: 9, opaque: true)
//                .background(.white.opacity(thought.isFavorite ? 0.2 : 0))
//        }
//        .clipShape(.rect(cornerRadius: 12, style: .continuous))
//        .background {
//            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                .stroke(.white.opacity(thought.isFavorite ? 0.5 : 0), lineWidth: 1)
//        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Thought.self, inMemory: true)
}
