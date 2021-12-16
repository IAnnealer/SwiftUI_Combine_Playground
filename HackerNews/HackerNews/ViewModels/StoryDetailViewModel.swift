//
//  StoryDetailViewModel.swift
//  HackerNews
//
//  Created by Ian on 2021/12/16.
//

import Foundation
import Combine

class StoryDetailViewModel: ObservableObject {

    // MARK: - Properties

    var storyId: Int
    private var cancellable: AnyCancellable?

    @Published private var story: Story!

    var title: String {
        return self.story.title
    }

    var url: URL
    {
        return URL(string: self.story.url)!
    }

    // MARK: - Initializer
    init(storyId: Int) {
        self.storyId = storyId
        self.cancellable = WebService.shared.getStoryById(storyId: storyId)
            .sink(receiveCompletion: { _ in }, receiveValue: {
                self.story = $0
            })
    }
}
