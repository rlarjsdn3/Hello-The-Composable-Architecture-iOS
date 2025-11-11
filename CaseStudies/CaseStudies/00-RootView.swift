//
//  ContentView.swift
//  CaseStudies
//
//  Created by 김건우 on 11/10/25.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    @State var isNavigationStackCaseStudyPresented = false
    @State var isSignUpCaseStudyPresented = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink("Basics") {
                        Demo(store: Store(initialState: Counter.State()) {
                            Counter()
                        }, content: { store in
                            CounterView(store: store)
                        })
                    }
                    
                    NavigationLink("Alert & Confirmation Dialog") {
                        Demo(store: Store(initialState: AlertAndConfirmationDialog.State()) {
                            AlertAndConfirmationDialog()
                        }, content: { store in
                            AlertAndConfirmationDialogView(store: store)
                        })
                    }
                    
                    NavigationLink("Optional State") {
                        Demo(store: Store(initialState: OptionalState.State()) {
                            OptionalState()
                        }, content: { store in
                            OptionalStateView(store: store)
                        })
                    }
                } header: {
                    Text("Getting Started")
                }

            }
        }
    }
}

/// This wrapper provides an "entry" point into an individual demo that can own a store.
struct Demo<State, Action, Content: View>: View {
    @SwiftUI.State var store: Store<State, Action>
    let content: (Store<State, Action>) -> Content
    
    init(
        store: Store<State, Action>,
        @ViewBuilder content: @escaping (Store<State, Action>) -> Content
    ) {
        self.store = store
        self.content = content
    }
    
    var body: some View {
        content(store)
    }
}

#Preview {
    ContentView()
}
