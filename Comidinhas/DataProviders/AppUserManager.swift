//
//  UserManager.swift
//  Comidinhas
//
//  Created by Rafael Nascimento Sampaio on 24/11/20.
//

import Foundation

var userLoggedIn = false  // Criei essa variável para dizer se o usuario está logado ou não

/**
 AppUserManager é responsável por gerenciar os usuários dentro do aplicativo.
 */
class AppUserManager {
    
    private var currentLoggedUser: User?
    
    // MARK: Singleton Methods
    static var shared: AppUserManager {
        let instance = AppUserManager()
        return instance
    }
    
    private init() {
        self.currentLoggedUser = nil
    }
    
    // MARK: UserManagement Methods and Properties
    
    /**
     O usuário logado se houver.
     
     Esta é uma propriedade readonly, para garantir que usuários só possam realizar o login
     usando o método **attemptLoginWith**
     */
    public var loggedUser: User? {
        get {
            return self.currentLoggedUser
        }
    }
    
    /**
     Verifica se há um usuário logado.
     
     - Returns: true se tiver, false caso contrário
     */
    public func hasLoggedUser() -> Bool {
        return self.currentLoggedUser != nil
    }
    
    /**
     Desloga usuário logado na aplicação.
     */
    public func logout() -> Void {
        self.currentLoggedUser = nil
    }
    
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
    }
    
    /**
     Tenta atualizar o usuário logado usando um modelo de usuário e a senha atual do usuário
     - Parameters:
       - user: Modelo do usuário com novas informações (nome e e-mail).
       - andPassword: Senha atual do usuário, necessária para confirmar a atualização, caso esteja incorreta a atualização não deve ser feita.
       - completion: Closure invocada quando a atualização ocorrer.
       - failure: Closure invocada em caso de erro da atualização.
       - reason: Razão do erro passada para a closure de falha.
     */
    public func attemptUpdateLoggedUserWith(user: User, andPassword password: String, completion: ( () -> Void )?, failure: ( (_ reason: Error) -> Void? )) {
        // Tenta atualizar usuário logado persistindo dados no firebase,
        // para isso usa um objeto que faz a comunicação com o firebase.
        
        // Em caso de sucesso (onde sucesso é a senha bater e o firebase persistir
        // as novas informações) este método deve:
        // - Atualizar o modelo do usuário logado (self.currentLoggedUser).
        // - Invocar o closure completion.
        
        // Em caso de falha (seja porque a senha do usuário não bateu, ou
        // por falha na comunicação com o firebase) este método deve:
        // - Invocar o método failure, passando um Error como razão da falha.
    }
    
    /**
     Tenta atualizar o usuário mudando a senha do usuário.
     - Parameters:
       - user: Modelo do usuário com novas informações (nome e e-mail).
       - andPassword: Senha atual do usuário, necessária para confirmar a atualização, caso esteja incorreta a atualização não deve ser feita.
       - settingNewPassWordTo: nova senha do usuário
       - completion: Closure invocada quando a atualização ocorrer.
       - failure: Closure invocada em caso de erro da atualização.
       - reason: Razão do erro passada para a closure de falha.
     */
    public func attemptUpdateLoggedUserWith(user: User, andPassword password: String, settingNewPassWordTo newPassword: String, completion: ( () -> Void )?, failure: ( (_ reason: Error) -> Void? )) {
        // Tenta atualizar usuário logado persistindo dados no firebase,
        // para isso usa um objeto que faz a comunicação com o firebase.
        
        // Em caso de sucesso (onde sucesso é a senha bater e o firebase persistir
        // as novas informações) este método deve:
        // - Atualizar o modelo do usuário logado (self.currentLoggedUser).
        // - Invocar o closure completion.
        
        // Em caso de falha (seja porque a senha do usuário não bateu, ou
        // por falha na comunicação com o firebase) este método deve:
        // - Invocar o método failure, passando um Error como razão da falha.
    }
    
    /**
     Tenta criar um novo usuário
     - Parameters:
       - user: Modelo do usuário a ser criado.
       - andPassword: Senha do usuário.
       - completion: Closure invocada quando criação ocorrer.
       - failure: Closure invocada em caso de erro da criação.
       - reason: Razão do erro passada para a closure de falha.
     */
    public func create(user: User, withPassword password: String, completion: ( () -> Void )?, failure: ( (_ reason: Error) -> Void? )) {
        // Tenta atualizar criar um usuário persistindo os dados no firebase,
        // podendo usar para isso usa um objeto que faz a comunicação com o firebase.
        
        // Em caso de sucesso (onde sucesso é o firebase confirmar a criação)
        // este método deve:
        // - Atualizar o modelo do usuário logado (self.currentLoggedUser).
        // - Invocar o closure completion.
        
        // Em caso de falha (devido a falha de comunicação ou o usuário já existir)
        // este método deve:
        // - Invocar o método failure, passando um Error como razão da falha.
    }
}
