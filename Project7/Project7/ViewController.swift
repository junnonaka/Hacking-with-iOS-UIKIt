//
//  ViewController.swift
//  Project7
//
//  Created by 野中淳 on 2022/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    
    var petitions = [Petition]()
    var serchResult = [Petition]()
    var urlString:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

        if navigationController?.tabBarItem.tag == 0{
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                perse(json: data)
            }else{
                showError()
            }
        }else{
            showError()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .checkmark, style: .plain, target: self, action: #selector(credit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .actions, style: .plain, target: self, action: #selector(filter))
        
        setup()
        style()
        layout()
    }

    func setup(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }
    
    @objc func credit(){
        let ac = UIAlertController(title: "Credit", message: urlString, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filter(){
        
        var inputTextField:UITextField?
        let ac = UIAlertController(title: "Filter", message: "input filter message", preferredStyle: .alert)
        ac.addTextField { textField in
            inputTextField = textField
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            if let text = inputTextField?.text {
                self.serchResult = self.petitions.filter({ petition in
                    return petition.title.contains(text)
                })
                self.petitions = self.serchResult
                self.tableView.reloadData()
            }
        }))
        
        present(ac, animated: true)
    }
    
    func perse(json:Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac,animated: true)
    }
}
extension ViewController:UITableViewDelegate{
    
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        let petition = petitions[indexPath.row]
        configuration.text = petition.title
        //configuration.secondaryText = petition.body
        //configuration.
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
