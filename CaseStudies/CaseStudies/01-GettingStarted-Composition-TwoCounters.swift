//
//  01-GettingStarted-Composition-TwoCounters.swift
//  CaseStudies
//
//  Created by 김건우 on 11/11/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct TwoCounters {
    @ObservableState
    struct State: Equatable {
        var counter1 = Counter.State()
        var counter2 = Counter.State()
    }
    
    enum Action {
        case counter1(Counter.Action)
        case counter2(Counter.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.counter1, action: \.counter1) {
            Counter()
        }
        Scope(state: \.counter2, action: \.counter2) {
            Counter()
        }
        
        Reduce { state, action in
            switch action {
            case .counter1(.incrementButtonTapped):
                print("Counter 1 - Increment Button Tapped")
                return .none
                
            case .counter1(.decrementButtonTapped):
                print("Counter 1 - Decrement Button Tapped")
                return .none
            case .counter2(.incrementButtonTapped):
                print("Counter 2 - Increment Button Tapped")
                return .none
                
            case .counter2(.decrementButtonTapped):
                print("Counter 2 - Decrement Button Tapped")
                return .none
            default:
                return .none
            }
        }
    }
}


struct TwoCountersView: View {
    let store: StoreOf<TwoCounters>
    
    var body: some View {
        VStack {
            HStack {
                Text("Counter 1")
                CounterView(store: store.scope(state: \.counter1, action: \.counter1))
            }
            
            HStack {
                Text("Counter 2")
                CounterView(store: store.scope(state: \.counter2, action: \.counter2))
            }
        }
    }
}

#Preview {
    NavigationStack {
        TwoCountersView(
            store: Store(initialState: TwoCounters.State()) {
                TwoCounters()
            }
        )
    }
}
