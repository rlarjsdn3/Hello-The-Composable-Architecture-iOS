//
//  01-GettingStarted-AlertAndConfirmationDialog.swift
//  CaseStudies
//
//  Created by 김건우 on 11/11/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AlertAndConfirmationDialog {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        @Presents var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
        var count = 0
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case alertButtonTapped
        case confirmationDialog(PresentationAction<ConfirmationDialog>)
        case confirmationDialogButtonTapped
        
        @CasePathable
        enum Alert {
            case incrementButtonTapped
        }
        
        @CasePathable
        enum ConfirmationDialog {
            case incrementButtonTapped
            case decrementButtonTapped
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce {
            state,
            action in
            switch action {
            case .alert(.presented(.incrementButtonTapped)),
                    .confirmationDialog(.presented(.incrementButtonTapped)):
                state.alert = AlertState { TextState("Incremented!") }
                state.count += 1
                return .none
                
            case .alert:
                return .none
                
            case .alertButtonTapped:
                state.alert = AlertState(
                    title: {
                        TextState("Alert!")
                    },
                    actions: {
                        ButtonState(role: .cancel) {
                            TextState("Cancel")
                        }
                        ButtonState(action: .incrementButtonTapped) {
                            TextState("Increment")
                        }
                    },
                    message: {
                        TextState("This is an alert")
                    }
                )
                return .none
                
            case .confirmationDialog(.presented(.decrementButtonTapped)):
                state.alert = AlertState {
                    TextState("Decremented!")
                }
                state.count -= 1
                return .none
                
            case .confirmationDialog:
                return .none
                
            case .confirmationDialogButtonTapped:
                state.confirmationDialog = ConfirmationDialogState {
                    TextState("Confirmation Dialog")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .incrementButtonTapped) {
                        TextState("Increment")
                    }
                    ButtonState(action: .decrementButtonTapped) {
                        TextState("Decrement")
                    }
                } message: {
                    TextState("This is a confirmation dialog.")
                }
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.confirmationDialog, action: \.confirmationDialog)
    }
}

struct AlertAndConfirmationDialogView: View {
    @Bindable var store: StoreOf<AlertAndConfirmationDialog>
    
    var body: some View {
        Form {
            Text("Count: \(store.count)")
            Button("Alert") {
                store.send(.alertButtonTapped)
            }
            Button("Confirmation Dialog") {
                store.send(.confirmationDialogButtonTapped)
            }
        }
        .navigationTitle("Alerts & Dialogs")
        .alert($store.scope(state: \.alert, action: \.alert))
        .confirmationDialog($store.scope(state: \.confirmationDialog, action: \.confirmationDialog))
    }
}

#Preview {
    AlertAndConfirmationDialogView(
        store: Store(initialState: AlertAndConfirmationDialog.State()) {
            AlertAndConfirmationDialog()
        }
    )
}
