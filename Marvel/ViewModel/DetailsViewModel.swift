//
//  DetailsViewModel.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import Foundation

class DetailsViewModel {
    
    private let result: Result

    init(result: Result) {
        self.result = result
    }
    var thumbnail: String {
        return result.thumbnail.path + ".\(result.thumbnail.fileExtension)"
    }

    var name: String {
        result.name
    }

    var description: String {
        result.description
    }

    var comics: [ComicsItem] {
        result.comics.items
    }

    var series: [ComicsItem] {
        result.series.items
    }

    var events: [ComicsItem] {
        result.events.items
    }

    var stories: [StoriesItem] {
        result.stories.items
    }

    var links: [URLElement] {
        result.urls
    }
}
