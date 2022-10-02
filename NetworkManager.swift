//
//  NetworkManager.swift
//  AppNoticias
//
//  Created by Admin on 24/09/22.
//

// padrao singleton, a propria classe se instancia, usamos a mesma instancia para todas as saidas, quem chamar essa classe vai usar a mesma instancia.
import UIKit
import Foundation

// Criando a classe Network
// criando o enum de erro para conformar com o protocol e para que podemos identificar os tipos de erros.
enum ResultNewsError: Error { //criando o enum error e conformando com o protocol error
    case badURL, noData, invalidJSON // caso o URL for ruin, caso nao tiver dados, caso o JSON seja invalida, dar error
    
}
class NetworkManager { // criando a classe com o padrao singleton, onde ela instamcia ela mesma toda vez que for chamada
    
    static let shared = NetworkManager() // static compartilha o mesmo valor com todas as outras instancias
    
    struct Constants { // constante de API para criar a nossa rota
        static let newsAPI = URL(string: "https://web-ebac-ios.herokuapp.com/home") //usando a API para chamar o nosso URL
    }
    
    private init() { }
    
    func getNews(completion: @escaping (Result<[ResultNews], ResultNewsError>) -> Void) { // void dizendo que nao vamos tonar nenhum tipo especifico // usando o escaping em uma Clousering, para usar o metodo em outro bloco.
        // funcao clousere, usando o escaping e nos retornando um valor valido ou uma falha.
        //Result -> é um enum generic que tem seus dois argumentos, ResultNews e ResultNewsError, utilizando os mesmos após conformar o enum e seu protocol de error
        
            // Setup the url      -- setando a URL
        guard let url = Constants.newsAPI else {
            completion(.failure(.badURL)) // forma da funcao, sempre mapea os erros e mostra aonde eles estao chamando.
            return
        }
        
            // create a configuration
        let configuration = URLSessionConfiguration.default
        
            // create a session
        let session = URLSession(configuration: configuration)
        
            // create the task
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data =
                data else {
                completion(.failure(.invalidJSON))
                return
            }
            // Instrucao DO dentro do escopo
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ResponseElement.self, from: data)
                completion(.success(result.home.results))
            } catch { // Instrucao catch
                print("Error info: \(error.localizedDescription)")
                completion(.failure(.noData))
            }
        }
        
        task.resume()
    }
}
