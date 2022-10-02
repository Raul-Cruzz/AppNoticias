//
//  NewYorkTableViewCell.swift
//  AppNoticias
//
//  Created by Admin on 07/08/22.
//

import UIKit

class NewYorkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var by: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //inicializando o codigo
        
        imageNews.layer.cornerRadius = 10 // arredonda a borda
        imageNews.layer.borderWidth = 1 // coloca a borda
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // criando um metodo e recebendo o newa da outra classe
    func prepare(with news: NewsData) { //Lincando as IB
        title.text = news.title
        by.text = news.byline
        
        guard let url = URL(string: news.image) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.imageNews.image = UIImage(data: data)
            }
            
        }.resume()
    }
    
}
