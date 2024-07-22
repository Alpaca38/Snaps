//
//  ProfileViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation

final class ProfileViewModel {
    private(set) var outputValidText = Observable("")
    private(set) var outputNickname = Observable<String?>(nil)
    private(set) var outputTextValid = Observable(false)
    private(set) var outputImageIndex = Observable<Int?>(nil)
    
    var inputText: Observable<String?> = Observable("")
    var inputValidNickname = Observable<String?>(nil)
    var inputSelectedImageIndex = Observable<Int?>(nil)
    
    init() {
        inputText.bind { [weak self] value in
            guard let self, let text = value?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            do {
                _ = try validateProfileName(text: text)
                outputValidText.value = TextFieldState.valid
                outputTextValid.value = true
            } catch ValidationError.includeSpecial {
                outputValidText.value = TextFieldState.specialCharacter
                outputTextValid.value = false
            } catch ValidationError.includeInt {
                outputValidText.value = TextFieldState.number
                outputTextValid.value = false
            } catch ValidationError.isNotValidCount {
                outputValidText.value = TextFieldState.count
                outputTextValid.value = false
            } catch {
                
            }
        }
        
        inputValidNickname.bind { [weak self] nickname in
            guard let nickname else { return }
            self?.outputNickname.value = nickname
        }
        
        inputSelectedImageIndex.bind { [weak self] index in
            guard let index else { return }
            self?.outputImageIndex.value = index
        }
    }
    
    private func validateProfileName(text: String) throws -> Bool {
        guard !text.contains(where: { "@#$%".contains($0) }) else {
            throw ValidationError.includeSpecial
        }
        guard text.rangeOfCharacter(from: .decimalDigits) == nil else {
            throw ValidationError.includeInt
        }
        guard text.count >= 2 && text.count < 10 else {
            throw ValidationError.isNotValidCount
        }
        return true
    }
}
