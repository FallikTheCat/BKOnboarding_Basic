//
//  OnboardingView.swift
//  BKOnboarding_Basic
//
//  Created by Baturay Koc on 10/12/25.
//

import SwiftUI
import StoreKit

public struct BKOnboardingView: View {
    @Environment(\.requestReview) var requestReview
    @State private var currentScreen = 0
    @State private var askingReview = false
    @Binding public var onboardingShown: Bool
    public let onboardingItems: [OnboardingModel]
    
    public init(
        onboardingItems: [OnboardingModel],
        onboardingShown: Binding<Bool>
    ) {
        self.onboardingItems = onboardingItems
        self._onboardingShown = onboardingShown
    }
    
    public var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ZStack {
                OnboardDetails(
                    imageName: onboardingItems[currentScreen].imageName,
                    title: onboardingItems[currentScreen].title,
                    description: onboardingItems[currentScreen].description
                )
                VStack {
                    Spacer()
                    ContinueButtonView()
                }
            }
            .onAppear{
                getOnboardingShownValue()
            }
            .overlay {
                if askingReview {
                    LoadingView()
                }
            }
        }
    }
}

private extension BKOnboardingView {
    func OnboardDetails(imageName: String, title: String, description: String) -> some View {
        VStack(spacing: 35) {
            Image(systemName: imageName)
                .foregroundStyle(.orange)
                .font(.largeTitle)
                .frame(height: 150)
            Text(title)
                .font(.title)
                .bold()
                .foregroundColor(.white)
            Text(description)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }

    func ContinueButtonView() -> some View {
        Button(action: handleOnbButton) {
            ZStack {
                RoundedRectangle(cornerRadius: 60)
                    .fill(.white)
                    .frame(height: 55)
                    .padding()
                Text(currentScreen == 0 ? "Get Started" : "Continue")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 7)
        }
        .cornerRadius(60)
        .shadow(color: .white.opacity(0.2), radius: 12, x: 2, y: 0)
    }

    func LoadingView() -> some View {
        ZStack {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            ProgressView().tint(.white)
        }
    }

    func handleOnbButton() {
        let impactMed = UIImpactFeedbackGenerator(style: .rigid)
        impactMed.impactOccurred()
        withAnimation {
            if currentScreen < onboardingItems.count - 1 {
                currentScreen += 1
            } else {
                askingReview = true
                requestReview()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        UserDefaults(suiteName: "onboardingShown")?.set(true, forKey: "onboardingShown")
                        onboardingShown = true
                        askingReview = false
                    }
                }
            }
        }
    }
    
    func getOnboardingShownValue() {
        let userDefaultsOnboardingShown = UserDefaults(suiteName: "onboardingShown")
        if ((userDefaultsOnboardingShown?.value(forKey: "onboardingShown")) != nil) {
            onboardingShown = userDefaultsOnboardingShown?.value(forKey: "onboardingShown") as! Bool
        } else {
            userDefaultsOnboardingShown?.set(false, forKey: "onboardingShown")
            onboardingShown = false
        }
    }
}
