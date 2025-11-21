//
//  ContentView.swift
//  Flow Calculator
//
//  Created by Samuel Schmitt on 11/6/17.
//  Copyright © 2017 Samuel Schmitt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var calculator = FrictionCalculator()
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case velocity, diameter, kinematicViscosity, roughnessLength
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Input Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Input Parameters")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        InputField(
                            title: "Velocity",
                            value: $calculator.velocity,
                            focused: $focusedField,
                            field: .velocity
                        )

                        InputField(
                            title: "Diameter",
                            value: $calculator.diameter,
                            focused: $focusedField,
                            field: .diameter
                        )

                        InputField(
                            title: "Kinematic Viscosity",
                            value: $calculator.kinematicViscosity,
                            focused: $focusedField,
                            field: .kinematicViscosity
                        )

                        InputField(
                            title: "Roughness Length",
                            value: $calculator.roughnessLength,
                            focused: $focusedField,
                            field: .roughnessLength
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    // Calculate Button
                    HStack(spacing: 12) {
                        Button(action: {
                            focusedField = nil
                            calculator.calculate()
                        }) {
                            Label("Calculate", systemImage: "function")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            focusedField = nil
                            calculator.clear()
                        }) {
                            Image(systemName: "trash")
                                .font(.headline)
                                .frame(width: 50, height: 50)
                                .background(Color.secondary.opacity(0.2))
                                .foregroundColor(.secondary)
                                .cornerRadius(10)
                        }
                    }

                    // Error Message
                    if let errorMessage = calculator.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }

                    // Results Section
                    if let result = calculator.result {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Results")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            ResultRow(
                                title: "Reynolds Number",
                                value: result.reynoldsNumberFormatted
                            )

                            ResultRow(
                                title: "Wall Reynolds Number",
                                value: result.wallReynoldsNumberFormatted
                            )

                            ResultRow(
                                title: "Relative Roughness",
                                value: result.relativeRoughnessFormatted
                            )

                            ResultRow(
                                title: "Friction Factor",
                                value: result.frictionFactorFormatted
                            )
                        }
                        .padding()
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Friction Calculator")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Input Field Component

struct InputField: View {
    let title: String
    @Binding var value: String
    var focused: FocusState<ContentView.Field?>.Binding
    let field: ContentView.Field

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)

            TextField("Enter value", text: $value)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .focused(focused, equals: field)
        }
    }
}

// MARK: - Result Row Component

struct ResultRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemBackground))
                .cornerRadius(6)
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
