//
//  DBManager.swift
//  WA8_Group19
//
//  Created by Changxu Ren on 11/9/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class DBManager {
    let USER_COLLECTION = "Users"
    
    // A public share dbManager instance
    public static let dbManager = DBManager()
    
    // Maintain a reference to the database
    private let database = Firestore.firestore()

}

// User management
extension DBManager {
    
    
    // Add a new user to the database
    public func addUser(with user: User, completion: @escaping (Bool) -> Void) {
        do {
            try database.collection(USER_COLLECTION).document(user.uid).setData(from: user) { error in
                if let error = error {
                    print("Error: writing user to firestore failed with \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch let error {
            print("Error: writing user to firestore failed with \(error)")
            completion(false)
        }
    }

    // Get profile detail from the database
    public func getUser(withUID uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        database
            .collection(USER_COLLECTION)
            .document(uid)
            .getDocument { (document, error) in
                if let error = error {
                    // If there's an error, pass it to the completion handler
                    completion(.failure(error))
                } else {
                    do {
                        if let user = try document?.data(as: User.self) {
                            // Success, pass the user to the completion handler
                            completion(.success(user))
                        } else {
                            // Document exists but couldn't be parsed into a User
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document is not in the correct format"])
                            completion(.failure(error))
                        }
                    } catch {
                        // If there's an error during the conversion, pass it to the completion handler
                        completion(.failure(error))
                    }
                }
        }
    }
}
