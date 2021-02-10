//
//  UserManager.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 24/11/20.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

/**
 AppUserManager é responsável por gerenciar os usuários dentro do aplicativo.
 */
class AppUserManager {
    
    public static let userLoggedInNotification: NSNotification.Name = NSNotification.Name("AppUserManagerUserLoggedIn")
    public static let userLoggedOutNotification: NSNotification.Name = NSNotification.Name("AppUserManagerUserLoggedOut")
    
    
    private var currentLoggedUser: User?
    private var auth: Auth
    private var db: Firestore
    
    // MARK: Singleton Methods
    static var shared: AppUserManager {
        let instance = AppUserManager()
        return instance
    }
    
    private init() {
        self.currentLoggedUser = nil
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
    }
    
    // MARK: UserManagement Methods and Properties
    
    /**
     O usuário logado se houver.
     
     Esta é uma propriedade readonly, para garantir que usuários só possam realizar o login
     usando o método **attemptLoginWith**
     */
    public var loggedUser: User? {
        get {
            if let _user = self.auth.currentUser,
               let _email = _user.email {
                return User(name: _user.displayName ?? "No Name!", email: _email, uid: _user.uid)
            }
            return nil
        }
    }
    
    // MARK: MÉTODOS
    
    // MARK: hasLoggedUser
    /**
     Verifica se há um usuário logado.
     
     - Returns: true se tiver, false caso contrário
     */
    public func hasLoggedUser() -> Bool {
        return self.auth.currentUser != nil
    }
    
    
    // MARK: logout
    /**
     Desloga usuário logado na aplicação.
     */
    public func logout(completion: (() -> Void)?, failure: ((Error) -> Void)?) -> Void {
        do {
            try self.auth.signOut()
            if let _completion = completion {
                NotificationCenter.default.post(name: AppUserManager.userLoggedOutNotification, object: nil)
                _completion()
            }
        } catch {
            if let _failure = failure {
                _failure(AuthError.userAuthenticationError(localizedMessage: error.localizedDescription))
            }
        }
        
    }
    
    
    // MARK: attemptLoginWith
    /**
     Tenta logar o usuário, caso consiga invoca o completion handler, caso não consiga invoca o failure handler.
     - Parameters:
       - email: Endereço de e-mail do usuário
       - usingPassword: Senha do usuário
       - completion: Closure invocada em caso de sucesso!
       - failure: Closure invocada em caso de falha!
       - reason: mensagem de erro passada.
     */
    public func attemptLoginWith(email: String, usingPassword password: String, completion: (() -> Void)?, failure: ((_ reason: Error) -> Void)?) -> Void {
        // Tenta fazer login no firebase, pode usar outro objeto para se comunicar
        // com o firebase.
        
        // Em caso de sucesso deve:
        // - Definir o self.currentLoggedUser para uma instância de User
        //   com os dados do usuário logado.
        // - Invocar o closure completion, caso tenha sido passado.
        
        // Em caso de falha deve:
        // - Invocar o closure failure, passando a razão pelo qual falhou
        //   (ex. Sem conexão com a internet, ou falha na autenticação)
        //
        //   Por motivos de segurança é importante não diferenciar entre
        //   o usuário não existe e o usuário e senha estão incorretos,
        //   visto que se alguém tentar força bruta (sim eu sei, é um
        //   telefone) e a gente diferenciar o hacker poderia saber quais
        //   usuários existem e focar os esforços neste usuário.
        
        // Tenta autenticar o usuário usando um e-mail e senha
        self.auth.signIn(withEmail: email, password: password) { (result, error) in
            
            // Em caso de erro chama o closure de erro.
            if let _error = error,
               let _failure = failure {
                _failure(AuthError.userAuthenticationError(localizedMessage: _error.localizedDescription))
                return
            }
            
            // Em caso de sucesso chama o closure de sucesso.
            if let _ = result,
               let _completion = completion{
                NotificationCenter.default.post(name: AppUserManager.userLoggedInNotification, object: result?.user.uid)
                _completion()
            }
        }
    }
    
    
    // MARK: updateLoggedUserFullname
    /**
     Atualiza fullname do usuário logado.
     */
    func updateLoggedUserFullname(name:String, completion:(() -> Void)?, failure: ((Error) -> Void)?){
        // Faz um alias para o failure
        let reportError = {(error:Error) -> Void in
            if let _failure = failure {
                _failure(AuthError.userUpdateError(localizedMessage: error.localizedDescription))
            }
        }
        // Verifica se há um usuário logado para atualizar e-mail.
        guard let currentUser = self.auth.currentUser else { reportError(AuthError.userUpdateError(localizedMessage: "Não há um usuário logado!")); return }
        // Tenta atualizar o nome do usuário
        if let _user = self.auth.currentUser?.createProfileChangeRequest() {
            _user.displayName = name
            _user.commitChanges { (error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
            }
        }
        db.collection("users").document(auth.currentUser?.uid ?? "").setData(["fullname":name, "uid":auth.currentUser?.uid ?? ""], merge: true)
        if let _completion = completion {
            _completion()
        }
    }
    
    
    // MARK: updateUserLoggedEmailByKaren
    /**
     Atualiza o email do usuário logado
     */
    func updateUserLoggedEmail(email:String, password:String, completion:(() -> Void)?, failure:((Error) -> Void)?) {
        // Faz um alias para o failure
        let reportError = { (error: Error) -> Void in
            if let _failure = failure {
                _failure(AuthError.userUpdateError(localizedMessage: error.localizedDescription))
            }
        }
            
        var credentials: AuthCredential = EmailAuthProvider.credential(withEmail: Auth.auth().currentUser?.email ?? "", password: password ?? "")
        
        Auth.auth().currentUser?.reauthenticate(with: credentials, completion: { (result, error) in
            
            if let error = error {
                reportError(error)
                return
            }
            
            Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
                if error != nil {
                    reportError(AuthError.userUpdateError(localizedMessage: "Couldn't update email"))
                    return
                }
                Auth.auth().currentUser?.reload(completion: { (error) in
                    if error != nil {
                        reportError(AuthError.userUpdateError(localizedMessage: "Couldn't reload user"))
                        return
                    }
                })
                if let _completion = completion {
                    _completion()
                }
            })
        })
    }
    
    
    // MARK: updateUserLoggedPassword
    /**
     Atuliza o password do usuário logado
     */
    func updateUserLoggedPassword(currentPassword:String, newPassword:String, completion:(() -> Void)?, failure:((Error) -> Void)?) {
        // Faz um alias para o failure
        let reportError = { (error: Error) -> Void in
            if let _failure = failure {
                _failure(AuthError.userUpdateError(localizedMessage: error.localizedDescription))
            }
        }
        
        var credentials: AuthCredential = EmailAuthProvider.credential(withEmail: auth.currentUser?.email ?? "", password: currentPassword)
        self.auth.currentUser?.reauthenticate(with: credentials, completion: { (result, error) in
            if error != nil {
                reportError(AuthError.userUpdateError(localizedMessage: "Wrong password"))
                return
            }
            self.auth.currentUser?.updatePassword(to: newPassword, completion: { (error) in
                if error != nil {
                    reportError(AuthError.userUpdateError(localizedMessage: "Couldn't update password"))
                    return
                }
                self.auth.currentUser?.reload(completion: { (error) in
                    if error != nil {
                        reportError(AuthError.userUpdateError(localizedMessage: "Couldnt'reload user"))
                        return
                    }
                })
                if let _completion = completion {
                    _completion()
                }
            })
        })
    }

    
    // MARK: resetPassword
    /**
     Manda email para o usuário logado redefinir senha
     */
    func resetPassword(email:String, completion:(() -> Void)?, failure:((Error) -> Void)?) {
        // Faz um alias para o failure
        let reportError = { (error: Error) -> Void in
            if let _failure = failure {
                _failure(AuthError.userUpdateError(localizedMessage: error.localizedDescription))
            }
        }
        
        self.auth.fetchSignInMethods(forEmail: email) { (arrayEmail, error) in
            if error != nil {
                reportError(AuthError.userUpdateError(localizedMessage: "Invalid email"))
            } else {
                self.auth.sendPasswordReset(withEmail: email) { (error) in
                    if error != nil {
                        reportError(AuthError.userUpdateError(localizedMessage: "Counld't send email to reset password"))
                        return
                    }
                    if let _complition = completion {
                        _complition()
                    }
                }
            }
        }
    }

    
    // MARK: create
    /**
     Tenta criar um novo usuário
     - Parameters:
       - user: Modelo do usuário a ser criado.
       - andPassword: Senha do usuário.
       - completion: Closure invocada quando criação ocorrer.
       - failure: Closure invocada em caso de erro da criação.
       - reason: Razão do erro passada para a closure de falha.
     */
    public func create(user: User, withPassword password: String, completion: ( () -> Void )?, failure: ( ((_ reason: Error) -> Void)? )) {
        // Tenta atualizar criar um usuário persistindo os dados no firebase,
        // podendo usar para isso usa um objeto que faz a comunicação com o firebase.
        
        // Em caso de sucesso (onde sucesso é o firebase confirmar a criação)
        // este método deve:
        // - Atualizar o modelo do usuário logado (self.currentLoggedUser).
        // - Invocar o closure completion.
        
        // Em caso de falha (devido a falha de comunicação ou o usuário já existir)
        // este método deve:
        // - Invocar o método failure, passando um Error como razão da falha.
        
        // Faz um alias para o failure
        let reportError = { (error: Error) -> Void in
            if let _failure = failure {
                _failure(AuthError.userUpdateError(localizedMessage: error.localizedDescription))
            }
        }
        
        // Tenta criar um usuário no Firebase
        self.auth.createUser(withEmail: user.email ?? "", password: password) { (result, error) in
            // Caso tenha ocorrido um erro, invoca o failure passando a mensagem de erro.
            if let _error = error {
                reportError(AuthError.userCreationError(localizedMessage: _error.localizedDescription))
                return
            }
            
            // Tenta desempacotar o usuário logado para atualizar o nome de exibição.
            // Caso não consiga dispara um erro de usuário não autenticado.
            guard let currentUser = self.auth.currentUser else {
                reportError(AuthError.userCreationError(localizedMessage: "Usuário não autenticado!"))
                return
            }
            // Inicia a atualização do nome do usuário.
            let request = currentUser.createProfileChangeRequest()
            request.displayName = user.name
            request.commitChanges { (error) in
                if let _error = error {
                    reportError(AuthError.userCreationError(localizedMessage: _error.localizedDescription))
                    return
                }
                
                NotificationCenter.default.post(name: AppUserManager.userLoggedInNotification, object: result?.user.uid)
                // Tenta armazenar os dados do usuário
                // Passa adiante os handlers de completion e failure.
                self.storeUseInFireStore(user: currentUser, completion: completion, failure: failure)
            }
        }
    }
    
    
    // MARK: storeUseInFireStore
    /**
     Este método armazena informações do usuário no FireStore.
     Pode ser usado tanto na criação quanto na atualização.
     */
    private func storeUseInFireStore(user: Firebase.User, completion: ( () -> Void )?, failure: ( (_ reason: Error) -> Void )?) {
        
        self.db
            .collection("users")
            .document(user.uid).setData([
                "fullname" : user.displayName ?? "No Name!",
                "uid" : user.uid
            ]) { (error) in
            if let _error = error {
                if let _failure = failure {
                    _failure(AuthError.userCreationError(localizedMessage: _error.localizedDescription))
                }
                return
            }
            if let _completion = completion {
                _completion()
            }
        }
    }
}
