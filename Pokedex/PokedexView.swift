//
//  ContentView.swift
//  Pokedex
//
//  Created by Max Ko on 10/16/24.
//

import SwiftUI

struct PokedexView: View {
    
    @State var pokemonSprites: [UIImage] = []
    @State var selectedPokemonSprite: UIImage?
    @State var loadingImage: Bool = false
    
    var pokemonRequest = PokemonRequest()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    let placeholderImage: UIImage = UIImage(systemName: "xmark.circle")!
    
    var body: some View {
        VStack {
            Image(uiImage: selectedPokemonSprite ?? placeholderImage)
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 250)
                .background(Color(.black))
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach (pokemonSprites, id: \.self) {sprite in
                        Image(uiImage: sprite)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .onTapGesture {
                                selectedPokemonSprite = sprite
                            }
                    }
                    
                    if !loadingImage {
                        Color.clear
                            .onAppear {
                                Task {
                                    await loadPokemons()
                                }
                            }
                    }

                }
                
                if loadingImage {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            
            }
        }
    }
    
    func loadPokemons() async {
        loadingImage = true
        if let pokemonResponse = await pokemonRequest.fetchPokemons()
        {
            let pokemons = pokemonResponse.results
            
            for pokemon in pokemons {
                if let sprite = await pokemonRequest.fetchPokemonSprite(pokemon: pokemon) {
                    pokemonSprites.append(sprite)
                }
            }
            if (selectedPokemonSprite == nil) {
                selectedPokemonSprite = pokemonSprites.first
            }
        }
        loadingImage = false
    }
}

#Preview {
    PokedexView()
}
