import UIKit


struct Person: Decodable {
    var name: String
    var films: [URL]
}

struct Film: Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/" )
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        guard let baseURL = baseURL else { return completion(nil) }
        
        let personURL = baseURL.appendingPathComponent("people/\(id)")
        //        print(personURL) //https://swapi.dev/api/people
        URLSession.shared.dataTask(with: personURL) { (data, _, error) in
            
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)//return out of the function
            }
            guard let data = data else { return completion(nil) }
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
            }
        }.resume()
        print("<<<<<<<<<<<<<<")
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
     
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            // 2 - Handle errors
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
            }
            // 3 - Check for data
            guard let data = data else { return completion(nil) }
            
            // 4 Decode Film from JSON
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
                
            } catch {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(nil)
            }
        }.resume()
    }
}


func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film.title)
        }
    }
}

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person.name)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}
