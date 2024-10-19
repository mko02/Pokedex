//
//  ContentView.swift
//  Pokedex
//
//  Created by Max Ko on 10/16/24.
//

import SwiftUI

struct ContentView: View {
    
    var pokemonRequest = PokemonRequest()
    @State var pokemonSprites: [UIImage] = []

    var body: some View {
        VStack {
            ScrollView {
                ForEach (pokemonSprites, id: \.self) {sprite in
                    Image(uiImage: sprite)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
            }
            .onAppear {
                Task {
                    await loadPokemons()
                }
            }
            
        }
    }
    
    func loadPokemons() async {
        if let pokemonResponse = await pokemonRequest.fetchPokemons()
        {
            var pokemons = pokemonResponse.results
                    
            for pokemon in pokemons {
                if let sprite = await pokemonRequest.fetchPokemonSprite(pokemon: pokemon) {
                    pokemonSprites.append(sprite)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
