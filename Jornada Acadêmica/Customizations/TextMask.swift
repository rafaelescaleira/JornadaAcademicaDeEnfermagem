//
//  TextMask.swift
//  siscad
//
//  Created by Rafael Escaleira on 03/03/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import Foundation

public enum MaskType: String {
    
    case CPF = "***.***.***-**"
    case CNPJ = "**.***.***/****-**"
    case birthday = "**/**/****"
    case RGA = "****.****.***-*"
    case PHONE = "(**)*****-****"
}

class InputTextMask {
    
    private static func stringFilterWithCharacter(_ char: Character) -> Bool {
        return char != "." && char != "/" && char != "-" && char != "(" && char != ")"
    }
    
    private static func transformStringToFilteredCharCollection(_ text: String) -> [Character] {
        var filteredText = [Character]()
        
        text.filter { (char) -> Bool in
            InputTextMask.stringFilterWithCharacter(char)
        }.forEach { (char) in
            filteredText.append(char)
        }
        
        return filteredText
    }
    
    private static func transformCharCollectionToString(_ chars: [Character]) -> String {
        var rawString = ""
        
        chars.forEach { (char) in
            rawString += String(char)
        }
        
        return rawString
    }
    
    private static func transformCharCollectionToMaskedString(_ chars: [Character], mask: MaskType) -> String {
        let textLength = chars.count
        var textIndex = 0
        var maskedString = ""
        
        mask.rawValue.forEach { (char) in
            if textIndex < textLength {
                if char == "*" {
                    maskedString += String(chars[textIndex])
                    textIndex += 1
                } else  {
                    maskedString += String(char)
                }
            }
        }
        
        return maskedString
    }
    
    public static func filterMaskFromText(_ text: String) -> String {
        let filteredCharCollection = InputTextMask.transformStringToFilteredCharCollection(text)
        
        return InputTextMask.transformCharCollectionToString(filteredCharCollection)
    }
    
    public static func applyMask(_ mask: MaskType, toText text: String) -> String {
        let filteredCharCollection = InputTextMask.transformStringToFilteredCharCollection(text)
        
        return InputTextMask.transformCharCollectionToMaskedString(filteredCharCollection, mask: mask)
    }
}
