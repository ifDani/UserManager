import Foundation

var getAllUsers: [User] {
      let defaultObject = User(email: "default", password: "123")
      if let objects = UserDefaults.standard.value(forKey: "users") as? Data {
         let decoder = JSONDecoder()
         if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [User] {
            return objectsDecoded
         } else {
            return [defaultObject]
         }
      } else {
         return [defaultObject]
      }
   }

func saveAllUsers(allObjects: [User]) {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(allObjects){
         UserDefaults.standard.set(encoded, forKey: "users")
      }
 }
