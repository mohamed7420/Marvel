//
//  SearchViewModel.swift
//  Marvel
//
//  Created by Mohamed Osama on 31/12/2023.
//

import Foundation
import RxSwift
import RxRelay

class SearchViewModel {
    private let manager = NetworkService()
    let isLoadingBehavior = BehaviorRelay<Bool>(value: false)
    let resultBehaviorRelay = BehaviorRelay<[Result]>(value: [])

    public func loadAllCharacters(text: String) async  {
        isLoadingBehavior.accept(true)
        do {
            let response: APIModelResponse = try await manager.request(parameters: ["nameStartsWith": text])
             resultBehaviorRelay.accept(response.data.results)
        } catch {
            print(error.localizedDescription)
        }
        isLoadingBehavior.accept(false)
    }
}
