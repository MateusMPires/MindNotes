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
        
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .center, spacing: 24) {
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(thought.content)
                            .font(.custom("Manrope-Regular", size: 16))
                            .multilineTextAlignment(.leading)
                        
                        if let notes = thought.notes, !notes.isEmpty {
                            Image(systemName: "line.3.horizontal")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.leading, 4)
                    
                    Spacer()
                }
            }.onAppear {
                print(thought.journey?.name ?? "não tem nome?")
            }
            
            Divider()
            
            HStack {
                    HStack(spacing: 6) {
                        if !thought.tags.isEmpty {
                            ForEach(thought.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.custom("Manrope-Regular", size: 10))
                                    .textCase(.lowercase)
                                    .padding(.leading, 8)
                                    .padding(.vertical, 3)
                                    .foregroundColor(.primary)
                            }
                        }
                        Text(thought.journey?.name ?? "em minha mente")
                            .font(.custom("Manrope-Regular", size: 10))
                            .italic()
                        
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
                    .padding(.horizontal, 1)
                    .foregroundColor(.secondary)
                
            }
        }
        .padding()
        .background {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 9, opaque: true)
                .background(.white.opacity(0.05))
        }
        .clipShape(.rect(cornerRadius: 12, style: .continuous))
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        }
    }
}

#Preview {
    ThoughtRowView(thought: Thought(content: "a"))
}
