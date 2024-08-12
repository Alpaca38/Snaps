//
//  ProfileViewModel.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModel {
    private let repository = try? RealmRepository<LikeItems>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let validText = PublishSubject<String>()
        let textValid = BehaviorSubject<Bool>(value: false)
        let mbtiValid = BehaviorSubject<Bool>(value: false)
        let totalValid = BehaviorSubject<Bool>(value: false)
        
        disposeBag.insert {
            input.text
                .bind(with: self) { owner, value in
                    do {
                        _ = try owner.validateProfileName(text: value)
                        validText.onNext(TextFieldState.valid)
                        textValid.onNext(true)
                    } catch NicknameValidationError.includeSpecial {
                        validText.onNext(TextFieldState.specialCharacter)
                        textValid.onNext(false)
                    } catch NicknameValidationError.includeInt {
                        validText.onNext(TextFieldState.number)
                        textValid.onNext(false)
                    } catch NicknameValidationError.isNotValidCount {
                        validText.onNext(TextFieldState.count)
                        textValid.onNext(false)
                    } catch {
                        
                    }
                }
            
            input.mbti
                .bind(with: self) { owner, value in
                    do {
                        _ = try owner.validateMBTI(mbti: value)
                        mbtiValid.onNext(true)
                    } catch MBTIValidationError.isNotValidCount {
                        mbtiValid.onNext(false)
                    } catch {
                        
                    }
                }
            
            Observable.combineLatest(textValid, mbtiValid)
                .map { $0.0 && $0.1 }
                .bind(to: totalValid)
            
            let completeTap = input.completeTap
                .share()
            
            completeTap
                .withLatestFrom(input.text)
                .bind { nickname in
                    UserDefaultsManager.user.nickname = nickname
                }
            
            completeTap
                .withLatestFrom(input.mbti)
                .bind { mbti in
                    UserDefaultsManager.user.mbti = mbti
                }
            
            completeTap
                .withLatestFrom(input.profileImage)
                .bind { image in
                    UserDefaultsManager.user.image = image
                }
            
            completeTap
                .bind { _ in
                    UserDefaultsManager.isLogin = true
                }
            
            let saveTap = input.saveTap
                .share()
            
            saveTap
                .withLatestFrom(input.text)
                .bind { nickname in
                    UserDefaultsManager.user.nickname = nickname
                }
            
            saveTap
                .withLatestFrom(input.mbti)
                .bind { mbti in
                    UserDefaultsManager.user.mbti = mbti
                }
            
            saveTap
                .withLatestFrom(input.profileImage)
                .bind { image in
                    UserDefaultsManager.user.image = image
                }
            
            input.delete
                .bind(with: self) { owner, _ in
                    UserDefaultsManager.isLogin = false
                    UserDefaultsManager.user = User(nickname: "", image: Int.random(in: 0...11), mbti: [])
                    UserDefaultsManager.likeList = []
                    
                    owner.repository?.deleteAll()
                }
        }
        
        return Output(
            validText: validText,
            totalValid: totalValid,
            completeTap: input.completeTap,
            saveTap: input.saveTap,
            withdrawalTap: input.withdrawalTap
        )
    }
}

private extension ProfileViewModel {
    func validateProfileName(text: String) throws -> Bool {
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
    
    func validateMBTI(mbti: [MBTIItem]) throws -> Bool {
        guard mbti.filter({ $0.selected }).count == 4 else {
            throw MBTIValidationError.isNotValidCount
        }
        return true
    }
}

extension ProfileViewModel {
    struct Input {
        let text: ControlProperty<String>
        let mbti: BehaviorRelay<[MBTIItem]>
        let profileImage: PublishRelay<Int>
        let completeTap: ControlEvent<Void>
        let saveTap: ControlEvent<Void>
        let withdrawalTap: ControlEvent<Void>
        let delete: PublishRelay<Void>
    }
    
    struct Output {
        let validText: Observable<String>
        let totalValid: Observable<Bool>
        let completeTap: ControlEvent<Void>
        let saveTap: ControlEvent<Void>
        let withdrawalTap: ControlEvent<Void>
    }
}
