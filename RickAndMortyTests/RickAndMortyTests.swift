//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Chandran, Sudha on 17/06/21.
//

import XCTest
@testable import RickAndMorty
import Combine

class RickAndMortyTests: XCTestCase {
    
    var networkHandler = NetworkHandler()
    let apiClient = RickMortyAPI()
    var cancellable: AnyCancellable?
    
    func testRequestAllEpisodes() {
        
        let expectation = XCTestExpectation(description: "Request all episodes")
        
        cancellable = apiClient.getAllEpisodes()
            .sink(receiveCompletion: { _ in }, receiveValue: { episodes in
                episodes.forEach() { _ in }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRequestAllCharacters() {
        
        let expectation = XCTestExpectation(description: "Request all characters")
        
        cancellable = apiClient.getAllCharacters()
            .sink(receiveCompletion: { _ in }, receiveValue: { characters in
                characters.forEach() { _ in }
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testNetworkRequestByMethodError() {
        
        let expectation = XCTestExpectation(description: "Test for error handling in request by method")
        
        networkHandler.performAPIRequestByMethod(method: "abcd") {
            switch $0 {
            case .success( _):
                break
            case.failure( _):
                expectation.fulfill()
            }
        }
    }
    
    func testJSONResponseDataParsing() {
        
        let expectation = XCTestExpectation(description: "Test decoding data response")
        
        networkHandler.performAPIRequestByMethod(method: "character/1") {
            switch $0 {
            case .success(let data):
                if let _: CharacterModel = self.networkHandler.decodeJSONData(data: data) {
                    expectation.fulfill()
                }
            case.failure( _):
                break
            }
        }
    }
    
    func testJSONResponseDataParsingError() {
        
        let expectation = XCTestExpectation(description: "Test decoding data response")
        
        networkHandler.performAPIRequestByMethod(method: "character/1") {
            switch $0 {
            case .success(let data):
                if let _: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                } else {
                    expectation.fulfill()
                }
            case.failure( _):
                break
            }
        }
    }
}
