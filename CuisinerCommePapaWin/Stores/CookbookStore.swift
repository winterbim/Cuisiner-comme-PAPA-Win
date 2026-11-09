import Foundation
import Observation

private enum CookbookKeys {
    static let favorites = "favoriteRecipeIDs"
    static let cooked = "cookedRecipeCounts"
}

/// Le carnet perso : favoris et plats déjà cuisinés, sauvegardés sur le téléphone.
@Observable
final class CookbookStore {
    private(set) var favoriteIDs: Set<String>
    private(set) var cookedCounts: [String: Int]

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        favoriteIDs = Set(defaults.stringArray(forKey: CookbookKeys.favorites) ?? [])
        cookedCounts = (defaults.dictionary(forKey: CookbookKeys.cooked) as? [String: Int]) ?? [:]
    }

    // MARK: Favoris

    func isFavorite(_ recipe: Recipe) -> Bool {
        favoriteIDs.contains(recipe.id)
    }

    func toggleFavorite(_ recipe: Recipe) {
        if favoriteIDs.contains(recipe.id) {
            favoriteIDs.remove(recipe.id)
        } else {
            favoriteIDs.insert(recipe.id)
        }
        defaults.set(Array(favoriteIDs), forKey: CookbookKeys.favorites)
    }

    // MARK: Plats cuisinés

    func timesCooked(_ recipe: Recipe) -> Int {
        cookedCounts[recipe.id, default: 0]
    }

    func markCooked(_ recipe: Recipe) {
        cookedCounts[recipe.id, default: 0] += 1
        defaults.set(cookedCounts, forKey: CookbookKeys.cooked)
    }

    var totalCooked: Int {
        cookedCounts.values.reduce(0, +)
    }

    func distinctCooked(in recipes: [Recipe]) -> Int {
        recipes.filter { cookedCounts[$0.id, default: 0] > 0 }.count
    }

    func resetProgress() {
        cookedCounts = [:]
        defaults.removeObject(forKey: CookbookKeys.cooked)
    }

    /// Grade de chef selon le nombre de plats différents cuisinés.
    static func chefLevel(forDistinctCooked count: Int) -> (title: String, emoji: String, next: Int?) {
        switch count {
        case 0: return ("Apprenti Win", "🥄", 1)
        case 1..<5: return ("Commis Win", "🔪", 5)
        case 5..<15: return ("Chef Win", "👨‍🍳", 15)
        case 15..<30: return ("Grand Chef Win", "🏅", 30)
        case 30..<75: return ("Maître Win", "👑", 75)
        default: return ("Papa Win légendaire", "🏆", nil)
        }
    }
}
