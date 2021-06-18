//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//

import SwiftUI

/**
 CharacterDetailView displays the list of information of character.
 ### Displays
 - **image**: Character Image.
 - **name**: Character name.
 - **status**: Character status (Alive or Dead).
 - **species**:Character speacies (eg. Human)
 - **gender**: Character gender (male or female).
 - **location**: Character location info.
 - **episode**: Number of episode information.
 */
struct CharacterDetailView: View {
    private(set) var character: CharacterModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.gray)
                    .clipShape(Circle())
            }
        }
        Text(character.name)
            .font(.title)
        AsyncImage(url: character.imageURL(),
                   placeholder: {
                    ProgressView()
                   },
                   image: {
                    Image(uiImage: $0)
                        .resizable()
                   }) .cornerRadius(5) .frame(height: 300)
        
        VStack(alignment: .leading) {
            Text(character.status)
                .font(.title)
            HStack {
                Text(character.species)
                Spacer()
                Text(character.gender)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Divider()
            
            Text("Location:")
                .font(.title2)
            Text(character.location.name)
            
            Divider()
            
            Text("Appeared in \(character.episode.count) episodes")
            
        }
        .padding()
    }
}





