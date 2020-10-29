//
//  Reviews.swift
//  Comidinhas
//
//  Created by Fabio Makihara on 29/10/20.
//

import Foundation


struct Reviews {
    var usuario:String
    var estrelas:String
    var data:String
    var comentario:String?
}



var arrayReviews:[Reviews] = [Reviews(usuario: "Jennifer Aniston", estrelas: "★★★★☆", data: "09/19/2020", comentario: "Very tasty"),
                              Reviews(usuario: "Antonio Banderas", estrelas: "★★★★★", data: "11/03/2019", comentario: "Totally recommend. Easy and delicious"),
                              Reviews(usuario: "P!nk", estrelas: "★★★★★", data: "10/22/2019", comentario: "This is a wow cake! My kids loved and now I have to bake it once in a month. I totaly recommend. Well done!!"),
                              Reviews(usuario: "Chris Pratt", estrelas: "★★★★★", data: "08/14/2019", comentario: "Love it"),
                              Reviews(usuario: "Hugh Jackman", estrelas: "★★★★☆", data: "05/05/2019", comentario: "Icing is a little bit sweet, but everything else is perfect. Delicious")]
