import SwiftUI
import UIKit

// MARK: - Image de recette

/// Affiche l'image « <id de la recette> » d'Assets.xcassets si elle existe,
/// sinon une jolie vignette provisoire (dégradé de la région + emoji du plat).
struct RecipeImage: View {
    let recipe: Recipe
    var emojiSize: CGFloat = 64

    var body: some View {
        if UIImage(named: recipe.imageName) != nil {
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .accessibilityLabel(recipe.name)
        } else {
            ZStack {
                LinearGradient(colors: [recipe.region.lightColor, recipe.region.color.opacity(0.55)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle()
                    .fill(.white.opacity(0.45))
                    .frame(width: emojiSize * 1.6, height: emojiSize * 1.6)
                Text(recipe.emoji)
                    .font(.system(size: emojiSize))
                    .shadow(color: .black.opacity(0.15), radius: 4, y: 3)
            }
            .accessibilityLabel(recipe.name)
        }
    }
}

// MARK: - Badges

struct PillBadge: View {
    let text: String
    let systemImage: String
    let color: Color
    var filled: Bool = true

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
            Text(text)
        }
        .font(.caption.weight(.bold))
        .lineLimit(1)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .foregroundStyle(filled ? .white : color)
        .background(filled ? color : color.opacity(0.14), in: Capsule())
    }
}

struct DifficultyBadge: View {
    let difficulty: Difficulty

    var body: some View {
        PillBadge(text: difficulty.title, systemImage: difficulty.systemImage, color: difficulty.color)
    }
}

struct TagBadge: View {
    let tag: RecipeTag

    var body: some View {
        PillBadge(text: tag.title, systemImage: tag.systemImage, color: tag.color, filled: false)
    }
}

// MARK: - Favori

struct FavoriteButton: View {
    @Environment(CookbookStore.self) private var cookbook
    let recipe: Recipe
    var compact: Bool = false

    var body: some View {
        let isFavorite = cookbook.isFavorite(recipe)
        Button {
            withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
                cookbook.toggleFavorite(recipe)
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(compact ? .subheadline.weight(.bold) : .title3.weight(.bold))
                .foregroundStyle(isFavorite ? Theme.red : Theme.ink)
                .padding(compact ? 7 : 10)
                .background(.white.opacity(0.92), in: Circle())
                .shadow(color: .black.opacity(0.12), radius: 3, y: 1)
                .symbolEffect(.bounce, value: isFavorite)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isFavorite)
        .accessibilityLabel(isFavorite ? "Retirer des favoris" : "Ajouter aux favoris")
    }
}

// MARK: - Carte recette

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .overlay { RecipeImage(recipe: recipe, emojiSize: 52) }
                .clipped()
                .overlay(alignment: .topTrailing) {
                    FavoriteButton(recipe: recipe, compact: true)
                        .padding(8)
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.papaTitle(17))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .topLeading)
                Text("\(recipe.flag) \(recipe.country)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Theme.inkSoft)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    DifficultyBadge(difficulty: recipe.difficulty)
                    Spacer(minLength: 0)
                    HStack(spacing: 3) {
                        Image(systemName: "clock")
                        Text(DurationFormatter.text(recipe.totalMinutes))
                    }
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Theme.inkSoft)
                    .lineLimit(1)
                }
            }
            .padding(12)
        }
        .papaCard()
        .contentShape(Rectangle())
    }
}

/// Grille de cartes recettes cliquables (2 colonnes sur iPhone).
struct RecipeGrid: View {
    let recipes: [Recipe]

    private let columns = [GridItem(.adaptive(minimum: 158), spacing: 14)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(recipes) { recipe in
                NavigationLink(value: recipe) {
                    RecipeCard(recipe: recipe)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Bulle de Papa Win

struct SpeechBubble: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.papaHand(16))
            .foregroundStyle(Theme.ink)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Theme.ink.opacity(0.7), lineWidth: 1.5))
            .overlay(alignment: .bottomLeading) {
                BubbleTail()
                    .fill(.white)
                    .overlay(BubbleTail().stroke(Theme.ink.opacity(0.7), lineWidth: 1.5))
                    .frame(width: 18, height: 14)
                    .offset(x: -10, y: -14)
            }
    }
}

private struct BubbleTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.55))
        return path
    }
}

// MARK: - Puce de filtre

struct FilterChip: View {
    let title: String
    var systemImage: String? = nil
    var emoji: String? = nil
    let isSelected: Bool
    var color: Color = Theme.red
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let emoji { Text(emoji) }
                if let systemImage { Image(systemName: systemImage) }
                Text(title)
            }
            .font(.subheadline.weight(.bold))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .foregroundStyle(isSelected ? .white : Theme.ink)
            .background(isSelected ? color : Theme.paper, in: Capsule())
            .overlay(Capsule().stroke(isSelected ? color : Theme.ink.opacity(0.15), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

// MARK: - État vide

struct PapaEmptyState: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 14) {
            PapaWinAvatar(size: 130)
            Text(title)
                .font(.papaTitle(22))
                .foregroundStyle(Theme.ink)
                .multilineTextAlignment(.center)
            Text(message)
                .font(.papaHand(16))
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)
        }
        .padding(30)
        .frame(maxWidth: .infinity)
    }
}
