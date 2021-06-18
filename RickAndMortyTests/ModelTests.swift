//
//  ViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Chandran, Sudha on 18/06/21.
//

import XCTest
@testable import RickAndMorty
import Combine

class ModelTests: XCTestCase {
    
    func testSearchResponse() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "AllEpisodes", ofType: "json") else {
            fatalError("AllEpisodes.json not found")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try JSONDecoder().decode(EpisodeInfoModel.self, from: data)
        
        XCTAssertEqual(response.info.count, 41)
        XCTAssertEqual(response.info.pages, 3)
        XCTAssertEqual(response.info.next!, "https://rickandmortyapi.com/api/episode?page=2")
        XCTAssertNil(response.info.prev)
        XCTAssertTrue((response.results.count != 0))
        
        let firstEpisode = response.results.first!
        
        XCTAssertEqual(firstEpisode.id, 1)
        XCTAssertEqual(firstEpisode.name, "Pilot")
        XCTAssertEqual(firstEpisode.airDate, "December 2, 2013")
        XCTAssertEqual(firstEpisode.episode, "S01E01")
        XCTAssertEqual(firstEpisode.characters.count, 19)
        XCTAssertEqual(firstEpisode.seasonNumber(), "Season 1")
        XCTAssertEqual(firstEpisode.episodeNumber(), "Episode 1")
    }
    
    func testCharacterViewModel() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "AllCharacters", ofType: "json") else {
            fatalError("AllCharacters.json not found")
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try JSONDecoder().decode(CharacterInfoModel.self, from: data)
        
        XCTAssertEqual(response.info.count, 671)
        XCTAssertEqual(response.info.pages, 34)
        XCTAssertEqual(response.info.next!, "https://rickandmortyapi.com/api/character?page=2")
        XCTAssertNil(response.info.prev)
        XCTAssertTrue((response.results.count != 0))
        
        let characters = response.results
        let firstCharacter = characters.first!
        
        XCTAssertEqual(characters.count, 20)
        XCTAssertEqual(firstCharacter.name, "Rick Sanchez")
        XCTAssertEqual(firstCharacter.species, "Human")
        XCTAssertEqual(firstCharacter.imageURL(), URL(string: firstCharacter.image))
        
        let expectation = XCTestExpectation(description: "Test for ImageLoader")
        let loader = ImageLoader.init(url: firstCharacter.imageURL())
        expectation.fulfill()
        loader.load()
    }
    
}

