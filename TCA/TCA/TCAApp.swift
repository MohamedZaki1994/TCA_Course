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
				}
				.navigationTitle("Cases")
			}

        }
    }
}
