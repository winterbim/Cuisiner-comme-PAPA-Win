import SwiftUI

// MARK: - Région

enum Region: String, Codable, CaseIterable, Identifiable, Hashable {
    case portugal, asie, afrique, maghreb, france

    var id: String { rawValue }

    var title: String {
        switch self {
        case .portugal: "Portugal"
        case .asie: "Asie"
        case .afrique: "Afrique"
        case .maghreb: "Maghreb"
        case .france: "France"
        }
    }

    var emoji: String {
        switch self {
        case .portugal: "🇵🇹"
        case .asie: "🏯"
        case .afrique: "🌍"
        case .maghreb: "🕌"
        case .france: "🇫🇷"
        }
    }

    var tagline: String {
        switch self {
        case .portugal: "Morue, piri-piri et saudade"
        case .asie: "Wok, baguettes et umami"
        case .afrique: "Mijotés, épices et soleil"
        case .maghreb: "Tajines, semoule et ras-el-hanout"
        case .france: "Les classiques de mamie, version Win"
        }
    }

    var color: Color {
        switch self {
        case .portugal: Color(red: 0.00, green: 0.53, blue: 0.31)
        case .asie: Color(red: 0.85, green: 0.24, blue: 0.42)
        case .afrique: Color(red: 0.87, green: 0.46, blue: 0.08)
        case .maghreb: Color(red: 0.05, green: 0.52, blue: 0.60)
        case .france: Color(red: 0.16, green: 0.36, blue: 0.75)
        }
    }

    var lightColor: Color {
        switch self {
        case .portugal: Color(red: 0.86, green: 0.95, blue: 0.86)
        case .asie: Color(red: 1.00, green: 0.88, blue: 0.91)
        case .afrique: Color(red: 1.00, green: 0.90, blue: 0.76)
        case .maghreb: Color(red: 0.84, green: 0.95, blue: 0.95)
        case .france: Color(red: 0.87, green: 0.91, blue: 1.00)
        }
    }
}

// MARK: - Difficulté

enum Difficulty: String, Codable, CaseIterable, Hashable {
    case facile, moyen, difficile

    var title: String {
        switch self {
        case .facile: "Facile"
        case .moyen: "Moyen"
        case .difficile: "Costaud"
        }
    }

    var systemImage: String {
        switch self {
        case .facile: "hand.thumbsup.fill"
        case .moyen: "star.leadinghalf.filled"
        case .difficile: "crown.fill"
        }
    }

    var color: Color {
        switch self {
        case .facile: Theme.green
        case .moyen: Theme.orange
        case .difficile: Theme.red
        }
    }
}

// MARK: - Étiquettes

enum RecipeTag: String, Codable, CaseIterable, Hashable, Identifiable {
    case epice, rapide, mijote, familial, poisson, vegetarien, four

    var id: String { rawValue }

    var title: String {
        switch self {
        case .epice: "Épicé"
        case .rapide: "Rapide"
        case .mijote: "Mijoté"
        case .familial: "Familial"
        case .poisson: "Poisson"
        case .vegetarien: "Végétarien"
        case .four: "Au four"
        }
    }

    var systemImage: String {
        switch self {
        case .epice: "flame.fill"
        case .rapide: "bolt.fill"
        case .mijote: "timer"
        case .familial: "person.3.fill"
        case .poisson: "fish.fill"
        case .vegetarien: "leaf.fill"
        case .four: "oven.fill"
        }
    }

    var color: Color {
        switch self {
        case .epice: Color(red: 0.90, green: 0.25, blue: 0.10)
        case .rapide: Color(red: 0.93, green: 0.62, blue: 0.00)
        case .mijote: Color(red: 0.55, green: 0.30, blue: 0.15)
        case .familial: Color(red: 0.45, green: 0.35, blue: 0.75)
        case .poisson: Color(red: 0.10, green: 0.50, blue: 0.75)
        case .vegetarien: Theme.green
        case .four: Color(red: 0.75, green: 0.35, blue: 0.20)
        }
    }
}

// MARK: - Ingrédient

struct Ingredient: Codable, Hashable {
    let quantity: Double?
    let unit: String?
    let name: String

    /// Quantité adaptée au nombre de personnes, ex. « 1½ c. à soupe ».
    func quantityText(scale: Double) -> String? {
        guard let quantity else { return nil }
        // kg et l : décimales (1,2 kg) plutôt que des quarts (1¼ kg).
        let decimal = unit.map { QuantityFormatter.decimalUnits.contains($0) } ?? false
        let number = QuantityFormatter.format(quantity * scale, decimal: decimal)
        if let unit { return "\(number) \(unit)" }
        return number
    }
}

// MARK: - Recette

struct Recipe: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let originalName: String
    let region: Region
    let country: String
    let flag: String
    let emoji: String
    let difficulty: Difficulty
    let tags: [String]
    let prepMinutes: Int
    let cookMinutes: Int
    let servings: Int
    let pitch: String
    let ingredients: [Ingredient]
    let steps: [String]
    let tip: String

    var totalMinutes: Int { prepMinutes + cookMinutes }

    /// Étiquettes connues (les inconnues sont ignorées sans planter).
    var recipeTags: [RecipeTag] { tags.compactMap(RecipeTag.init(rawValue:)) }

    /// Nom de l'image dans Assets.xcassets (ex. « lok-win »).
    var imageName: String { id }

    static func == (lhs: Recipe, rhs: Recipe) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    /// Texte partagé via le bouton « Partager ».
    var shareText: String {
        var lines = ["\(name) \(flag) — une recette de Papa Win", "", pitch, "", "Ingrédients (\(servings) pers.) :"]
        for ingredient in ingredients {
            if let quantity = ingredient.quantityText(scale: 1) {
                lines.append("• \(quantity) — \(ingredient.name)")
            } else {
                lines.append("• \(ingredient.name)")
            }
        }
        lines.append("")
        lines.append("Étapes :")
        for (index, step) in steps.enumerated() {
            lines.append("\(index + 1). \(step)")
        }
        lines.append("")
        lines.append("💡 L'astuce de Papa Win : \(tip)")
        return lines.joined(separator: "\n")
    }
}

// MARK: - Mise en forme

enum QuantityFormatter {
    /// Unités métriques affichées en décimales.
    static let decimalUnits: Set<String> = ["kg", "l"]

    /// Arrondit joliment : 600 g, 1½, ¾, 12…
    /// `decimal` : arrondi au dixième sous 10 (1,2 ; 0,6) au lieu des quarts.
    static func format(_ value: Double, decimal: Bool = false) -> String {
        guard value > 0 else { return "0" }
        if decimal && value < 10 {
            let tenths = max((value * 10).rounded(), 1) / 10
            if tenths == tenths.rounded() { return "\(Int(tenths))" }
            return String(format: "%.1f", tenths).replacingOccurrences(of: ".", with: ",")
        }
        let rounded: Double
        if value >= 100 {
            rounded = (value / 5).rounded() * 5
        } else if value >= 10 {
            rounded = value.rounded()
        } else {
            rounded = (value * 4).rounded() / 4
        }
        if rounded == 0 {
            return String(format: "%.1f", max(value, 0.1)).replacingOccurrences(of: ".", with: ",")
        }
        let whole = Int(rounded)
        let fraction = rounded - Double(whole)
        switch fraction {
        case 0: return "\(whole)"
        case 0.25: return whole == 0 ? "¼" : "\(whole)¼"
        case 0.5: return whole == 0 ? "½" : "\(whole)½"
        case 0.75: return whole == 0 ? "¾" : "\(whole)¾"
        default: return String(format: "%.1f", rounded).replacingOccurrences(of: ".", with: ",")
        }
    }
}

enum DurationFormatter {
    /// 45 → « 45 min », 90 → « 1 h 30 », 120 → « 2 h ».
    static func text(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes) min" }
        let hours = minutes / 60
        let rest = minutes % 60
        return rest == 0 ? "\(hours) h" : "\(hours) h \(String(format: "%02d", rest))"
    }
}
