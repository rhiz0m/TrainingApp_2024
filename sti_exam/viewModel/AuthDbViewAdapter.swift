//
//  TestAuth.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-26.
import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class AuthDbViewAdapter: ObservableObject {
    @Published var currentUserData: UserData?
    @Published var emailInput = ""
    @Published var confirmEmail = ""
    @Published var passwordInput = ""
    @Published var confirmPassword = ""
    @Published var currentUser: User?
    @Published var selectedExerciseID: UUID?
    @Published var selectedExercise: UsersExcercise?
    @Published var usersExercises: [UsersExcercise] = []
    @Published var usersTrainingRecord: UsersTrainingRecord?
    @Published var exerciseName = ""
    @Published var date = ""
    @Published var type = ""
    @Published var muscleGroups = ""
    @Published var weight = ""
    @Published var reps = 0
    @Published var sets = 0
    @Published var title = ""
    @Published var dateString: String = ""
    @Published var description = ""
    @Published var name = ""
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private let USER_DATA_COLLECTION = "user_data"
    private let USER_EXERCISES = "usersExercises"
    private var dbListener: ListenerRegistration?
    
    init() {
        auth.addStateDidChangeListener { auth, user in
            if let user = user {
                print("A user has been logged in \(user.email ?? "No Email")")
                self.currentUser = user
                self.startListeningToDb()
                
            } else {
                self.dbListener?.remove()
                self.dbListener = nil
                self.currentUserData = nil
                self.currentUser = nil
                print("A user has logged out")
            }
        }
    }
    
    // DB
    
    func startListeningToDb() {
        guard let user = currentUser else { return }
        
        let documentPath = "\(USER_DATA_COLLECTION)/\(user.uid)"
        print("Listening to Firestore document: \(documentPath)")
        print("Document path: \(documentPath)")
        
        dbListener = db.collection(self.USER_DATA_COLLECTION).document(user.uid).addSnapshotListener { snapshot, error in
            
            if let error = error {
                print("Error occurred: \(error.localizedDescription)")
                return
            }
            
            guard let documentSnapshot = snapshot else { return }
            
            let result = Result {
                try documentSnapshot.data(as: UserData.self)
            }
            
            switch result {
            case .success(let userData):
                self.currentUserData = userData
                
                self.usersExercises = userData.usersExercises
            case .failure(let error):
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
    }
    
    func clearFeilds() {
        exerciseName = ""
        date = ""
        muscleGroups = ""
        weight = ""
        reps = 0
        sets = 0
        title = ""
        dateString = ""
        description = ""
        name = ""
        usersExercises = []
    }
    
    func saveProgramToDb(userExercise: UsersExcercise) {
        if let currentUser = currentUser {
            do {
                let documentRef = db.collection(USER_DATA_COLLECTION).document(currentUser.uid)
                
                documentRef.getDocument { (document, error) in
                    do {
                        if let document = document, document.exists {
                            try documentRef.updateData([
                                self.USER_EXERCISES: FieldValue.arrayUnion([try Firestore.Encoder().encode(userExercise)])
                            ]) { error in
                                if let error = error {
                                    print("Error updating Firestore: \(error.localizedDescription)")
                                } else {
                                    print("Exercise added successfully!")
                                }
                            }
                        } else {
                            try documentRef.setData([
                                self.USER_EXERCISES: [try Firestore.Encoder().encode(userExercise)]
                            ]) { error in
                                if let error = error {
                                    print("Error creating Firestore document: \(error.localizedDescription)")
                                } else {
                                    print("Document created successfully!")
                                }
                            }
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteProgram(exercise: UsersExcercise) {
        if let currentUser = currentUser {
            do {
                var currentPrograms = currentUserData?.usersExercises ?? []
                currentPrograms.removeAll { $0.id == exercise.id }
                try db.collection(USER_DATA_COLLECTION)
                    .document(currentUser.uid)
                    .updateData([
                        USER_EXERCISES: try currentPrograms.map { try Firestore.Encoder().encode($0) }
                    ])
                print("Exercise deleted")
            } catch {
                print("Error updating Firestore: \(error.localizedDescription)")
            }
        }
    }
    
    // Auth
    func registerUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            
            if authResult != nil {
                completion(true)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print("Error logging in:", error.localizedDescription)
                completion(false)
            } else {
                print("You are logged in!")
                completion(true)
            }
        }
    }
    
    func logout() {
        do {
            emailInput = ""
            passwordInput = ""
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("Error logout: \(error.localizedDescription)")
        }
    }
}
