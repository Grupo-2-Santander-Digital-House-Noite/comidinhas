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


var arrayReviews:[Reviews] = [Reviews(usuario: "Jennifer Aniston", estrelas: "★★★★★", data: "09/19/2020", comentario: "Very tasty"),
                              Reviews(usuario: "Antonio Banderas", estrelas: "★★★★★", data: "11/03/2019", comentario: "Totally recommend. Easy and delicious"),
                              Reviews(usuario: "P!nk", estrelas: "★★★★★", data: "10/22/2019", comentario: "This is a wow cake! My kids loved and now I have to bake it once in a month. I totaly recommend. Well done!!"),
                              Reviews(usuario: "Chris Pratt", estrelas: "★★★★★", data: "08/14/2019", comentario: "Love it"),
                              Reviews(usuario: "Hugh Jackman", estrelas: "★★★★★", data: "05/05/2019", comentario: "Icing is a little bit sweet, but everything else is perfect. Delicious")]





func starAverage() -> Int {
    var arrayStar:[String] = []
    for i in arrayReviews {
        arrayStar.append(i.estrelas)
    }
    
    if arrayStar.count == 0 {
        return 0
    }

    var somaNota:Int = 0
    var nota:Int = 0
    for i in arrayStar {
        if i == "★☆☆☆☆" {
            nota = 1
            somaNota += nota
        } else if i == "★★☆☆☆" {
            nota = 2
            somaNota += nota
        } else if i == "★★★☆☆" {
            nota = 3
            somaNota += nota
        } else if i == "★★★★☆" {
            nota = 4
            somaNota += nota
        } else {
            nota = 5
            somaNota += nota
        }
    }

    var media:Int = somaNota / arrayStar.count
    return media
//    var average: String = ""
//    var media = starAverage()
//    if media == 1 {
//        average = "★☆☆☆☆"
//    } else if media == 2 {
//        average = "★★☆☆☆"
//    } else if media == 3 {
//        average = "★★★☆☆"
//    } else if media == 4 {
//        average = "★★★★☆"
//    } else {
//        average = "★★★★★"
//    }
//    return average
}
