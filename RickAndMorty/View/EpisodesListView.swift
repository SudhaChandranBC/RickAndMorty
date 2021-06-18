//
//  EpisodesListView.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//

import Foundation
import SwiftUI

/**
 EpisodesListView displays the list of episodes of the selected season.
 */
struct EpisodesListView: View {
    @ObservedObject var episodeModel = EpisodeViewModel()
    var seasonSelected: Int
    
    var body: some View {
        let episodes = filterEpisodesForSeason()
        List(episodes) { episode in
            NavigationLink(destination: EpisodeDetailView(episode: episode, chars: episodeModel.characterModel.characters)) {
                VStack(alignment: .leading) {
                    EpisodesRow(episode: episode)
                }
            }
        }
        .navigationTitle("Season \(seasonSelected)")
    }
    
    /**
     Perform filtering the episodes of the selected season from all episodes array.
     - Returns: Filtered array of episodes for selected season.
     */
    func filterEpisodesForSeason() -> [EpisodeModel] {
        let seasonPrefix = String(format: "S%02d", seasonSelected)
        let array = episodeModel.episodes.filter{ $0.episode.hasPrefix(seasonPrefix) }
        return array
    }
}


/**
 Displays episode information.
 ### Displays
 - **name**: Episode name
 - **seasonNumber**: Season number.
 - **episodeNumber**: Episode number.
 - **airDate**: Air date.
 */
struct EpisodesRow: View {
    var episode: EpisodeModel
    
    var body: some View {
        Text(episode.name)
            .font(.headline)
        HStack {
            Text(episode.seasonNumber())
                .font(.subheadline)
            Text(episode.episodeNumber())
                .font(.subheadline)
        }
        Text(episode.airDate)
            .font(.footnote)
    }
}

struct SeasonsList_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesListView(seasonSelected: 1)
    }
}
