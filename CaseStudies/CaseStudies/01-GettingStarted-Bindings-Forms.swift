//
//  01-GettingStarted-Bindings-Forms.swift
//  CaseStudies
//
//  Created by 김건우 on 11/14/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct BindingsForm {
    @ObservableState
    struct State: Equatable {
        var sliderValue = 5.0
        var stepCount = 10
        var text = ""
        var toggleIsOn = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case resetButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.stepCount):
                state.sliderValue = min(state.sliderValue, Double(state.stepCount))
                return .none
                
            case .binding:
                return .none
                
            case .resetButtonTapped:
                state = State()
                return .none
            }
        }
    }
}

struct BindingsFormView: View {
    @Bindable var store: StoreOf<BindingsForm>
    
    var body: some View {
        VStack {
            TextField("Type here", text: $store.text)
                .autocorrectionDisabled()
                .foregroundStyle(
                    store.toggleIsOn ? Color.secondary : .primary
                )
            Text(alternate(store.text))
            
            Toggle(
                "Disable other controls",
                isOn: $store.toggleIsOn
            )
            
            Stepper(
                "Max slider value: \(store.stepCount)",
                value: $store.stepCount,
                in: 0...100
            )
            .disabled(store.toggleIsOn)
            
            HStack {
                Text("Slider value: \(Int(store.sliderValue))")
                
                Slider(
                    value: $store.sliderValue,
                    in: 0...Double(store.stepCount)
                )
                .tint(.accentColor)
            }
            .disabled(store.toggleIsOn)
            
            Button("Reset") {
                store.send(.resetButtonTapped)
            }
            .tint(.red)
        }
        .padding()
        .monospacedDigit()
        .navigationTitle("Bindings Form")
    }
}

private func alternate(_ string: String) -> String {
    string
        .enumerated()
        .map { idx, char in
            idx.isMultiple(of: 2)
            ? char.uppercased()
            : char.lowercased()
        }
        .joined()
}

#Preview {
    NavigationStack {
        BindingsFormView(
            store: StoreOf<BindingsForm>(initialState: BindingsForm.State()) {
                BindingsForm()
            }
        )
    }
}
