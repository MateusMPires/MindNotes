//
//  ThoughtViewModel.swift
//  MindNotes
//
//  Created by AI Assistant on 16/01/25.
//

import Foundation
import SwiftUI

@MainActor
class ThoughtViewModel: ObservableObject {
    @Published var thoughts: [Thought] = []
    @Published var filteredThoughts: [Thought] = []
    @Published var searchText = ""
    @Published var selectedTags: Set<String> = []
    @Published var showingFavoritesOnly = false
    @Published var currentJourney: Journey?
    @Published var allTags: [String] = []
    
    private let dataManager = DataManager.shared
    
    init() {
        loadThoughts()
        loadTags()
    }
    
    func loadThoughts() {
        if let journey = currentJourney {
            thoughts = dataManager.fetchThoughts(for: journey, favoriteOnly: showingFavoritesOnly)
        } else {
            thoughts = dataManager.fetchThoughts(favoriteOnly: showingFavoritesOnly)
        }
        applyFilters()
    }
    
    func loadTags() {
        allTags = dataManager.getAllTags()
    }
    
    func setJourney(_ journey: Journey?) {
        currentJourney = journey
        loadThoughts()
    }
    
    func createThought(
        content: String,
        notes: String? = nil,
        tags: [String] = [],
        shouldRemind: Bool = false,
        reminderDate: Date? = nil,
        createdDate: Date = Date(),
        isFavorite: Bool = false
    ) {
        dataManager.createThought(
            content: content,
            notes: notes,
            journey: currentJourney,
            tags: tags,
            shouldRemind: shouldRemind,
            reminderDate: reminderDate,
            createdDate: createdDate,
            isFavorite: isFavorite
        )
        loadThoughts()
        loadTags()
    }

    // MARK: - Today Helpers
    var todayThoughts: [Thought] {
        let cal = Calendar.current
        return thoughts.filter { cal.isDateInToday($0.createdDate) }
            .sorted { $0.createdDate > $1.createdDate }
    }
    
    func updateThought(_ thought: Thought) {
        dataManager.updateThought(thought)
        loadThoughts()
        loadTags()
    }
    
    func deleteThought(_ thought: Thought) {
        dataManager.deleteThought(thought)
        loadThoughts()
        loadTags()
    }
    
    func toggleFavorite(_ thought: Thought) {
        dataManager.toggleFavorite(thought)
        loadThoughts()
    }
    
    func searchThoughts(query: String) {
        searchText = query
        if query.isEmpty {
            applyFilters()
        } else {
            let searchResults = dataManager.searchThoughts(query: query)
            filteredThoughts = applyTagFilters(to: searchResults)
        }
    }
    
    func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
        applyFilters()
    }
    
    func clearTagFilters() {
        selectedTags.removeAll()
        applyFilters()
    }
    
    func toggleFavoritesOnly() {
        showingFavoritesOnly.toggle()
        loadThoughts()
    }
    
    private func applyFilters() {
        if searchText.isEmpty {
            filteredThoughts = applyTagFilters(to: thoughts)
        } else {
            searchThoughts(query: searchText)
        }
    }
    
    private func applyTagFilters(to thoughts: [Thought]) -> [Thought] {
        if selectedTags.isEmpty {
            return thoughts
        }
        
        return thoughts.filter { thought in
            selectedTags.allSatisfy { selectedTag in
                thought.tags.contains(selectedTag)
            }
        }
    }
    
    // MARK: - Computed Properties
    var thoughtsByMonth: [String: [Thought]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        
        return Dictionary(grouping: filteredThoughts) { thought in
            formatter.string(from: thought.createdDate)
        }
    }
    
    var sortedMonthKeys: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        
        return thoughtsByMonth.keys.sorted { key1, key2 in
            guard let date1 = formatter.date(from: key1),
                  let date2 = formatter.date(from: key2) else {
                return key1 < key2
            }
            return date1 > date2
        }
    }
}