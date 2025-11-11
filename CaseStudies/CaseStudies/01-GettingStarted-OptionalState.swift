//
//  01-GettingStarted-OptionalState.swift
//  CaseStudies
//
//  Created by 김건우 on 11/11/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct OptionalState {
    @ObservableState
    struct State: Equatable {
        var optionalCounter: Counter.State?
    }
    
    enum Action {
        case optionalCounter(Counter.Action)
        case toggleCounterButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleCounterButtonTapped:
                state.optionalCounter = state.optionalCounter == nil
                ? Counter.State()
                : nil
                return .none
            case .optionalCounter(.randomNumbersButtonTapped):
                print("OptionalCounter - Random Numbers Button Tapped")
                return .none
            case .optionalCounter:
                return .none
            }
        }
        .ifLet(\.optionalCounter, action: \.optionalCounter) {
            Counter()
        }
    }
}

struct OptionalStateView: View {
    let store: StoreOf<OptionalState>
    
    var body: some View {
        VStack {
            Button("Toggle counter state") {
                store.send(.toggleCounterButtonTapped)
            }
            
            if let store = store.scope(state: \.optionalCounter, action: \.optionalCounter) {
                CounterView(store: store)
                    .padding()
            } else {
                Text("`Counter.State` is nil")
            }
        }
    }
}

#Preview {
    NavigationStack {
        OptionalStateView(
            store: Store(initialState: OptionalState.State()) {
                OptionalState()
            }
        )
    }
}
