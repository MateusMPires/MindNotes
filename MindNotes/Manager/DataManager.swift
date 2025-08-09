//
//  DataManager.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import Foundation
import SwiftData

@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    let container: ModelContainer
    let context: ModelContext
    
    private init() {
        do {
            container = try ModelContainer(for: Journey.self, Thought.self)
            context = container.mainContext
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    // MARK: - Journey Management
    func createJourney(name: String, emoji: String = "📝", colorHex: String = "#007AFF") {
        let journey = Journey(name: name, emoji: emoji, colorHex: colorHex)
        context.insert(journey)
        saveContext()
    }
    
    func fetchJourneys(includeArchived: Bool = false) -> [Journey] {
        let descriptor = FetchDescriptor<Journey>(
            predicate: includeArchived ? nil : #Predicate<Journey> { journey in
                journey.isArchived == false
            },
            sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
        )
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch journeys: \(error)")
            return []
        }
    }
    
    func updateJourney(_ journey: Journey) {
        saveContext()
    }
    
    func archiveJourney(_ journey: Journey) {
        journey.isArchived = true
        saveContext()
    }
    
    func deleteJourney(_ journey: Journey) {
        context.delete(journey)
        saveContext()
    }
    
    // MARK: - Thought Management
    func createThought(
        content: String,
        notes: String? = nil,
        journey: Journey? = nil,
        tags: [String] = [],
        shouldRemind: Bool = false,
        reminderDate: Date? = nil,
        createdDate: Date = Date(),
        isFavorite: Bool = false
    ) {
        let thought = Thought(
            content: content,
            notes: notes,
            journey: journey,
            tags: tags,
            shouldRemind: shouldRemind,
            reminderDate: reminderDate,
            createdDate: createdDate,
            isFavorite: isFavorite
        )
        context.insert(thought)
        saveContext()
    }
    
    func fetchThoughts(for journey: Journey? = nil, favoriteOnly: Bool = false) -> [Thought] {
        // Fetch all thoughts first, then filter in memory for now
        // This is a temporary solution until SwiftData improves predicate support
        let descriptor = FetchDescriptor<Thought>(
            sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
        )
        
        do {
            let allThoughts = try context.fetch(descriptor)
            
            return allThoughts.filter { thought in
                var matches = true
                
                // Filter by journey
                if let journey = journey {
                    matches = matches && (thought.journey?.id == journey.id)
                }
                
                // Filter by favorite
                if favoriteOnly {
                    matches = matches && thought.isFavorite
                }
                
                return matches
            }
        } catch {
            print("Failed to fetch thoughts: \(error)")
            return []
        }
    }
    
    func fetchThoughts(withTag tag: String) -> [Thought] {
        let descriptor = FetchDescriptor<Thought>(
            predicate: #Predicate<Thought> { thought in
                thought.tags.contains(tag)
            },
            sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
        )
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch thoughts with tag: \(error)")
            return []
        }
    }
    
    func updateThought(_ thought: Thought) {
        thought.updateModifiedDate()
        saveContext()
    }
    
    func deleteThought(_ thought: Thought) {
        context.delete(thought)
        saveContext()
    }
    
    func toggleFavorite(_ thought: Thought) {
        thought.isFavorite.toggle()
        thought.updateModifiedDate()
        saveContext()
    }
    
    // MARK: - Tag Management
    func getAllTags() -> [String] {
        let descriptor = FetchDescriptor<Thought>()
        
        do {
            let thoughts = try context.fetch(descriptor)
            let allTags = thoughts.flatMap { $0.tags }
            return Array(Set(allTags)).sorted()
        } catch {
            print("Failed to fetch all tags: \(error)")
            return []
        }
    }
    
    // MARK: - Search
    func searchThoughts(query: String) -> [Thought] {
        // Fetch all thoughts and filter in memory to avoid SwiftData predicate issues
        let descriptor = FetchDescriptor<Thought>(
            sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
        )
        
        do {
            let allThoughts = try context.fetch(descriptor)
            
            return allThoughts.filter { thought in
                let contentMatches = thought.content.localizedStandardContains(query)
                let notesMatch = thought.notes?.localizedStandardContains(query) ?? false
                return contentMatches || notesMatch
            }
        } catch {
            print("Failed to search thoughts: \(error)")
            return []
        }
    }
    
    // MARK: - Setup
    func setupDefaultJourneys() {
        let existingJourneys = fetchJourneys(includeArchived: true)
        
        if existingJourneys.isEmpty {
            Journey.defaultJourneys.forEach { journey in
                context.insert(journey)
            }
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}