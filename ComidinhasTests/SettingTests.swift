//
//  SettingTests.swift
//  ComidinhasTests
//
//  Created by Cátia Souza on 26/01/21.
//

import Quick
import Nimble
@testable import Comidinhas

class SettingTest: QuickSpec {
    let isValidEmails = Settings()
    let sut = SettingsVC()
    
    override func spec(){
        describe("Settings"){
            context("Is Valid Email"){
                it("Valid Email"){
                    let validEmail = self.isValidEmails.isValidEmail(email: "comidinhas@gmail.com")
                    expect(validEmail).to(be(true))
                }
                it("Invalid Email"){
                    let validEmail = self.isValidEmails.isValidEmail(email: "comidinha.br")
                    expect(validEmail).to(be(false))
                    
                }
            }
            context("Is valid password"){
                it("Valid Password"){
                    let validPassword = self.isValidEmails.isPasswordValid(password: "123456C@a")
                    expect(validPassword).to(be(true))
                }
                it("Invalid password"){
                    let validEmail = self.isValidEmails.isPasswordValid(password: "12345")
                    expect(validEmail).to(be(false))
                   
                    
                }
            }
        }
    }
}
