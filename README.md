# CampingProject
## 캠토리지(2022.03 중 앱스토어 배포 예정)
- 개인이 가진 캠핑 장비를 목록화하여 관리하고 친구들과 서로의 장비 목록을 공유 할 수 있는 앱
<img width="1253" alt="스크린샷 2022-03-14 오후 1 33 39" src="https://user-images.githubusercontent.com/21233207/158111082-5e5825a3-784b-4b7f-a20f-52a079d37aaa.png">

**개발 환경**

Swift

**사용 라이브러리**
<pre><code># Pods for CampingProject
 pod 'Alamofire', '~> 5.2'
 pod "BSImagePicker", "~> 3.1"
 pod 'TextFieldEffects'
 pod 'RxSwift'
 pod 'RxCocoa'
 pod 'Kingfisher'</code></pre>

**상세 기능**
1. **로그인 & 회원가입**
<img width="733" alt="image" src="https://user-images.githubusercontent.com/21233207/159848768-23732c86-a96d-4cc4-84ea-a3a9bc6db6d1.png">

- 이메일 인증을 통해 이메일 중복을 확인 합니다.
- 인증을 완료하면 닉네임과 비밀번호를 입력 하면 회원 가입 완료

2. **장비 저장 & 수정 & 삭제**
<img width="726" alt="image" src="https://user-images.githubusercontent.com/21233207/159848959-70e4b2db-9f27-4210-9841-242901d420f9.png">

- 등록한 장비를 리스트화 하여 볼 수 있습니다.
- 카테고리 별로 장비를 볼 수 있습니다
- 간단하게 장비를 등록 할 수 있습니다.
- 장비 등록 시 최대 5장 이미지를 저장 할 수 있습니다.
- 장비 등록 후 간편하게 수정 & 삭제 할 수 있습니다.

3. **사용자 검색 & 사용자 장비 보기**
<img width="773" alt="image" src="https://user-images.githubusercontent.com/21233207/159849207-362e8361-17a1-4a36-8518-e797ae204359.png">

- 다른 사용자를 검색 할 수 있습니다.
- 검색 한 사용자의 장비를 구경 해보세요

4. **프로필 관리 & 계정관리**
<img width="757" alt="image" src="https://user-images.githubusercontent.com/21233207/159849388-697cffeb-a22d-40a3-a185-7c384e1018f8.png">

- 나를 소개하는 프로필을 작성 할 수 있습니다.
- 비밀번호 변경 & 회원 탈퇴 기능 제공
- 회원 탈퇴 시 개인정보는 영구 삭제


**개인정보 처리방침**
https://github.com/kojeonggeun/CamtoragePrivacyPolicy
