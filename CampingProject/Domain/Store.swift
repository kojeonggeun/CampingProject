//
//  UserModel.swift
//  CampingProject
//
//  Created by 고정근 on 2021/07/29.
//

import Foundation
import Alamofire
import RxSwift


// TODO: Domain 별로 나눠야 함
public class Store {
    static let shared = Store()
    let api = APIManager.shared

    func loginRx(email: String, password: String) -> Observable<Bool> {
        return Observable.create { emitter in
            self.api.login(email: email, password: password) { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
            }
            return Disposables.create()
        }
    }

    func loadUserInfoRx() -> Observable<UserInfo> {
        return Observable.create { emitter in
            self.api.loadUserInfo { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func loadFriendInfoRx(userId: Int) -> Observable<UserInfo> {
        return Observable.create { emitter in
            self.api.loadFriendInfo(friendId: userId) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    func passwordCertificationRx(password: String) -> Observable<Bool> {
        return Observable.create { emitter in
            self.api.passwordCertification(password: password) { result in
                    emitter.onNext(result)
                    emitter.onCompleted()
            }
            return Disposables.create()
        }
    }

    func loadUserGearRx() -> Observable<[CellData]> {
        return Observable.create { emitter in
            self.api.loadUserGear { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    func loadDetailUserGearRx(userId: Int, gearId: Int) -> Observable<GearDetail> {
        return Observable.create { emitter in
            self.api.loadDetailUserGear(userId: userId, gearId: gearId) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func loadFollowerRx(searchText: String = "", page: Int = 0) -> Observable<Friends> {
        return Observable.create { emitter in
            self.api.loadFollower(searchText: searchText, page: page) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func loadFollowingRx(searchText: String = "", page: Int = 0) -> Observable<Friends> {
        return Observable.create { emitter in
            self.api.loadFollowing(searchText: searchText, page: page) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    func followRequstRx(id: Int) -> Observable<Bool> {
        return Observable.create { emitter in
            self.api.followRequst(id: id) { result in
                emitter.onNext(result)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    func deleteFollowerRx(id: Int) -> Observable<Bool> {
        return Observable.create { emitter in
            self.api.deleteFollower(id: id) { result in
                emitter.onNext(result)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    

    func loadSearchUserGearRx(userId: Int) -> Observable<[CellData]> {
        return Observable.create { emitter in
            self.api.loadSearchUserGear(id: userId) { result in
                emitter.onNext(result)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }

    func searchUserRx(searchText: String, page: Int = 0) -> Observable<SearchResult> {
        return Observable.create { emitter in
            self.api.searchUser(searchText: searchText, page: page) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    func emailDuplicateCheckRx(email: String) -> Observable<Bool> {
        return Observable.create { emitter in
            self.api.checkEmailDuplicate(email: email) { result in
                emitter.onNext(result)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }

    func requestEmailCertificationCodeRx(email: String) -> Observable<Bool> {
        return Observable.create { emitter in
            self.api.requestEmailCertificationCode(email: email,type: emailType.REGISTER) { result in
                emitter.onNext(result)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }

}
