//
//  ViewController.swift
//  Project8
//
//  Created by 野中淳 on 2022/11/27.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel:UILabel!
    var ansersLabel:UILabel!
    var currentAnswer:UITextField!
    var scoreLabel:UILabel!
    var letterButtons = [UIButton]()
    
    var submit:UIButton!
    var clear:UIButton!
    
    var buttonsView:UIView!
    
    var activatedBUttons = [UIButton]()
    var solutions = [String]()
    
    var score = 0{
        didSet{
            scoreLabel.text = "Score:\(score)"
        }
    }
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
        loadLevel()

    }
    @objc func letterTapped(_ sender:UIButton){
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedBUttons.append(sender)
        sender.isHidden = true
    }
    
    @objc func submitTapped(_ sender:UIButton){
        guard let anserText = currentAnswer.text else {return}
        
        if let solutionPosition = solutions.firstIndex(of: anserText){
            activatedBUttons.removeAll()
            
            var splitAnswers = ansersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = anserText
            ansersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            if score % 7 == 0{
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                            present(ac, animated: true)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender:UIButton){
        currentAnswer.text = ""
        
        for btn in activatedBUttons{
            btn.isHidden = false
        }
        
        activatedBUttons.removeAll()

    }
    
    
    
    func setup(){
        scoreLabel = UILabel()
        cluesLabel = UILabel()
        ansersLabel = UILabel()
        currentAnswer = UITextField()
        buttonsView = UIView()
        
        submit = UIButton(type: .system)
        clear = UIButton(type: .system)
    }
    
    func style(){
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score:0"
        
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = .systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.backgroundColor = .red
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        ansersLabel.translatesAutoresizingMaskIntoConstraints = false
        ansersLabel.font = .systemFont(ofSize: 24)
        ansersLabel.text = "ANSWERS"
        ansersLabel.numberOfLines = 0
        ansersLabel.textAlignment = .right
        ansersLabel.backgroundColor = .blue
        ansersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = .systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for(index,line)in lines.enumerated(){
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        ansersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

        letterBits.shuffle()

        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
                letterButtons[i].layer.borderWidth = 1
                letterButtons[i].layer.borderColor = UIColor.gray.cgColor
            }
        }
        
    }
    
    func layout(){
        view.addSubview(scoreLabel)
        view.addSubview(cluesLabel)
        view.addSubview(ansersLabel)
        view.addSubview(currentAnswer)
        view.addSubview(submit)
        view.addSubview(clear)
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo:view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6,constant: -100),
            
            
            ansersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            ansersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -100),
            ansersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4,constant: -100),
            ansersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo:submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant:750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            
        ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = .systemFont(ofSize: 36)
                
                letterButton.setTitle("WWW", for: .normal)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
            }
        }
    }
}

#if canImport(SwiftUI) && DEBUG
//SwiftUIのViewでViewControllerをラップしている
import SwiftUI
struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    
    let viewController: ViewController
    
    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }
    
    // MARK: - UIViewControllerRepresentable
    //初期化メソッド
    func makeUIViewController(context: Context) -> ViewController {
        //ViewControllerを返す
        viewController
    }
    // SwiftUI側から更新がかかったときに呼ばれるメソッド
    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
        return
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
import SwiftUI
//Previewで使うデバイスを複数出す時に便利
//これを使わなくても.previewDeviceを外せばSimulaterで選んだデバイスで実行される
//let deviceNames: [String] = [
//    "iPhone SE",
//    "iPhone 11 Pro Max",
//    "iPad Pro (11-inch)"
//]

@available(iOS 13.0, *)
//Previewを表示するためのプロトコル
//Previewで指定したViewをCanvasでプレビュー表示する
//XCodeが勝手に検知してくれる
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        //ForEach(deviceNames, id: \.self) { deviceName in
        UIViewControllerPreview {
            ViewController()
        }
        //.previewDevice(PreviewDevice(rawValue: deviceName))
        //        .previewDisplayName(deviceName)
        //    }
    }
}
#endif
