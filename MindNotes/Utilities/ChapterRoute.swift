//
//  ChapterRoute.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 27/08/25.
//

enum ChapterRoute: Hashable {
    case journey(Journey)
    case filtered(FilteredChapter)
}

enum FilteredChapter: Hashable {
    case recents
    case favorites
    case echoes
    
    var title: String {
        switch self {
        case .recents: return "Recentes"
        case .favorites: return "Favoritos"
        case .echoes: return "Ecos"
        }
    }
    
    var notes: String {
        switch self {
        case .recents: return "Recentes"
        case .favorites: return "Favoritos"
        case .echoes: return "Ecos"
        }
    }
    
    var icon: String {
        switch self {
        case .recents: return "clock.fill"
        case .favorites: return "star.fill"
        case .echoes: return "wave.3.right.circle.fill"
        }
    }
    
    var colorHex: String {
        switch self {
        case .recents: return "#488D84"
        case .favorites: return "#488D84"
        case .echoes: return "#488D84"
        }
    }
    
    
    var isArchived: Bool {
        switch self {
        case .recents: return false
        case .favorites: return false
        case .echoes: return false
        }
    }
}
