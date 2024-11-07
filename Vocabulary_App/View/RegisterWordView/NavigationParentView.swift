//
//  NavigationParentView.swift
//  Vocabulary_App
//
//  Created by Ikufumi Mitsuyu on 7/11/2024.
//

import SwiftUI

struct NavigationParentView: View {
    
    @State private var currentStep: Int = 1
    @State private var newWord: String = ""
    @State private var newWordTranslation: String = ""
    @State private var example: String = ""
    @State private var exampleTranslation: String = ""
    @State private var note: String = ""
 
    var body: some View {
            NavigationStack {
                VStack {
                    if currentStep == 1 {
                        WordInputView(newWord: $newWord, newWordTranslation: $newWordTranslation,currentStep: $currentStep)
                    } else if currentStep == 2 {
                        ExampleInputView(example: $example, exampleTranslation: $exampleTranslation, note: $note, currentStep: $currentStep)
                    } else {
                        ReviewAndAddView(
                            newWord: $newWord,
                            newWordTranslation: $newWordTranslation,
                            example: $example,
                            exampleTranslation: $exampleTranslation,note: $note,
                            currentStep: $currentStep
                        )
                    }
                }
            }
        }
    }

#Preview {
    NavigationParentView()
}
