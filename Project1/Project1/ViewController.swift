//
//  ViewController.swift
//  Project1
//
//  Created by 野中淳 on 2022/11/03.
//

import UIKit

class ViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .plain)
    
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadPicture), with: nil)
        
       
        
        setup()
        style()
        layout()
        
    }
    
    @objc func loadPicture(){
        //ファイルマネージャのインスタンス化
        let fm = FileManager.default
        //main.resourcePathはアプリに追加した全てのリソースを含むディレクトリを示す
        let path = Bundle.main.resourcePath!
        //pathのコンテンツを取得
        let items = try! fm.contentsOfDirectory(atPath: path)
                
        //コンテンツを一つずつ確認
        for item in items{
            if item.hasPrefix("nssl"){
                pictures.append(item)
                print(pictures)
            }
        }
        
        pictures.sort()
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
    }
    
    func setup(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Picture")
        tableView.delegate = self
        tableView.dataSource = self
        
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
}

extension ViewController:UITableViewDelegate{
    
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = pictures[indexPath.row]
        content.textProperties.font = .systemFont(ofSize: 16)
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.selectedImage = pictures[indexPath.row]
        
        vc.selectedImage = "Picture \(pictures.count) of \(indexPath.row + 1)"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
