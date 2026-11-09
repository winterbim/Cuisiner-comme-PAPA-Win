import SwiftUI

/// Palette et typographies de l'app, inspirées des maquettes « Papa Win » :
/// fond crème, rouge tomate, jaune moutarde et encre brune.
enum Theme {
    static let cream = Color(red: 1.00, green: 0.965, blue: 0.91)
    static let paper = Color(red: 1.00, green: 0.99, blue: 0.965)
    static let red = Color(red: 0.89, green: 0.19, blue: 0.16)
    static let darkRed = Color(red: 0.70, green: 0.11, blue: 0.10)
    static let yellow = Color(red: 1.00, green: 0.80, blue: 0.20)
    static let lightYellow = Color(red: 1.00, green: 0.95, blue: 0.75)
    static let green = Color(red: 0.30, green: 0.66, blue: 0.27)
    static let orange = Color(red: 0.96, green: 0.45, blue: 0.13)
    static let ink = Color(red: 0.24, green: 0.15, blue: 0.10)
    static let inkSoft = Color(red: 0.24, green: 0.15, blue: 0.10).opacity(0.68)
    static let bookCover = Color(red: 0.55, green: 0.25, blue: 0.13)
}

extension Font {
    /// Gros titres arrondis façon affiche.
    static func papaTitle(_ size: CGFloat) -> Font {
        .system(size: size, weight: .black, design: .rounded)
    }

    /// Écriture « à la main » pour les bulles et les astuces.
    static func papaHand(_ size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        .custom("ChalkboardSE-Bold", size: size, relativeTo: style)
    }
}

// MARK: - Cartes

struct PapaCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        content
            .background(Theme.paper)
            .clipShape(shape)
            .overlay(shape.stroke(Theme.ink.opacity(0.08), lineWidth: 1))
            .shadow(color: Theme.ink.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func papaCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(PapaCardModifier(cornerRadius: cornerRadius))
    }
}

// MARK: - Boutons

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.papaTitle(20))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(colors: [Theme.red, Theme.darkRed], startPoint: .top, endPoint: .bottom),
                in: Capsule()
            )
            .shadow(color: Theme.darkRed.opacity(0.35),
                    radius: configuration.isPressed ? 2 : 8,
                    y: configuration.isPressed ? 1 : 5)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundStyle(Theme.ink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.paper, in: Capsule())
            .overlay(Capsule().stroke(Theme.ink.opacity(0.8), lineWidth: 1.5))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
    }
}
