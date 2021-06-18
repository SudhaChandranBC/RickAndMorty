//
//  RickMortyAPI.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//

import Combine
import Foundation

/**
 RickMortyAPI struct contains all functions to request episode(s) character(s) information(s).
 */
public struct RickMortyAPI {
    
    let networkHandler: NetworkHandler = NetworkHandler()
    
    /**
     Request all episodes.
     - Returns: Array of Episode model struct.
     */
    public func getAllEpisodes() -> Future <[EpisodeModel], Error> {
        return Future() { promise in
            var allEpisodes = [EpisodeModel]()
            networkHandler.performAPIRequestByMethod(method: "episode") {
                switch $0 {
                case .success(let data):
                    if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                        allEpisodes = infoModel.results
                        let episodesDispatchGroup = DispatchGroup()
                        
                        for index in 2...infoModel.info.pages {
                            episodesDispatchGroup.enter()
                            
                            networkHandler.performAPIRequestByMethod(method: "episode/"+"?page="+String(index)) {
                                switch $0 {
                                case .success(let data):
                                    if let infoModel: EpisodeInfoModel = self.networkHandler.decodeJSONData(data: data) {
                                        allEpisodes.append(contentsOf: infoModel.results)
                                        episodesDispatchGroup.leave()
                                    }
                                case .failure(let error):
                                    promise(.failure(error))
                                }
                            }
                        }
                        episodesDispatchGroup.notify(queue: DispatchQueue.main) {
                            promise(.success(allEpisodes.sorted { $0.id < $1.id }))
                        }
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    /**
     Request all characters.
     - Returns: Array of Character model struct.
     */
    public func getAllCharacters() -> Future <[CharacterModel], Error> {
        return Future() { promise in
            var allCharacters = [CharacterModel]()
            networkHandler.performAPIRequestByMethod(method: "character") {
                switch $0 {
                case .success(let data):
                    if let infoModel: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                        allCharacters = infoModel.results
                        let charactersDispatchGroup = DispatchGroup()
                        
                        for index in 2...infoModel.info.pages {
                            charactersDispatchGroup.enter()
                            
                            networkHandler.performAPIRequestByMethod(method: "character/"+"?page="+String(index)) {
                                switch $0 {
                                case .success(let data):
                                    if let infoModel: CharacterInfoModel = self.networkHandler.decodeJSONData(data: data) {
                                        allCharacters.append(contentsOf: infoModel.results)
                                        charactersDispatchGroup.leave()
                                    }
                                case .failure(let error):
                                    promise(.failure(error))
                                }
                            }
                        }
                        charactersDispatchGroup.notify(queue: DispatchQueue.main) {
                            promise(.success(allCharacters.sorted { $0.id < $1.id }))
                        }
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
}

