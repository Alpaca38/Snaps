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
    private(set) var outputMBTIValid = Observable(false)
    private(set) var outputTotalValid = Observable(false)
    private(set) var outputMBTI = Observable<[MBTIItem]?>(nil)
    private(set) var outputSaveImageIndex = Observable<Int?>(nil)
    
    var inputText: Observable<String?> = Observable("")
    var inputValidNickname = Observable<String?>(nil)
    var inputSelectedImageIndex = Observable<Int?>(nil)
    var inputMBTI = Observable<[MBTIItem]?>(nil)
    var inputValidMBTI = Observable<[MBTIItem]?>(nil)
    var inputSaveImage = Observable<Int?>(nil)
    
    init() {
        inputText.bind { [weak self] value in
            guard let self, let text = value?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            do {
                _ = try validateProfileName(text: text)
                outputValidText.value = TextFieldState.valid
                outputTextValid.value = true
            } catch NicknameValidationError.includeSpecial {
                outputValidText.value = TextFieldState.specialCharacter
                outputTextValid.value = false
            } catch NicknameValidationError.includeInt {
                outputValidText.value = TextFieldState.number
                outputTextValid.value = false
            } catch NicknameValidationError.isNotValidCount {
                outputValidText.value = TextFieldState.count
                outputTextValid.value = false
            } catch {
                
            }
            updateTotalValid()
        }
        
        inputValidNickname.bind { [weak self] nickname in
            guard let nickname else { return }
            self?.outputNickname.value = nickname
        }
        
        inputSelectedImageIndex.bind { [weak self] index in
            guard let index else { return }
            self?.outputImageIndex.value = index
        }
        
        inputMBTI.bind { [weak self] mbti in
            guard let mbti ,let self else { return }
            do {
                _ = try validateMBTI(mbti: mbti)
                outputMBTIValid.value = true
            } catch MBTIValidationError.isNotValidCount {
                outputMBTIValid.value = false
            } catch {
                
            }
            updateTotalValid()
        }
        
        inputValidMBTI.bind { [weak self] mbti in
            guard let mbti else { return }
            self?.outputMBTI.value = mbti
        }
        
        inputSaveImage.bind { [weak self] index in
            guard let index else { return }
            self?.outputSaveImageIndex.value = index
        }
    }
    
    private func validateProfileName(text: String) throws -> Bool {
        guard !text.contains(where: { "@#$%".contains($0) }) else {
            throw NicknameValidationError.includeSpecial
        }
        guard text.rangeOfCharacter(from: .decimalDigits) == nil else {
            throw NicknameValidationError.includeInt
        }
        guard text.count >= 2 && text.count < 10 else {
            throw NicknameValidationError.isNotValidCount
        }
        return true
    }
    
    private func validateMBTI(mbti: [MBTIItem]) throws -> Bool {
        guard mbti.filter({ $0.selected }).count == 4 else {
            throw MBTIValidationError.isNotValidCount
        }
        return true
    }
    
    private func updateTotalValid() {
        outputTotalValid.value = outputTextValid.value && outputMBTIValid.value
    }
}
