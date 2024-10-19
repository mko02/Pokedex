//
//  PokemonCache.swift
//  Pokedex
//
//  Created by Max Ko on 10/19/24.
//

import UIKit

class PokemonCache {
    private let cache = NSCache<NSString, UIImage>()
    
    func getSprite(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func cacheSprite(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
