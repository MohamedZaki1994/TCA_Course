//
//  TCAApp.swift
//  TCA
//
//  Created by Mohamed Zaki on 05/05/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationStack {
				Form {
					NavigationLink {
						BasicView(store: Store(initialState: BasicReducer.State(), reducer: {
							BasicReducer()
						}))
					} label: {
						Text("Basic counter")
					}
					
					NavigationLink {
						BindingView(store: Store(initialState: CaseBindingReducer.State(), reducer: {
							CaseBindingReducer()
						}))
					} label: {
						Text("Binding")
					}
					
					NavigationLink {
						ParentView(store: Store(initialState: ParentReducer.State(), reducer: {
							ParentReducer()
						}))
					} label: {
						Text("Delegation")
					}
				}
				.navigationTitle("Cases")
			}

        }
    }
}
