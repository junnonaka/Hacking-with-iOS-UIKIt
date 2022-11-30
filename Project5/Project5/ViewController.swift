//
//  ViewController.swift
//  Project5
//
//  Created by 野中淳 on 2022/11/15.
//

import UIKit

class ViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .plain)
    
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(restart))
        
        tableView.dataSource = self
        tableView.delegate = self
        //navigationController?.navigationBar.prefersLargeTitles = true

        //start.txtからテキストを取得する
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty{
            allWords = ["silkworm"]
        }
        
        startGame()
        setup()
        style()
        layout()
    }

    func startGame(){
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    
    func setup(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Word")
        tableView.separatorStyle = .singleLine
    }
    
    func style(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    func layout(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    //addボタンを押した時
    @objc func promptForAnswer(){
        //Controllerの作成
        let ac = UIAlertController(title: "Enter anser", message: nil, preferredStyle: .alert)
        //TextFieldを追加
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            //Submitボタンを押した時の処理：クロージャ
            //弱参照でパラメータを渡す。クロージャはそれらを使用可能だが、所有していないことを意味する
            //selfは現在のViewControllerのこと。acは上記で定義しているUIAlertController
            [weak self,weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            //ViewControllerのメソッドを呼び出している
            self?.submit(answer)
        }
        //actionを追加
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    func submit(_ answer:String){
        let lowerAnswer = answer.lowercased()
        
        let errorTitle:String
        let errorMessage:String
        if isWrongFirst(word: lowerAnswer){
            if isBiggerThan3(word: lowerAnswer){
                if isPossible(word: lowerAnswer){
                    if isOriginal(word: lowerAnswer){
                        if isReal(word: lowerAnswer){
                            usedWords.insert(answer, at: 0)
                            let indexPath = IndexPath(row: 0, section: 0)
                            tableView.insertRows(at: [indexPath], with: .automatic)
                            return
                        }else{
                            errorTitle = "Word not recognized"
                            errorMessage = "You can't just make them up, you know"
                        }
                    }else{
                        errorTitle = "Word already use"
                        errorMessage = "Be more 0riginal"
                        
                    }
                }else{
                    errorTitle = "Word not possible"
                    errorMessage = "You can't spell that word from \(title!.lowercased())"
                    
                }
            }else{
                errorTitle = "Word not possible"
                errorMessage = "short than 3"
                
            }
        }else{
            errorTitle = "Word not possible"
            errorMessage = "First Character is same"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    func isPossible(word:String) -> Bool{
        guard var tempWord = title?.lowercased() else {return false}
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            }else{
                return false
            }
        }
        return true
    }
    
    func isOriginal(word:String)->Bool{
        
        return !usedWords.contains(word)
    }
    
    func isReal(word:String)->Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isBiggerThan3(word:String)->Bool{
        return word.count < 4 ? false : true
    }
    
    func isWrongFirst(word:String)->Bool{
        return word.prefix(1) != title?.lowercased().prefix(1) ? true : false
    }
    
    @objc func restart(){
        startGame()
    }
    
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = usedWords[indexPath.row]
        //content.textProperties.font = .systemFont(ofSize: 16)
        cell.contentConfiguration = content
        //cell.accessoryType = .disclosureIndicator

        return cell
    }
}
extension ViewController:UITableViewDelegate{
    
}
