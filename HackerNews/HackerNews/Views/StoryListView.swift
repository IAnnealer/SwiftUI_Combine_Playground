//
//  StoryListView.swift
//  HackerNews
//
//  Created by Ian on 2021/12/16.
//

import SwiftUI

struct StoryListView: View {

    // MARK: - Properties

    // StoryListViewModel 내 @Published 가 존재함. 이를 Observing 하기 위해 @ObservedObject 선언
    @ObservedObject private var storyListViewModel = StoryListViewModel()

    var body: some View {
        NavigationView {
            List(self.storyListViewModel.stories, id: \.id) { storyViewModel in
                Text("\(storyViewModel.id)")
            }
            .navigationTitle("Hacker News")
        }
    }
}

struct StoryListView_Previews: PreviewProvider {
    static var previews: some View {
        StoryListView()
    }
}