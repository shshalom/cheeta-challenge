//
//  UIImageView+Cache.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImage(urlString: String) {
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            
            guard let data = data else { return }
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: urlString as AnyObject)
            
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
