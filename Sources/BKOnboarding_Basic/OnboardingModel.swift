//
//  OnboardingModel.swift
//  BKOnboarding_Basic
//
//  Created by Baturay Koc on 10/12/25.
//

import SwiftUI

public struct OnboardingModel: Identifiable {
    public let id = UUID()
    public let imageName: String
    public let title: String
    public let description: String

    public init(imageName: String, title: String, description: String) {
        self.imageName = imageName
        self.title = title
        self.description = description
    }
}
