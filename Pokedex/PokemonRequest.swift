//
//  PokemonRequest.swift
//  Pokedex
//
//  Created by Max Ko on 10/16/24.
//

import Foundation
import UIKit

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct PokemonSprites: Codable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonDetails: Codable {
    let sprites: PokemonSprites
}

let INITIAL_URL = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20"


class PokemonRequest {
    var nextURL = URL(string: INITIAL_URL)
    
    func fetchPokemons() async -> (PokemonResponse)? {
        
        guard let url = nextURL else { return nil}
        let request = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedPokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
            
            if let next = decodedPokemonResponse.next {
                nextURL = URL(string: next)
            } else {
                nextURL = nil
            }
            
            return (decodedPokemonResponse)
            
        } catch {
            print("Error Fetching Pokemons: \(error)")
            return nil
        }
                      
    }
    
    // given a pokemon, return the sprite image
    func fetchPokemonSprite(pokemon: Pokemon) async -> (UIImage)? {
        
        print(pokemon)
        
        do {
            // fetch detailed info of the pokemon
            guard let url = URL(string: pokemon.url) else { return nil }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let pokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: data)
            let sprite = pokemonDetails.sprites
            
            // fetch the frontDefault sprite and convert to UIImage, ensure sprite exists
            guard let spriteURL = URL(string: sprite.frontDefault!) else { return nil }
            let (spriteData, _) = try await URLSession.shared.data(from: spriteURL)
            
            if let image = UIImage(data: spriteData) {
                return image
            } else {
                print("Failed to convert data to UIImage")
                return nil
            }
        } catch {
            print("Error fetching image: \(error)")
            return nil
        }
    }
    
}
