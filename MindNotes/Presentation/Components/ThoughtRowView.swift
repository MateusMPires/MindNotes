//
//  ThoughtRowView.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 15/08/25.
//

import SwiftUI

struct ThoughtRowView: View {
    
    let thought: Thought
    
    var body: some View {
        
        // Entire Row..
        VStack(alignment: .center, spacing: 8) {
            
                // Chapter Banner + Content...
                HStack(spacing: 8) {
                    
                    // Banner...
                    VStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 4, height: 12)
                    
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    //.background(.pink)

                    
                    // Content + Tags...
                    VStack(alignment: .leading, spacing: 12) {
                        Text(thought.content)
                        //Text("Uma frase bem legal. E mais uma frase bem legal.")
                            .font(DesignTokens.Typography.body)
                            .foregroundStyle(DesignTokens.Colors.primary)
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
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                                
                                if thought.shouldRemind {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(.orange)
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
//                .background(.white.opacity(0.05))
//        }
//        .clipShape(.rect(cornerRadius: 12, style: .continuous))
//        .background {
//            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                .stroke(.white.opacity(0.3), lineWidth: 1)
//        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Thought.self, inMemory: true)
}
