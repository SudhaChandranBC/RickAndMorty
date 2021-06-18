//
//  SeasonsListView.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//

import Foundation
import SwiftUI

/**
 SeasonsListView displays the list of seasons and number of episodes information.
 */
struct SeasonsListView: View {
    @ObservedObject var episodeModel = EpisodeViewModel()
    
    var body: some View {
        NavigationView {
            if (episodeModel.seasonsArray.count > 0) {
                List(episodeModel.seasonsArray.indices, id: \.self) { index in
                    NavigationLink(destination: EpisodesListView(seasonSelected: index+1)) {
                        SeasonRow(season: index+1, episodes: episodeModel.seasonsArray[index])
                    }
                } .navigationTitle("Rick And Morty")
            } else {
                Text("Error loading Seasons..!").font(.title)
                .navigationTitle("Rick And Morty")
            }
        }
    }
}

/**
 Displays season and episode information.
 ### Displays
 - **season**: Season name
 - **episodes**: number of episodes.
 */
struct SeasonRow: View {
    var season: Int
    var episodes: Int

    var body: some View {
        HStack {
            Text("Season \(season)").font(.headline)
            Spacer()
            Text("\(episodes) Episodes") .font(.subheadline)
        }
    }
}

struct SeasonsListView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonsListView()
    }
}
