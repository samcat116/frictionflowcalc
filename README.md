# frictionflowcalc

## Friction Flow Calculator
An iOS App to calculate common properties for pipe flow. Inputs are fluid velocity, pipe diameter, kinematic viscosity, and roughness length. Outputs are both Reynolds numbers (Normal and Wall), relative roughness, and the friction factor.

### Version 2.0 - SwiftUI Modernization

This app has been modernized to use SwiftUI with modern Swift patterns:

- **SwiftUI Interface**: Modern, declarative UI built with SwiftUI
- **iOS 15+ Target**: Updated deployment target for modern iOS releases
- **No Dependencies**: Removed CocoaPods and HandyUIKit dependency
- **MVVM Architecture**: Clean separation with `FrictionCalculator` view model
- **Modern Swift**: Updated to use latest Swift features and patterns

### Technical Details

**Calculation Engine**:
- Laminar flow (Re < 4000): Hagen-Poiseuille equation
- Turbulent flow (Re ≥ 4000): Swamee-Jain equation with iterative refinement
- Multiple flow regime checks for accurate friction factor determination

**Requirements**:
- iOS 15.0 or later
- Xcode 13.0 or later
