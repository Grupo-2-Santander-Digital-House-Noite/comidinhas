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

var arrayReviews:[Reviews] = []
var arrayStar:[String] = []

func starAverage(arrayStarFirestore:[String]) -> Int {
    if arrayStarFirestore.count == 0 {
        return 0
    }

    var somaNota:Int = 0
    var nota:Int = 0
    
    for i in arrayStarFirestore {
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
        } else if i == "★★★★★" {
            nota = 5
            somaNota += nota
        } else if i == "☆☆☆☆☆" {
            nota = 0
            somaNota += nota
        }
    }

    let media:Int = somaNota / arrayStarFirestore.count
    return media
}
