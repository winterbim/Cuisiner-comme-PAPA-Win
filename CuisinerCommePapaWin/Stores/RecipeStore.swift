import Foundation
import Observation

/// Filtres rapides proposés dans l'onglet Recettes.
enum QuickFilter: String, CaseIterable, Identifiable, Hashable {
    case facile, rapide, epice, mijote, poisson, vegetarien

    var id: String { rawValue }

    var title: String {
        switch self {
        case .facile: "Facile"
        case .rapide: "Rapide"
        case .epice: "Épicé"
        case .mijote: "Mijoté"
        case .poisson: "Poisson"
        case .vegetarien: "Végétarien"
        }
    }

    var systemImage: String {
        switch self {
        case .facile: Difficulty.facile.systemImage
        case .rapide: RecipeTag.rapide.systemImage
        case .epice: RecipeTag.epice.systemImage
        case .mijote: RecipeTag.mijote.systemImage
        case .poisson: RecipeTag.poisson.systemImage
        case .vegetarien: RecipeTag.vegetarien.systemImage
        }
    }

    func matches(_ recipe: Recipe) -> Bool {
        switch self {
        case .facile: recipe.difficulty == .facile
        case .rapide: recipe.recipeTags.contains(.rapide)
        case .epice: recipe.recipeTags.contains(.epice)
        case .mijote: recipe.recipeTags.contains(.mijote)
        case .poisson: recipe.recipeTags.contains(.poisson)
        case .vegetarien: recipe.recipeTags.contains(.vegetarien)
        }
    }
}

/// Charge les recettes depuis les fichiers `recipes_<region>.json` du bundle.
@Observable
final class RecipeStore {
    private(set) var recipes: [Recipe] = []
    private(set) var loadError: String?

    init(bundle: Bundle = .main) {
        load(from: bundle)
    }

    func load(from bundle: Bundle) {
        let decoder = JSONDecoder()
        var all: [Recipe] = []
        var errors: [String] = []
        for region in Region.allCases {
            let fileName = "recipes_\(region.rawValue)"
            guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
                errors.append("Fichier manquant : \(fileName).json")
                continue
            }
            do {
                let data = try Data(contentsOf: url)
                all += try decoder.decode([Recipe].self, from: data)
            } catch {
                errors.append("\(fileName).json : \(error)")
            }
        }
        recipes = all
        loadError = errors.isEmpty ? nil : errors.joined(separator: "\n")
    }

    func recipes(in region: Region) -> [Recipe] {
        recipes.filter { $0.region == region }
    }

    /// Le « plat du jour » change chaque jour, pareil pour toute la famille.
    var recipeOfTheDay: Recipe? {
        guard !recipes.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .era, for: Date()) ?? 0
        return recipes[(day * 7) % recipes.count]
    }

    func filtered(query: String, region: Region?, filters: Set<QuickFilter>) -> [Recipe] {
        let needle = Self.normalize(query.trimmingCharacters(in: .whitespacesAndNewlines))
        return recipes.filter { recipe in
            if let region, recipe.region != region { return false }
            if !filters.allSatisfy({ $0.matches(recipe) }) { return false }
            guard !needle.isEmpty else { return true }
            let haystack = ([recipe.name, recipe.originalName, recipe.country] + recipe.ingredients.map(\.name))
                .map(Self.normalize)
            return haystack.contains { $0.contains(needle) }
        }
    }

    private static func normalize(_ text: String) -> String {
        text.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "fr_FR"))
    }
}
