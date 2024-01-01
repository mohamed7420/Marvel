//
//  CharacterListViewModel.swift
//  Marvel
//
//  Created by Mohamed Osama on 29/12/2023.
//

import Foundation
import RxSwift
import RxRelay

class CharacterListViewModel {
    private let manager = NetworkService()
    public let resultBehaviorRelay = BehaviorRelay<[Result]>(value: [])
    public let isLoadingBehavior = BehaviorRelay(value: false)
    private var offset: Int = 1

    public func loadAllCharacters() async  {
        isLoadingBehavior.accept(true)
        do {
            let response: APIModelResponse = try await manager.request(parameters: [:])
             resultBehaviorRelay.accept(response.data.results)
        } catch {
            print(error.localizedDescription)
        }
        isLoadingBehavior.accept(false)
    }

    public func loadMoreCharacters() async {
        isLoadingBehavior.accept(true)
        do {
            let newOffset = offset + 1
            let response: APIModelResponse = try await manager.request(parameters: ["offset": "\(newOffset)"])
            if !response.data.results.isEmpty  {
                var characters = resultBehaviorRelay.value
                characters.append(contentsOf: response.data.results)
                self.resultBehaviorRelay.accept(characters)
                self.offset = newOffset
            }
        } catch {
            print(error.localizedDescription)
            offset -= 1
        }
        isLoadingBehavior.accept(false)
    }

}
