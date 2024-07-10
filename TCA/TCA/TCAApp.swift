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
	@State var openTree = false
	@State var openStack = false
	@State var openStackShared = false
    var body: some Scene {
        WindowGroup {
			NavigationStack {
				SharedRootView(store: Store(initialState: SharedRootReducer.State(), reducer: {
					SharedRootReducer()
				}))
//				Form {
//					NavigationLink {
//						BasicView(store: Store(initialState: BasicReducer.State(), reducer: {
//							BasicReducer()
//						}))
//					} label: {
//						Text("Basic counter")
//					}
//					
//					NavigationLink {
//						BindingView(store: Store(initialState: CaseBindingReducer.State(), reducer: {
//							CaseBindingReducer()
//						}))
//					} label: {
//						Text("Binding")
//					}
//					
//					NavigationLink {
//						ParentView(store: Store(initialState: ParentReducer.State(), reducer: {
//							ParentReducer()
//						}))
//					} label: {
//						Text("Delegation")
//					}
//					
//					NavigationLink {
//						DependencyView(store: Store(initialState: DependencyReducer.State(), reducer: {
//							DependencyReducer()
//						}))
//					} label: {
//						Text("Dependency")
//					}
//					
//					NavigationLink {
//						ParentGamesView(store: Store(initialState: ParentGamesReducer.State(), reducer: {
//							ParentGamesReducer()
//						}))
//					} label: {
//						Text("Identified Array")
//					}
//					
//					Button("Open Tree") {
//						openTree.toggle()
//					}
//					
//					Button("Open Stack") {
//						openStack.toggle()
//					}
//					
//					Button("Open Shared") {
//						openStackShared.toggle()
//					}
//				}
//				.fullScreenCover(isPresented: $openTree, content: {
//					NavigationStack {
//						TreeView(store: Store(initialState: TreeReducer.State(), reducer: {
//							TreeReducer()
//						}))
//					}
//				})
//				.fullScreenCover(isPresented: $openStack, content: {
//					StackRootView(store: Store(initialState: StackRootReducer.State(), reducer: {
//						StackRootReducer()
//					}))
//					
//				})
//				.fullScreenCover(isPresented: $openStackShared, content: {
//					SharedRootView(store: Store(initialState: SharedRootReducer.State(), reducer: {
//						SharedRootReducer()
//					}))
//					
//				})
				.navigationBarTitleDisplayMode(.inline)
				
				.navigationTitle("Cases")
			}

        }
    }
}

