//
//  01-GettingStarted-Counter.swift
//  CaseStudies
//
//  Created by 김건우 on 11/10/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct Counter {
    @ObservableState
    struct State: Equatable {
        var count = 0
        var numberFact: String?
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case randomNumbersButtonTapped
        case randomNumbersResponse(String)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            case .incrementButtonTapped:
                state.count += 1
                return .none
            case .randomNumbersButtonTapped:
                return .run { [count = state.count] send in
                    let (data, _) = try await URLSession.shared.data(
                        from: URL(string: "http://www.randomnumberapi.com/api/v1.0/random?min=100&max=1000&count=\(count)")!
                    )
                    await send(.randomNumbersResponse(String(decoding: data, as: UTF8.self)))
                }
            case let .randomNumbersResponse(fact):
                state.numberFact = fact
                return .none
            }
        }
    }
}

struct CounterView: View {
    let store: StoreOf<Counter>
    
    var body: some View {
        Form {
            Section {
                Text("\(store.count)")
                    .monospacedDigit()
                
                Button {
                    store.send(.decrementButtonTapped)
                } label: {
                    Image(systemName: "minus")
                }
                
                Button {
                    store.send(.incrementButtonTapped)
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            Section {
                Button("Random Numbers") {
                    store.send(.randomNumbersButtonTapped)
                }
                
                if let fact = store.numberFact {
                    Text(fact)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CounterView(
            store: Store(initialState: Counter.State()) {
                Counter()
            }
        )
    }
}
