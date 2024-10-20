# Pokedex

## Milestone 1: Basic Pokedex

To fetch the sprite of each pokemon to display, the following requests are required:
1. Fetch a list of pokemons.
2, Fetch detailed information for each pokemon.
3. Fetch the sprite for each pokemon.

Thus `PokemonRequest` is split into 2 main functions: 
- [fetchPokemons]: fetches the list of pokemons
- [fetchPokemonSprite]: returns the sprite of the pokemon as an UIImage
This allows us to expand the pokedex app in the future, where we can create other functions to display additional information.

The `PokemonRequest` also keeps a `nextURL` to account for pagination.

The UI is presented in a LazyGridView to help with performance. Users do not need to have all sprites rendered, only the visible sprites should be rendered.

## Milestone 2: Pagination

Since `PokemonRequest` keeps a `nextURL`, we just need to  call the function once the user reaches to the end of the scrollView. To detect this, a invisible view was created, and set to fetch more pokemon sprite onAppear. One main thing to note is that, the invisible view should be unrendered as we are fetching, this prevents accidently overfetching, and also ensures the onAppear work as intended.

## Milestone 3: Caching

`NSCache` was used to perform image caching. Most of the API calls came from fetching the image data, thus caching the image will reduce the latency when loading each sprite. As each pokemon name is unique, the name is used as the key for the cache. Moreover, since fetching the list of pokemon will also return the name of the pokemon, we can easily check whether the pokemon sprite exist in the cache. Using the pokemon number was another potential idea, however, for readability, it was decided to use the name for the the key when designing the cache.

Below is a demo of the Pokedex App:
