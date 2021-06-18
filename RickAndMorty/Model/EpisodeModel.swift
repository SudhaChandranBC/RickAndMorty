//
//  EpisodeModel.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//

import Foundation

/**
 EpisodeInfoModel struct for decoding info json response.
 ### Properties
 - **info**: Information about episode count and pagination.
 - **results**: First page with 20 episodes.
 
 ### SeeAlso
 - **Info**: Info struct in NetworkHandler.swift.
 - **EpisodeModel**: EpisodeModel struct in EpisodeModel.swift.
 */
struct EpisodeInfoModel: Codable {
    let info: Info
    let results: [EpisodeModel]
}

/**
 Episode struct for decoding episode json response.
 ### Properties
 - **id**: The id of the episode.
 - **name**: The name of the episode.
 - **airDate**: The air date of the episode.
 - **episode**: The code of the episode.
 - **characters**: List of characters who have been seen in the episode.
 - **url**: Link to the episode's own endpoint.
 - **created**: Time at which the episode was created in the database.
 */
public struct EpisodeModel: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let airDate: String
    public let episode: String
    public let characters: [String]
    public let url: String
    public let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
    
    /**
     Perform string formatting and returns season number from episode string.
     - Returns: String formatted season name like Season 1, Season 2 etc.
     */
    func seasonNumber() -> String {
        let intVal = Int(episode.prefix(3).suffix(2))
        return String(format: "Season %01d", intVal!)
    }
    
    /**
     Perform string formatting and returns episode number from episode string.
     - Returns: String formatted episode name like Episode 1, Episode 2 etc.
     */
    func episodeNumber() -> String  {
        let intVal = Int(episode.suffix(3).suffix(2))
        return String(format: "Episode %01d", intVal!)
    }
}

