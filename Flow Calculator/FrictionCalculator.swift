//
//  FrictionCalculator.swift
//  Flow Calculator
//
//  Created by Samuel Schmitt on 11/6/17.
//  Copyright © 2017 Samuel Schmitt. All rights reserved.
//

import Foundation

/// Results from friction flow calculation
struct FrictionFlowResult {
    let reynoldsNumber: Double
    let wallReynoldsNumber: Double
    let relativeRoughness: Double
    let frictionFactor: Double

    var reynoldsNumberFormatted: String {
        String(format: "%.3f", reynoldsNumber)
    }

    var wallReynoldsNumberFormatted: String {
        String(format: "%.4f", wallReynoldsNumber)
    }

    var relativeRoughnessFormatted: String {
        String(format: "%.4f", relativeRoughness)
    }

    var frictionFactorFormatted: String {
        String(format: "%.4f", frictionFactor)
    }
}

/// ViewModel for friction flow calculations
@MainActor
class FrictionCalculator: ObservableObject {
    @Published var velocity: String = ""
    @Published var diameter: String = ""
    @Published var kinematicViscosity: String = ""
    @Published var roughnessLength: String = ""

    @Published var result: FrictionFlowResult?
    @Published var errorMessage: String?

    private let tolerance = 0.001

    /// Calculate friction flow parameters
    func calculate() {
        // Reset previous results
        errorMessage = nil
        result = nil

        // Validate and parse inputs
        guard let vel = Double(velocity),
              let diam = Double(diameter),
              let kinVisc = Double(kinematicViscosity),
              let roughLen = Double(roughnessLength) else {
            errorMessage = "Please enter valid numbers for all fields"
            return
        }

        // Validate positive values
        guard vel > 0, diam > 0, kinVisc > 0, roughLen >= 0 else {
            errorMessage = "Values must be positive (roughness can be zero)"
            return
        }

        // Calculate Reynolds number and relative roughness
        let reynoldsNumber = (vel * diam) / kinVisc
        let relativeRoughness = roughLen / diam

        var frictionFactor: Double
        var wallReynoldsNumber: Double

        // Determine flow regime and calculate friction factor
        if reynoldsNumber < 4000 {
            // Laminar flow - Hagen-Poiseuille equation
            frictionFactor = 64 / reynoldsNumber
            wallReynoldsNumber = reynoldsNumber * relativeRoughness * sqrt(frictionFactor / 8)
        } else {
            // Turbulent flow - Swamee-Jain equation with iterative refinement
            frictionFactor = 1.34 / pow(log(3.7 / relativeRoughness), 2.0)
            wallReynoldsNumber = reynoldsNumber * relativeRoughness * sqrt(frictionFactor / 8)

            if wallReynoldsNumber > 70 {
                // Fully rough turbulent flow
                // Use initial calculation
            } else {
                // Transition region - use modified Swamee-Jain
                frictionFactor = 1.63 / pow(log(pow(relativeRoughness / 3.7, 1.11) + 6.9 / reynoldsNumber), 2.0)
                wallReynoldsNumber = reynoldsNumber * relativeRoughness * sqrt(frictionFactor / 8)

                if wallReynoldsNumber > 1 {
                    // Use transition calculation
                } else {
                    // Smooth pipe region - iterative solution
                    var epsilon = 1.0
                    while epsilon > tolerance {
                        let fNew = 1.34 / pow(log(0.396 * reynoldsNumber * sqrt(frictionFactor)), 2.0)
                        epsilon = abs(fNew - frictionFactor) / frictionFactor
                        frictionFactor = fNew
                    }
                    wallReynoldsNumber = reynoldsNumber * relativeRoughness * sqrt(frictionFactor / 8)
                }
            }
        }

        // Store results
        result = FrictionFlowResult(
            reynoldsNumber: reynoldsNumber,
            wallReynoldsNumber: wallReynoldsNumber,
            relativeRoughness: relativeRoughness,
            frictionFactor: frictionFactor
        )
    }

    /// Clear all inputs and results
    func clear() {
        velocity = ""
        diameter = ""
        kinematicViscosity = ""
        roughnessLength = ""
        result = nil
        errorMessage = nil
    }
}
