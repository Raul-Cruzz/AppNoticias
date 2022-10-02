//
//  ViewController.swift
//  AppNoticias
//
//  Created by Admin on 10/07/22.
//

import UIKit

class MainTableViewController: UITableViewController { // -> Utilizando esse UI por ser completo e trazendo para nós todos os metodos que já tem em outras UI, tanto a Delegate quanto a DataSource.
    
    //var items: Array = ["EBAC 1", "EBAC 2", "EBAC 3", "EBAC 4", "EBAC 5"] // -> Array conjunto de caracteres
    
    var newsData = [NewsData]()// Populando a tableview através da codificacao do json
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator()
        
        NetworkManager.shared.getNews { [weak self] result  in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                for item in response {
                    if let imageURL = item.media.first?.mediaMetadata.last?.url {
                        let data = NewsData(title: item.title, byline: item.byline, image: imageURL, url: item.url)
                        self.newsData.append(data)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.hideActivityIndicator()
                }
            case .failure(let error):
                print("error: \(error)")
                self.hideActivityIndicator()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count => \(newsData.count)")
        
        return newsData.count // -> contando os 4 index com os seus 5 elementos.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // -> Utilizando o type casting para saber o tipo de metodo.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewYorkTableViewCell // realizando o typecasting e dizendo o tipo da cell
        
        let data = newsData[indexPath.row]
        cell.prepare(with: data)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: newsData[indexPath.row].url){ // acrescentando url na nossa imagem
            UIApplication.shared.open(url)
        }
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        guard let activityView = activityView else {
            return
        }
        
        self.view.addSubview(activityView) // addview coloca subview da propria tableview
        
        activityView.translatesAutoresizingMaskIntoConstraints = false //constraints nao aceitam optional por isso colocar fals
        
        NSLayoutConstraint.activate([ // forma manual de se colocar as constraints e ativar as mesmas direto com código.
            activityView.widthAnchor.constraint(equalToConstant: 70),
            activityView.heightAnchor.constraint(equalToConstant: 70),
            activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        activityView.startAnimating() //startando o UIActivity
        
    }
    
    func hideActivityIndicator() {
        guard let activityView = activityView else {
            return
        }
        
        activityView.stopAnimating()
    }
    
}

