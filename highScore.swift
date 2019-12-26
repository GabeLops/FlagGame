//
//  highScore.swift
//  Project2
//
//  Created by Gabriel Lops on 12/26/19.
//  Copyright © 2019 Gabriel Lops. All rights reserved.
//

import UIKit

class highScore: NSCoder, Codable {
    var bestScore: Int
    
    init(bestScore: Int) {
        self.bestScore = bestScore
    }
}
