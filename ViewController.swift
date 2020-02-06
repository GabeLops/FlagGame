//
//  ViewController.swift
//  Project2
//
//  Created by Gabriel Lops on 11/24/19.
//  Copyright © 2019 Gabriel Lops. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    
    
    var countries = [String]()
    var score = 0
    var scores = [highScore]()
    var correctAnswer = 0
    var questionsAnswered = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 2
        button2.layer.borderWidth = 2
        button3.layer.borderWidth = 2
        
        //must use cgColor to convert uicolor
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SCORE", style: .plain, target: self, action: #selector(shareTapped))
        
        let defaults = UserDefaults.standard
        if let savedScore = defaults.object(forKey: "score") as? Data{
            let jsonDecoder = JSONDecoder()
         do {
            scores = try jsonDecoder.decode([highScore].self, from: savedScore)
         } catch {
            print("Its wrong")
            }
        }
        let highScores = highScore(bestScore: 0)
        if scores.isEmpty {
            scores.append(highScores)
        }
        print(highScore)
    }
    
    func askQuestion (action: UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]),
                         for: .normal)
        button2.setImage(UIImage(named: countries[1]),
        for: .normal)
        button3.setImage(UIImage(named: countries[2]),
        for: .normal)
        questionsAnswered += 1
        
        title = countries[correctAnswer].uppercased() + "  Score: \(String(score))"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { finished in
            sender.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        }else {
            title = "Wrong! that is the flag of \(countries[sender.tag].uppercased()) "
            score -= 1
        }
        
        /*
        if score == 5 {
            title = "You Win!"
            let ac = UIAlertController(title: title, message: "You have won the game", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Restart Game?", style: .default, handler: askQuestion))
            present (ac, animated: true)
            score = 0
        }else if score == -5 {
            title = "You Lose"
            
            let ac = UIAlertController(title: title, message: "You have lost the game", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Restart Game?", style: .default, handler: askQuestion))
            present (ac, animated: true)
            score = 0
        
                      
        }else*/ if questionsAnswered == 10 {
            
           
            let highScores = scores[0]
            if score > highScores.bestScore {
                highScores.bestScore = score
                save()
                
                title = "New HighScore!"
                let ac = UIAlertController(title: title, message: "Your final score is \(score)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Restart Game?", style: .default, handler: askQuestion))

                present(ac, animated: true)
                score = 0
                questionsAnswered = 0
            }
            title = "Game will now reset!"
            let ac = UIAlertController(title: title, message: "Your final score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart Game?", style: .default, handler: askQuestion))
            present (ac, animated: true)
            score = 0
            questionsAnswered = 0
        }
        else {
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present (ac, animated: true)
        
    
    
}
}
    @objc func shareTapped() {
    
    let vc = UIAlertController(title: "YOUR CURRENT SCORE IS", message: String(score), preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
    }

    func save() {
        
        let jsonEncoder = JSONEncoder()
        if let savedScore = try? jsonEncoder.encode(scores) {
            let defaults = UserDefaults.standard
            defaults.set(savedScore, forKey: "score")
        }else {
           print("failed to load score")
        }
    }
}

