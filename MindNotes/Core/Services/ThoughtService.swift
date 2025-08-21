//
//  ThoughtService.swift
//  MindNotes
//
//  Created by Mateus Martins Pires on 19/08/25.
//

import Foundation
import SwiftData
import SwiftUI


class ThoughtService: ObservableObject {
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func saveThought(_ draft: ThoughtDraft, notes: String) throws {
        let trimmedContent = draft.content.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedContent.isEmpty else {
            //throw ThoughtError.emptyContent
            return 
        }
        
        let newThought = Thought(
            content: trimmedContent,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes,
            tags: draft.tags,
            shouldRemind: draft.shouldRemind,
            reminderDate: draft.shouldRemind ? draft.reminderDate : nil,
            journey: draft.journey
        )
        
        // Definir data de criação se especificada
        if draft.createdDate != Date() {
            newThought.createdDate = draft.createdDate
        }
        
        newThought.isFavorite = draft.isFavorite
        
        
        context.insert(newThought)
        try context.save()
    }
    
    
    func deleteThought(_ thought: Thought) throws {
        context.delete(thought)
        try context.save()
    }
    
    func toggleFavorite(_ thought: Thought) throws {
        thought.isFavorite.toggle()
        thought.updateModifiedDate()
    }
    
    func updateThought(_ thought: Thought) throws {
        try context.save()
        
    }
    
    func shareThought(_ thought: Thought) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        
        let shareText = """
           💭 \(thought.content)
           
           \(thought.notes ?? "")
           
           📅 \(formatter.string(from: thought.createdDate))
           """
        
        return shareText
    }
    
    
    
    // MARK: - Search and Filter
    
    func searchThoughts(_ query: String, in thoughts: [Thought]) -> [Thought] {
        guard !query.isEmpty else { return thoughts }
        
        return thoughts.filter { thought in
            thought.content.localizedCaseInsensitiveContains(query) ||
            thought.notes?.localizedCaseInsensitiveContains(query) == true ||
            thought.tags.contains { $0.localizedCaseInsensitiveContains(query) }
        }
    }
    
    func filterThoughts(_ thoughts: [Thought], searchText: String) -> [Thought] {
        let filtered = searchThoughts(searchText, in: thoughts)
        
        // Ordenar por data de modificação (mais recente primeiro)
        return filtered.sorted { $0.modifiedDate > $1.modifiedDate }
    }
    
    // MARK: - Query Methods
    
    private func fetch(predicate: Predicate<Thought>? = nil, sortBy: [SortDescriptor<Thought>] = []) throws -> [Thought] {
        let descriptor = FetchDescriptor<Thought>(
            predicate: predicate,
            sortBy: sortBy
        )
        return try context.fetch(descriptor)
    }
    
    func fetchAllThoughts() throws -> [Thought] {
        let sortDescriptor = SortDescriptor(\Thought.modifiedDate, order: .reverse)
        return try fetch(sortBy: [sortDescriptor])
    }
    
    func fetchThoughts(for journey: Journey) throws -> [Thought] {
        let journeyID = journey.id
        let predicate = #Predicate<Thought> { thought in
            thought.journey != nil && thought.journey!.id == journeyID
        }
        let sortDescriptor = SortDescriptor(\Thought.modifiedDate, order: .reverse)
        return try fetch(predicate: predicate, sortBy: [sortDescriptor])
    }
    
    func fetchFavoriteThoughts() throws -> [Thought] {
        let predicate = #Predicate<Thought> { $0.isFavorite == true }
        let sortDescriptor = SortDescriptor(\Thought.modifiedDate, order: .reverse)
        return try fetch(predicate: predicate, sortBy: [sortDescriptor])
    }
}
