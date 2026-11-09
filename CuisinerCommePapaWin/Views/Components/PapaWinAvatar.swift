import SwiftUI
import UIKit

/// La mascotte Papa Win.
/// Si une image « papa_win » existe dans Assets.xcassets, elle est utilisée.
/// Sinon, on dessine un Papa Win provisoire (crâne lisse, barbe poivre et sel, toque).
struct PapaWinAvatar: View {
    var size: CGFloat = 160
    var showsHat: Bool = true

    var body: some View {
        if UIImage(named: "papa_win") != nil {
            Image("papa_win")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .accessibilityLabel("Papa Win")
        } else {
            DrawnPapaWin(showsHat: showsHat)
                .frame(width: 200, height: 200)
                .scaleEffect(size / 200)
                .frame(width: size, height: size)
                .accessibilityLabel("Papa Win")
        }
    }
}

private struct DrawnPapaWin: View {
    var showsHat: Bool

    private let skin = Color(red: 0.80, green: 0.56, blue: 0.40)
    private let skinShadow = Color(red: 0.70, green: 0.46, blue: 0.32)
    private let beard = Color(red: 0.36, green: 0.34, blue: 0.33)
    private let shirt = Color(red: 0.97, green: 0.67, blue: 0.72)
    private let apron = Color(red: 0.18, green: 0.17, blue: 0.18)

    var body: some View {
        ZStack {
            // Épaules + chemise rose + tablier noir
            Capsule()
                .fill(shirt)
                .frame(width: 168, height: 64)
                .offset(y: 66)
            ApronShape()
                .fill(apron)
                .frame(width: 74, height: 50)
                .offset(y: 74)
            Text("Papa\nWin")
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .offset(y: 78)

            // Cou
            RoundedRectangle(cornerRadius: 8)
                .fill(skinShadow)
                .frame(width: 34, height: 26)
                .offset(y: 46)

            // Oreilles
            Ellipse().fill(skinShadow).frame(width: 18, height: 26).offset(x: -48, y: -2)
            Ellipse().fill(skinShadow).frame(width: 18, height: 26).offset(x: 48, y: -2)

            // Tête
            Ellipse()
                .fill(skin)
                .frame(width: 96, height: 112)
                .offset(y: -4)
            // Reflet du crâne bien lisse
            Ellipse()
                .fill(.white.opacity(0.25))
                .frame(width: 34, height: 14)
                .rotationEffect(.degrees(-18))
                .offset(x: -18, y: -46)

            // Barbe
            UnevenRoundedRectangle(topLeadingRadius: 14, bottomLeadingRadius: 48,
                                   bottomTrailingRadius: 48, topTrailingRadius: 14)
                .fill(beard)
                .frame(width: 98, height: 58)
                .offset(y: 32)
            // Bouche souriante
            SmileShape()
                .fill(.white)
                .overlay(SmileShape().stroke(Color(red: 0.45, green: 0.12, blue: 0.10), lineWidth: 2))
                .frame(width: 34, height: 14)
                .offset(y: 32)
            // Moustache
            Capsule().fill(beard).frame(width: 30, height: 12).rotationEffect(.degrees(10)).offset(x: -13, y: 20)
            Capsule().fill(beard).frame(width: 30, height: 12).rotationEffect(.degrees(-10)).offset(x: 13, y: 20)

            // Nez
            Ellipse().fill(skinShadow).frame(width: 18, height: 14).offset(y: 8)

            // Yeux rieurs
            EyeArc().stroke(Theme.ink, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                .frame(width: 14, height: 7).offset(x: -18, y: -10)
            EyeArc().stroke(Theme.ink, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                .frame(width: 14, height: 7).offset(x: 18, y: -10)
            // Sourcils
            Capsule().fill(beard).frame(width: 18, height: 5).rotationEffect(.degrees(-8)).offset(x: -18, y: -22)
            Capsule().fill(beard).frame(width: 18, height: 5).rotationEffect(.degrees(8)).offset(x: 18, y: -22)
            // Joues
            Circle().fill(Theme.red.opacity(0.18)).frame(width: 16, height: 16).offset(x: -30, y: 6)
            Circle().fill(Theme.red.opacity(0.18)).frame(width: 16, height: 16).offset(x: 30, y: 6)

            if showsHat {
                ChefHat()
                    .offset(y: -78)
            }
        }
    }
}

private struct ChefHat: View {
    var body: some View {
        ZStack {
            Circle().fill(.white).frame(width: 44, height: 44).offset(x: -24, y: -10)
            Circle().fill(.white).frame(width: 50, height: 50).offset(x: 0, y: -18)
            Circle().fill(.white).frame(width: 44, height: 44).offset(x: 24, y: -10)
            RoundedRectangle(cornerRadius: 6)
                .fill(.white)
                .frame(width: 76, height: 26)
                .offset(y: 8)
            RoundedRectangle(cornerRadius: 6)
                .stroke(Theme.ink.opacity(0.12), lineWidth: 1.5)
                .frame(width: 76, height: 26)
                .offset(y: 8)
        }
        .shadow(color: Theme.ink.opacity(0.15), radius: 2, y: 2)
    }
}

private struct SmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                          control: CGPoint(x: rect.midX, y: rect.minY + rect.height * 2))
        path.closeSubpath()
        return path
    }
}

private struct EyeArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                          control: CGPoint(x: rect.midX, y: rect.minY - rect.height))
        return path
    }
}

private struct ApronShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.18, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.18, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    PapaWinAvatar(size: 240)
        .padding()
        .background(Theme.cream)
}
