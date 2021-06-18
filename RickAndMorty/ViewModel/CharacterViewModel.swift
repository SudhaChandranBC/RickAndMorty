//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//
import Foundation
import Combine

/**
 CharacterViewModel struct for Character List View.
 ### Properties
 - **characters**: Array of CharacterModel struct.
 
 ### SeeAlso
 - **RickMortyAPI**: RickMortyAPI struct in RickMortyAPI.swift.
 - **CharacterModel**: CharacterModel struct in CharacterModel.swift.
 */
class CharacterViewModel: ObservableObject {
    @Published private(set) var characters: [CharacterModel] = []
    private(set) var cancellationToken: AnyCancellable?
    
    init() {
        getCharacters()
    }
    
}


extension CharacterViewModel {
    
    /**
     Request all characters.
     - Returns: Array of Character model struct.
     */
    private func getCharacters() {
        cancellationToken = RickMortyAPI().getAllCharacters()
            .mapError({ (error) -> Error in
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                    self.characters = $0
                  })
    }
    
}
