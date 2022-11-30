//
//  ViewController.swift
//  Project2
//
//  Created by 野中淳 on 2022/11/09.
//

import UIKit

class ViewController: UIViewController {

    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    //let scoreLabel = UILabel()
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var answerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
        
        setup()
        style()
        layout()
    }

    
    func setup(){

        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        button1.tag = 0
        button2.tag = 1
        button3.tag = 2

        button1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button3.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        //button1.setImage(UIImage(named: "us"), for: .normal)

        //button2.setImage(UIImage(named: "us"), for: .normal)

        //button3.setImage(UIImage(named: "us"), for: .normal)
        
    }

    func style(){
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.backgroundColor = .red
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false

        //scoreLabel.translatesAutoresizingMaskIntoConstraints
    }
    
    func layout(){
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "0", style: .plain, target: self, action: nil)

        NSLayoutConstraint.activate([
            
            button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.heightAnchor.constraint(equalTo: button2.heightAnchor),
            button1.heightAnchor.constraint(equalTo: button1.widthAnchor, multiplier: 1.0/2.0),

            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 50),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button2.heightAnchor.constraint(equalTo: button3.heightAnchor),
            button2.heightAnchor.constraint(equalTo: button2.widthAnchor, multiplier: 1.0/2.0),


            
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 50),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            
            button3.heightAnchor.constraint(equalTo: button3.widthAnchor, multiplier: 1.0/2.0),

            
            
        ])
    }
    
    func askQuestion(action:UIAlertAction! = nil){
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        //button1.imageView?.contentMode = .scaleToFill
        //button1.imageView?.image = UIImage(named: countries[0])

        button2.setImage(UIImage(named: countries[1]), for: .normal)

        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
        
        navigationItem.leftBarButtonItem?.title = "\(score)"
    }
    
    @objc func buttonTapped(_ sender:UIButton){
        var title:String
        
        if sender.tag == correctAnswer{
            title = "Correct"
            score += 1
        }else{
            title = "Wrong Correct Answer is \(countries[correctAnswer])"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default,handler: askQuestion))
        
        present(ac, animated: true)
    }
    
}

