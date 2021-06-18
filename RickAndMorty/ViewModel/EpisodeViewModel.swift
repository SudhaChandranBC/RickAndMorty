//
//  EpisodeViewModel.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//

import Foundation
import Combine
import SwiftUI

/**
 EpisodeViewModel struct for Episode List View.
 ### Properties
 - **episodes**: Array of EpisodeModel struct.
 - **seasonsArray**: Computed array of seasons and episodes info.
 - **characterModel**: Observes CharacterViewModel to fetch all characters.
 
 ### SeeAlso
 - **RickMortyAPI**: RickMortyAPI struct in RickMortyAPI.swift.
 - **EpisodeModel**: EpisodeModel struct in EpisodeModel.swift.
 - **CharacterModel**: CharacterModel struct in CharacterModel.swift.
 */
class EpisodeViewModel: ObservableObject {
    @Published private(set) var episodes: [EpisodeModel] = []
    @Published private(set) var seasonsArray = [Int]()
    @ObservedObject private(set) var characterModel = CharacterViewModel()
    
    private var cancellationToken: AnyCancellable?
    
    init() {
        getEpisodes()
    }
    
    /**
     Perform filtering the episodes of the selected season from all episodes array.
     - Returns: Filtered array of episodes for selected season.
     */
    func filterEpisodes(forSeason: Int) -> [EpisodeModel]? {
        return episodes.filter{ $0.episode.hasPrefix(String(format: "S%02d", forSeason)) }
    }
}

extension EpisodeViewModel {
    
    /**
     Request all episodes.
     - Returns: Array of Episode model struct.
     */
    private func getEpisodes() {
        cancellationToken = RickMortyAPI().getAllEpisodes()
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    self.episodes = $0
                    self.groupEpisodes()
                  })
        
    }
    
    /**
     Performs filter and computes the number of seasons and episodes into array.
     - Returns: Array of Episodes and Seasons info.
     */
    private func groupEpisodes() {
        var seasons = [String]()
        for item in self.episodes {
            seasons.append(String(item.episode.prefix(3)))
        }
        let totalSeasons = Array(Set(seasons))
        
        for i in 1...totalSeasons.count {
            let seasonPrefix = String(format: "S%02d", i)
            let count = self.episodes.filter{ $0.episode.hasPrefix(seasonPrefix) }.count
            seasonsArray.append(count)
        }
    }
    
}


