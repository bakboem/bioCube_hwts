/*
 * Filename: /Users/bakbeom/work/truepass/lib/view/terms/terms_of_privacy_policy.dart
 * Path: /Users/bakbeom
 * Created Date: Friday, January 27th 2023, 10:58:01 pm
 * Author: bakbeom
 * 
 * Copyright (c) 2023 BioCube
 */

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hwst/styles/export_common.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/widget_of_table_box.dart';
import 'package:hwst/view/common/widget_of_default_spacing.dart';
import 'package:hwst/view/common/widget_of_appbar_contents.dart';

class TermsOfPrivacyPolicy extends StatelessWidget {
  const TermsOfPrivacyPolicy({Key? key}) : super(key: key);
  static final String routeName = '/TermsOfPrivacyPolicy';
  @override
  Widget build(BuildContext context) {
    const articleOverviewText = '''
Updated:
Nov. 9, 2022
㈜ 아이디테크(이하 ‘회사’라 한다)는 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「개인정보보호법」, 「GDPR」을 준수하기 위하여 노력하고 있으며, 이용자의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보처리방침을 수립·공개합니다.
제1조. 수집하는 개인정보의 항목 및 수집방법
제2조. 개인정보의 수집 및 이용목적
제3조. 개인정보의 보유 및 이용기간
제4조. 개인정보의 제3자 제공
제5조. 개인정보처리 위탁 및 국외이전
제6조. 정보주체의 권리·의무 및 행사방법
제7조. 개인정보 자동 수집 장치의 설치·운영 및 거부
제8조. 개인정보의 파기절차 및 방법
제9조. 개인정보의 안전성 확보조치
제10조. 개인정보보호책임자 및 담당자 연락처
제11조. 개인정보처리방침 변경 및 고지의 의무

''';
    const articleOneText = '''

1) 수집항목
회사는 아래와 같은 개인정보를 수집하고 있습니다

''';
    const articleOne_TwoText = '''

2) 수집방법
회사는 다음의 방법으로 개인정보를 수집합니다:
- 홈페이지를 통한 이용자가 직접 정보를 입력
- 이벤트 발생시 위치정보
''';

    const articleTwoText = '''

회사는 개인정보를 다음의 목적을 위하여 수집·이용합니다. 수집한 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우 사전동의를 구하는 등 법령상 필요한 조치를 이행할 것입니다.

''';
    const articleThreeText = '''

관계법령의 규정에 의하여 개인정보를 보존할 필요가 없는 한 원칙적으로, 회사는 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다.
개인정보 수집시 이용자로부터 직접 동의를 받은 경우에는 동의한 기간동안 보유합니다.
동의를 철회하고자 하는경우에는 홈페이지에서 직접 탈퇴하거나 개인정보보호 담당부서(privacy@idteck.com)로 요청하시면 본인확인 후 즉시 처리합니다.

''';

    const articleThree_TwoText = '''

단, 관계법령의 규정에 의하여 보존할 필요가 있는 경우, 회사는 아래와 같이 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다.

''';
    const articleFourText = '''

회사는 이용자의 동의가 있거나 관련 법령 등에 의해 제공이 요구되는 경우를 제외하고는 어떠한 경우에도 이용자의 개인정보를 이용하거나 제3자에게 제공하지 않습니다.

''';
    const articleFiveText = '''

회사는 원활한 정보 제공, 서비스의 안정성과 최신 기술의 제공 등을 위해 다음과 같이 클라우드 서비스를 이용  합니다. 클라우드 서비스의 기술적.관리적 보호조치는 클라우드 사업자의 정책을 따릅니다. 클라우드 사업자는 물리적인 관리만을 행하고, 이용자의 데이터에는 접근하지 않습니다.

''';
    const articleFive_TwoText = '''

회사는 사업자가 위탁업무 목적 외 개인정보 처리 금지, 기술적∙관리적 보호조치 준수, 그 외 개인정보 관계 법
령을 위반하지 않도록 관리‧감독하고 있습니다.
위탁업무의 내용이나 수탁자가 변경될 경우에는 지체없이 본 개인정보처리방침을 통하여 공개할 것입니다.
''';
    const articleSixText = '''

1) 이용자는 회사에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.
• 개인정보 열람요구
• 오류 등이 있을 경우 정정 요구
• 삭제 요구
• 처리정지 요구
• 반대권
2) 제1항에 따른 권리 행사는 회사에 대해 서면, 전화, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며, 회사는 본인 확인 절차를 거친 후 이에 대해 지체 없이 조치하겠습니다.
3) 회사는 원칙적으로 16세 미만의 정보주체에 대한 개인정보를 수집하지 않습니다.


''';
    const articleSevenText = '''

회사는 쿠키와 유사한 기술인 세션 및 로컬 스토리지 기술을 사용합니다. 해당 스토리지에는 로그인 하였을 때 이용자의 PC에 저장되는 작은 텍스트 파일입니다. 이 텍스트 파일은 사이트를 재 방문했을 때 웹 사이트가 읽을 수 있는 정보를 저장합니다.
회사는 세션 및 로컬 스토리지를 아래와 같이 이용합니다.
• 이용자가 서비스를 이용 시 이용자의 세션을 유지하기 위해서
• 이용자의 서비스 이용 시 향상된 편의성을 제공하기 위해서

세션 및 로컬 스토리지에 저장되는 정보는 다음과 같습니다.
• 세션 유지를 위한 토큰 정보
• 이용자가 선택 시 간편 로그인을 위한 이용자 ID

이용자는 서비스를 계속하여 사용함으로써 회사가 본 개인정보처리방침에 따라 쿠키와 유사한 기술을 사용하는 것에 동의합니다.
1. 회사는 이용자에게 보다 적절하고 유용한 서비스를 제공하기 위하여 웹사이트 접속과 동시에 쿠키(Cookie)를 사용합니다.
2. 쿠키란 회사의 사이트 접속 시 자동으로 회원의 컴퓨터로 전송되는 텍스트 파일을 말합니다.
① 회원은 쿠키 사용여부를 선택할 수 있습니다.
② 쿠키 설정 거부방법

※ 쿠키 설정방법 예
1. Internet Explorer : 웹 브라우저 상단의 도구 → 인터넷 옵션 → 개인정보 → 고급
2. Chrome : 웹 브라우저 우측의 설정 메뉴 → 화면 하단의 고급 설정 표시 → 개인정보의 콘텐츠 설정 버튼 → 쿠키
대부분의 인터넷 브라우저는 이용자가 직접 쿠키 수용 여부를 선택할 수 있습니다. 그러나 이용자가 만약 쿠키를 사용하지 않도록 설정하거나 쿠키의 기능을 제한하도록 설정하는 경우, 웹사이트의 편리한 기능을 사용할 수 없을 수 있으며 이로 인하여 이용자의 전체적인 사용자 경험을 제한할 가능성이 있습니다.

Google Analytics에 관한 안내
1. 회사는 고객에게 더 나은 서비스를 제공하기 위한 목적으로 Google, Inc. (이하 'Google')이 제공하는 웹 분석 서비스인 Google Analytics를 사용하여 고객들이 회사의 서비스를 어떻게 이용하는지 분석 및 평가하고 고객의 수요를 파악하며, 서비스와 제품을 개선하고 맞춤화하여 효율적인 서비스를 제공하는 것에 목적이 있습니다.
2. Google Analytics는 의 컴퓨터에 저장되는 텍스트 파일인 "쿠키"를 사용하여 사용자의 웹사이트 이용 방식을 분석합니다.
3. Google은 쿠키를 통하여 수집된 이러한 정보를 미국에 소재한 Google 서버로 이전되어 저장됩니다.
4. Google은 이 정보를 법률에 의하여 요구되는 경우 제3자에게 제공하거나, Google을 대신해서 해당 정보를 처리하는 제 3자에게 제공할 수 있습니다.
5. Google은 고객의 IP주소를 Google이 보유한 다른 어떠한 데이터와도 연관 짓지 않습니다.
6. 고객은 별도로 Google 쿠키 이용을 거부하지 않는 한, 회사의 서비스를 이용함으로써 Google 쿠키 및 Google Analytics를 통하여 생성된 모든 정보의 이용에 동의하게 됩니다.
7. Google의 개인정보보호에 관한 내용은 여기에서 확인하실 수 있습니다.
8. Google Analytics 이용 거부 방법을 확인하려면 Google 사이트를 통하여 제한하거나 모든 쿠키의 저장을 거부할 수 있습니다. 단, 쿠키의 저장을 거부할 경우에는 로그인이 필요한 일부 서비스의 이용에 제한이 생길 수 있으며 이에 대한 책임은 전적으로 이용자 본인에게 있음을 유의하시기 바랍니다.

''';
    const articleEightText = '''

회사는 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.
1) 파기절차
이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우를 제외하고 다른 목적으로 이용되지 않습니다.
2) 파기방법
전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다. 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.

''';
    const articleNineText = '''

회사는 다음과 같이 안전성 확보에 필요한 기술적, 관리적, 물리적 조치를 하고 있습니다.
1) 관리적 조치
정보보안 규정·지침 및 개인정보 내부관리계획 수립, 준수, 점검, 교육 등
2) 기술적 조치
개인정보처리시스템 등의 접근권한 관리/인증, 접근통제시스템 및 보안프로그램의 설치/운영, 개인정보 암호화, 암호화 전송 등
3) 물리적 조치
전산실 출입통제 수립/운영 등


''';
    const articleTenText = '''

회사는 이용자의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 개인정보관리책임자 및 관련 부서를 지정하고 있으며 개인정보보호책임자는 DPO(Data Protection Officer)의 역할을 수행합니다.
1) 개인정보보호 최고 책임자
• 성명 : 안상현/아이디테크
• 직책 : 대표이사
• 연락처 : 02-2659-0055 / support@idteck.com
2) 개인정보보호 담당부서
• 부서 : 아이디테크
• 문의처 : support@idteck.com
이용자는 회사의 서비스(또는 사업)를 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서에 문의하실 수 있습니다. 회사는 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.
기타 개인정보침해에 대한 신고 또는 상담이 필요하신 경우에는 아래 기관으로 의하시기 바랍니다.
• 개인정보침해신고센터 (privacy.kisa.or.kr / (국번없이)118)
• 대검찰청 사이버수사과 (www.spo.go.kr / (국번없이)1301)
• 경찰청 사이버안전국 (www.police.go.kr / (국번없이)182)
• 개인정보 분쟁조정위원회 (www.kopico.go.kr / 1833-6972)

''';
    const articleElevenText = '''

개인정보처리방침의 내용 추가, 삭제 및 수정이 있을 시에는 개정 최소 7일 전부터 홈페이지의 ‘공지사항’을 통해 고지할 것입니다.
개인정보 수집 및 활용, 제3자 제공 등과 같이 이용자 권리의 중요한 변경이 있을 경우에는 최소 30일 전에 고지합니다.
1) 공고일자 : 2022년 11월 09일
2) 시행일자 : 2022년 11월 16일 


''';

    const titleOne = '제 1조. 수집하는 개인정보의 항목';
    const titleTwo = '제2조. 개인정보의 수집 및 이용목적';
    const titleThree = '제 3조. 개인정보의 보유 및 이용기간';
    const titleFour = '제 4조. 개인정보의 제3자 제공';
    const titleFive = '제 5조. 개인정보처리 위탁 및 국외이전';
    const titleSix = '제 6조. 정보주체의 권리·의무 및 행사방법';
    const titleSeven = '제7조. 개인정보 자동 수집 장치의 설치·운영 및 거부';
    const titleEight = '제 8조. 개인정보의 파기 절차 및 방법';
    const titleNine = '제 9조. 개인정보의 안전성 확보조치';
    const titleTen = '제 10조. 개인정보보호 책임자 및 담당부서 연락처';
    const titleEleven = '제 11조. 개인정보처리방침 변경 및 고지의 의무';

    Widget _buildTermsOverview() {
      return AppText.text(articleOverviewText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleOne() {
      return AppText.text(articleOneText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleTwo() {
      return AppText.text(articleTwoText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleThree() {
      return AppText.text(articleThreeText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleFour() {
      return AppText.text(articleFourText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleFive() {
      return AppText.text(articleFiveText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleSix() {
      return AppText.text(articleSixText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleSeven() {
      return AppText.text(articleSevenText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleEight() {
      return AppText.text(articleEightText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleNine() {
      return AppText.text(articleNineText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleTen() {
      return AppText.text(articleTenText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleEleven() {
      return AppText.text(articleElevenText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsTitle(String title) {
      return AppText.text(title,
          style: AppTextStyle.bold_20, textAlign: TextAlign.left, maxLines: 2);
    }

    Widget _buildTable(
        {required List<List<String>> columnText,
        required bool isbody,
        bool? isNotCenterAlin}) {
      return Table(
        border: TableBorder.all(
            color: AppColors.unReadyButtonBorderColor, width: .4),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {0: FlexColumnWidth(.3), 1: FlexColumnWidth(.7)},
        children: [
          ...columnText.asMap().entries.map((map) => TableRow(
                children: [
                  ...map.value.asMap().entries.map((m) => buildTableBox(
                      context, m.value, m.key,
                      isBody: isbody,
                      alignmentt: m.key == 0 && isNotCenterAlin == null
                          ? Alignment.center
                          : null))
                ],
              ))
        ],
      );
    }

    Widget _buildArticleOneTable() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.text('<홈페이지에서 수집하는 정보 >', textAlign: TextAlign.left),
          defaultSpacing(),
          _buildTable(columnText: [
            ['구분', '수집항목']
          ], isbody: false),
          _buildTable(columnText: [
            ['회원가입', '필수항목 : 이메일, 패스워드, 전화번호, 국가, 이름, 사이트 명칭(별칭)']
          ], isbody: true),
          defaultSpacing(multiple: 2),
          AppText.text('<앱에서 수집하는 정보 >', textAlign: TextAlign.left),
          defaultSpacing(),
          _buildTable(columnText: [
            ['구분', '수집항목']
          ], isbody: false),
          _buildTable(columnText: [
            ['모바일 카드 발급', '필수항목 : OS 버전, 기기이름, DB테이블을 보고 더 추가한다. ']
          ], isbody: true),
          defaultSpacing(multiple: 2),
          AppText.text('<앱에서 사용하는 정보 >', textAlign: TextAlign.left),
          defaultSpacing(),
          _buildTable(columnText: [
            ['구분', '수집항목'],
          ], isbody: false),
          _buildTable(columnText: [
            ['카드정보', '필수항목 : 이름, 모바일 카드 정보, 이용자가 등록한 정보(부서, 회사이름)'],
            ['장치정보', '선택항목 : 장치 ID, 모델, GPS']
          ], isbody: true),
          defaultSpacing(multiple: 2),
          AppText.text(articleOne_TwoText, textAlign: TextAlign.left),
          defaultSpacing()
        ],
      );
    }

    Widget _buildArticleTwoTable() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTable(columnText: [
            ['구분', '목적']
          ], isbody: false),
          _buildTable(columnText: [
            ['회원가입', '회원 정보 관리, 서비스 제공']
          ], isbody: true),
          defaultSpacing(multiple: 2),
          AppText.text('<앱에서 사용하는 정보 >', textAlign: TextAlign.left),
          defaultSpacing(),
          _buildTable(columnText: [
            ['구분', '목적']
          ], isbody: false),
          _buildTable(columnText: [
            ['카드정보', '앱 서비스 제공 및 카드인증'],
            ['장치정보', '장치 인증 서비스 제공'],
          ], isbody: true),
          defaultSpacing(multiple: 4)
        ],
      );
    }

    Widget _buildArticleThreeTable() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTable(columnText: [
            ['구분', '보유기간']
          ], isbody: false),
          _buildTable(columnText: [
            ['회원가입', '2년 동안 미사용 시 파기\n탈퇴 시 즉시 파기'],
            ['카드정보', '앱 삭제 시 즉시 파기\n(해당 정보는 앱 내에 저장된 정보만 파기됨)'],
            ['장치정보', '앱 삭제 시 즉시 파기\n(해당 정보는 앱 내에 저장된 정보만 파기됨)'],
          ], isbody: true),
          defaultSpacing(multiple: 4),
          AppText.text(articleThree_TwoText,
              textAlign: TextAlign.left, maxLines: 100),
          _buildTable(columnText: [
            ['보유기간']
          ], isbody: false),
          _buildTable(columnText: [
            ['1) 이용자의 인터넷 등 로그기록, 이용자의 접속지 추적자료 : 3개월 그 외의 통신사실 확인 자료 : 12개월'],
            ['2) 표시/광고에 관한 기록 : 6개월'],
            ['3) 계약 또는 탈퇴 등에 관한 기록 : 5년'],
            ['4) 대금 결제 및 재화 등의 공급에 관한 기록 : 5년'],
            ['5) 소비자의 문의•클레임 대응 또는 분쟁 처리에 관한 기록 : 보관 후 삭제'],
          ], isbody: true, isNotCenterAlin: true),
          defaultSpacing(multiple: 4)
        ],
      );
    }

    Widget _buildArticleFiveTable() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTable(columnText: [
            ['구분', '내용']
          ], isbody: false),
          _buildTable(columnText: [
            [
              '개인정보 보유기간 및 이용기간',
              '6개월 보관 후 삭제2년 동안 미사용 시 파기 / 탈퇴 시 즉시 파기분석 후 즉시 파기'
            ],
            ['이전(위탁)항목', '문의하기회원가입오류분석'],
            [
              '이전일시 및 방법',
              '이용자가 웹사이트에서 개인정보를 입력하는 시점에 네트워크를 통한 전송,오프라인에서 이용자가 개인정보를 제공한 후 네트워크를 통한 전송'
            ],
            ['이전국가', '서울'],
            ['이전(위탁)목적', '서비스 제공 및 개인정보 저장'],
            ['연락처', 'https://iteasy.co.kr/'],
            ['수탁업체', 'ITEASY CORP.(주)아이티이지'],
          ], isbody: true),
          defaultSpacing(multiple: 2),
          AppText.text(articleFive_TwoText,
              textAlign: TextAlign.left, maxLines: 100),
        ],
      );
    }

    Widget _buildLastTermsLinkWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () {
                launchUrl(Uri.parse('https://www.google.com'));
              },
              child: AppText.text(
                '이전 개인정보처리방침 링크',
                style: TextStyle(
                  color: Color.fromARGB(255, 57, 25, 241),
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.start,
              )),
          AppText.text('- 이전 개인정보처리방침 (2021.11.01)',
              textAlign: TextAlign.start),
          defaultSpacing(multiple: 4)
        ],
      );
    }

    Widget _buildContents() {
      return Container(
        padding: AppSize.defaultSidePadding,
        height: AppSize.realHeight - AppSize.appBarHeight,
        child: ListView(
          shrinkWrap: true,
          children: [
            _buildTermsOverview(),
            _buildTermsTitle(titleOne),
            _buildTermsArticleOne(),
            _buildArticleOneTable(),
            _buildTermsTitle(titleTwo),
            _buildTermsArticleTwo(),
            _buildArticleTwoTable(),
            _buildTermsTitle(titleThree),
            _buildTermsArticleThree(),
            _buildArticleThreeTable(),
            _buildTermsTitle(titleFour),
            _buildTermsArticleFour(),
            _buildTermsTitle(titleFive),
            _buildTermsArticleFive(),
            _buildArticleFiveTable(),
            _buildTermsTitle(titleSix),
            _buildTermsArticleSix(),
            _buildTermsTitle(titleSeven),
            _buildTermsArticleSeven(),
            _buildTermsTitle(titleEight),
            _buildTermsArticleEight(),
            _buildTermsTitle(titleNine),
            _buildTermsArticleNine(),
            _buildTermsTitle(titleTen),
            _buildTermsArticleTen(),
            _buildTermsTitle(titleEleven),
            _buildTermsArticleEleven(),
            _buildLastTermsLinkWidget()
          ],
        ),
      );
    }

    return BaseLayout(
        isWithWillPopScope: true,
        willpopCallback: () => true,
        hasForm: false,
        appBar: appBarContents(context,
            text: tr('user_privacy_policy'),
            elevation: 5,
            isUseActionIcon: true),
        child: _buildContents());
  }
}
