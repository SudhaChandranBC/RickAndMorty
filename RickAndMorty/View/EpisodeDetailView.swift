//
//  EpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//

import SwiftUI

/**
 EpisodeDetailView displays the list of information of Episode.
 */
struct EpisodeDetailView: View {
    @State private var selectedCharacter: CharacterModel? = nil
    private(set) var episode: EpisodeModel
    private(set) var chars: [CharacterModel]
    
    var body: some View {
        EpisodeHeader(episode: episode)
        
        if episode.characters.count > 0 {
            List {
                ForEach(episode.characters, id: \.self) { characterURL in
                    let charId = Int(characterURL.components(separatedBy: "/").last!)
                    if let char = chars.first(where: {$0.id == charId}) {
                        CharacterRow(character: char) .onTapGesture {
                            self.selectedCharacter = char
                        }
                    }
                }
            } .sheet(item: self.$selectedCharacter) { car in
                CharacterDetailView(character: car)
            }
            .navigationTitle(episode.episodeNumber())
            .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("Error loading Characters..!").font(.largeTitle)
        }
        
    }
}

/**
 EpisodeHeader displays episode information.
 ### Displays
 - **name**: Episode name
 - **seasonNumber**: Season number.
 - **episodeNumber**: Episode number.
 - **airDate**: Air date.
 */
struct EpisodeHeader: View {
    var episode: EpisodeModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(episode.name)
                .font(.title)
            HStack {
                Text(episode.seasonNumber())
                    .font(.headline)
                Text(episode.episodeNumber())
                    .font(.headline)
            }
            HStack {
                Text("Streamed on: \(episode.airDate)")
            }
            .font(.subheadline)
            Divider()
            
            Text("Includes \(episode.characters.count) Characters")
                .font(.title2)
        }
        .padding()
    }
}

/**
 CharacterRow displays episode information.
 ### Displays
 - **image**: Character Image.
 - **name**: Character name.
 - **status**: Character status (Alive or Dead).
 - **episode**: Number of episode information.
 */
struct CharacterRow: View {
    
    var character: CharacterModel
    
    var body: some View {
        HStack {
            AsyncImage(url: character.imageURL(),
                       placeholder: {
                        ProgressView()
                       },
                       image: {
                        Image(uiImage: $0).resizable()
                       }).frame(width: 80, height: 80)
                .cornerRadius(5)
            VStack(alignment: .leading) {
                Text(character.name).font(.headline)
                Text(character.status).font(.subheadline)
                Text("Appeared in \(character.episode.count) episodes").font(.footnote)
            }
        }.cornerRadius(5)
    }
}

