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
                        HStack {
                            Text("Season \(index+1)").font(.headline)
                            Spacer()
                            Text("\(episodeModel.seasonsArray[index]) Episodes") .font(.subheadline)
                        }
                    }
                } .navigationTitle("Rick And Morty")
            } else {
                Text("Error loading Seasons..!").font(.title)
                    .navigationTitle("Rick And Morty")
            }
        }
    }
}


struct SeasonsListView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonsListView()
    }
}
