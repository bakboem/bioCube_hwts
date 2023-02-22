/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/terms/terms_of_user_page.dart
 * Created Date: 2023-01-27 22:55:21
 * Last Modified: 2023-02-22 22:44:46
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/widgets.dart';
import 'package:hwst/styles/app_size.dart';
import 'package:hwst/styles/app_text.dart';
import 'package:hwst/styles/app_text_style.dart';
import 'package:hwst/view/common/base_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hwst/view/common/widget_of_appbar_contents.dart';

class TermsOfUserPage extends StatelessWidget {
  const TermsOfUserPage({Key? key}) : super(key: key);
  static final String routeName = '/TermsOfUserPage';

  @override
  Widget build(BuildContext context) {
    const articleOverviewText = '''
Updated:
November 9, 2022

본 약관(이하 ‘본 약관’이라 함)은 주식회사 아이디테크(이하 ‘회사’라 함)이 제공하는 Moflex 모바일 액세스와 관련된 모든 제품 및 서비스(이하 ‘본 서비스’라 함)를 이용하는 고객(이하 ‘고객’이라 함)과 회사간에 본 서비스 이용에 관하여 정하는 것입니다.
본 약관에서는 다음 용어를 사용합니다.

''';
    const articleOneText = '''

1.1 ‘사이트 관리자’란 본 서비스를 이용하는 고객들을 관리하는 회사 혹은 기관의 관리자를 말합니다.
1.2 ‘모바일 ID' 이란 모바일 사원증과 같이 모바일 기기를 출입 통제 식별자로 사용하는 것을 말합니다.
1.3 ‘고객’이란 본 서비스를 사용하는 유저들을 지칭합니다.
1.4 ‘개인정보’란 식별된 또는 식별가능한 자연인과 관련된 모든 정보를 말합니다. 회사의 개인정보처리방침을 참고해주시기 바랍니다.

''';

    const articleTwoText = '''

2.1 회사는 본 약관의 조건에 따라 본 서비스를 제공합니다.
2.2 본 약관의 내용은 본 애플리케이션 내 또는 서비스 포털에 게시하는 방법으로 고객에게 고지합니다. 본 약관은 고객이 “동의합니다” 버튼을 클릭함으로써 효력이 발생합니다.
2.3 본 약관은 회사가 필요하다고 인정되는 경우 대한민국 법령 및 EU GDPR의 범위 내에서 개정할 수 있습니다. 회사가 약관을 개정할 경우에는 적용예정일 및 개정사유를 명시하여 현행 약관과 함께 애플리케이션 내 또는 서비스 초기화면에 그 적용예정일 7일 전부터 공지합니다. 다만, 고객에게 불리하게 약관내용을 변경하거나 중요한 조건을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지하는 것 외에 전자우편 발송 등 전자적 수단을 통해 별도로 통지합니다.
2.4 회사가 제3항에 따라 변경 약관을 공지 또는 통지하면서, 고객이 약관변경 적용일 전까지 거부의사를 표시하지 아니하는 경우 고객이 변경 약관에 동의한 것으로 간주합니다. 고객은 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하여 이용계약을 해지할 수 있습니다.
2.5 본 약관에 동의하는 것은 회사가 운영하는 서비스 포털을 정기적으로 방문하여 약관의 변경사항을 확인하는 것에 동의함을 의미합니다. 변경된 약관에 대한 정보를알지 못하여 발생하는 고객의 피해에 대해 회사는 책임을 지지 않습니다.

''';
    const articleThreeText = '''

3.1 본 약관에 명시되지 않은 사항은 개인정보보호법, 전기통신기본법, 전기통신사업법, 독점규제 및 공정거래에 관한 법률, 정보통신망 이용촉진 및 정보보호 등에 관한법률, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령, EU GDPR 및 회사가 정한 본 서비스의 세부 이용지침 등으로 규정(이하 “정책” 이라 함)할 수 있습니다.
3.2 정책이 본 약관의 조건과 상이한 경우, 정책에 명시된 조건이 우선합니다.
3.3 회사는 필요한 경우 본 서비스 이용과 관련된 정책을 이를 제2조 제3항의 방법에 의하여 공지할 수 있습니다.
3.4 본 약관과 관련하여 회사의 정책변경, 법령의 제/개정 또는 공공기관의 고시나 지침 등에 의하여 회사가 본 애플리케이션 내 또는 서비스포털 등을 통해 공지하는 내용도 본 약관의 일부를 구성합니다.

''';
    const articleFourText = '''

4.1 고객은 본 서비스 이용을 위해 고객 자신과 관련된 정보를 등록할 경우, 진실하고 정확하며 완전한 정보를 제공해야 하며 언제나 최신 정보가 적용되도록 수정해야 합니다.
4.2 고객은 본 서비스 이용을 위해 패스워드를 등록할 경우, 이를 부정하게 이용당하지 않도록 본인 책임 하에 엄중하게 관리해야 합니다. 당사는 등록된 패스워드를 이용하여 이루어진 일체의 행위를 고객 본인의 행위로 간주할 수 있습니다.
4.3 본 서비스에 등록한 고객은 언제라도 계정을 삭제하고 탈퇴할 수 있습니다.
4.4 회사는 고객이 본 약관을 위반하거나 또는 위반할 우려가 있다고 인정된 경우, 고객에 대한 사전 통지 없이 계정을 정지 또는 삭제할 수 있습니다.
4.5 회사는 개인정보보호법에 따라 연속하여 1년 동안 서비스를 이용하지 않은 고객의 개인정보를 보호하기 위해 계약을 해지하고, 개인정보 파기 등 필요한 조치를 취할 수 있습니다. 이 경우, 조치일 30일 전까지 필요한 조치가 취해진다는 사실과 개인정보 보유기간 만료일 및 개인정보의 항목을 고객에게 통지합니다.
4.6 고객이 본 서비스에서 가지는 모든 이용 권한은 이유를 막론하고 계정이 삭제된 시점에 소멸됩니다. 고객의 실수로 계정을 삭제한 경우에도 계정을 복구할 수 없으므로 주의하시기 바랍니다.
4.7 본 서비스의 계정은 고객에게 일신전속적으로 귀속됩니다. 고객이 본 서비스에서 가지는 모든 이용권은 제3자에게 양도, 대여 또는 상속할 수 없습니다.

''';
    const articleFiveText = '''

5.1 회사는 고객의 프라이버시를 존중합니다.
5.2 회사는 고객의 프라이버시 정보와 개인정보를 회사의 개인정보처리방침에 따라 적절하게 취급합니다.
5.3 회사는 고객으로부터 수집한 정보를 안전하게 관리하기 위해 보안에 최대한 주의를 기울이고 있습니다.

''';
    const articleSixText = '''

6.1 고객은 본 서비스를 이용하는 데 있어 필요한 PC나 휴대전화 단말기, 통신 기기, 운영 체제, 통신 수단 및 전력 등을 고객의 비용과 책임 하에 준비해야 합니다.
6.2 회사는 본 서비스의 전부 또는 일부를 연령, 본인 확인 여부, 등록정보 유무, 기타 당사에서 필요하다고 판단한 조건을 만족시키는 고객에 한하여 제공할 수 있습니다.
6.3 회사는 필요하다고 판단될 경우, 고객에 대한 사전 통지 없이 언제라도 본 서비스의 전부 또는 일부 내용을 변경할 수 있으며 또한 그 제공을 중지할 수 있습니다.
6.4 회사는 회사의 재량으로 본 서비스의 내용을 별도의 통지 없이 변경하거나 중단할 수 있습니다.
6.5 회사는 다음 각호에 해당하는 경우 본 서비스의 전부 또는 일부를 제한하거나 변경할 수 있습니다.
1) 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 통신의 두절 등의 사유가 발생한 경우 
2) 본 서비스를 위한 설비의 보수 등 공사로 인해 부득이한 경우 
3) 본 서비스의 업그레이드 및 포털 유지보수 등을 위해 필요한 경우 
4) 정전, 제반 설비의 장애 등으로 정상적인 서비스 이용에 지장이 있는 경우 
5) 본 서비스 제공업자와의 계약 종료 등 회사의 제반 사정으로 서비스를 유지할 수 없는 경우 
6) 기타 천재지변, 국가비상사태 등 불가항력적 사유가 있는 경우 
6.6 전 6.5 항에 의한 서비스 중단의 경우에는 회사가 제2조 제3항에서 정한 방법으로 고객에게 통지합니다. 단, 회사가 통제할 수 없는 사유로 인한 서비스의 중단(운영자의 과실이 없는 시스템 장애 등)으로 인하여 사전 통지가 불가능한 경우에는 그러하지 아니합니다.
6.7 회사는 고의, 중과실이 없는 한 서비스의 변경, 중단으로 인하여 고객이 입은 손해에 대해 어떠한 책임도 지지 아니합니다.

''';
    const articleSevenText = '''

7.1 회사는 회사가 제공하는 본 서비스에 대해 양도 및 재허락이 불가능합니다. 본 서비스는 비독점적이며 본인을 위한 사용을 목적으로 하는 고객에게 사용권을 부여합니다.
7.2 회사가 고객에게 제공하는 본 서비스에 관한 지식재산권 및 기타 권리는 고객에게 이전되지 않으며, 고객에게는 상기 사용권만이 부여됩니다.
7.3 고객은 본 서비스를 미리 정한 이용 형태를 넘어서 이용(복제, 송신, 전재, 수정 등의 행위를 포함)해서는 안 됩니다.
7.4 고객은 본 서비스의 이용을 위해 본 서비스에서 지정한 라이선스를 구매하여 이용 권한을 얻어야 합니다.
7.5 고객은 본 서비스를 통해 발급한 모바일 ID에 대한 이용권한을 보유하며, 회사는 원칙적으로 이를 다른 고객과 공유하거나 제어하지 않습니다. 단, 회사는 본 약관을 위반하거나 또는 위반할 우려가 있다고 보이는 경우, 고객의 등록, 기 발급된 모바일 ID 및 등록 장치를 삭제 하고 해당 고객의 접근을 제한할 수 있습니다.

''';
    const articleEightText = '''

고객은 본 서비스 이용 중 다음에 기재된 행위를 해서는 안 됩니다.
8.1 법령, 법원의 판결, 결정 혹은 명령 또는 법령상 구속력을 가지는 행정 조치에 위반되는 행위.
8.2 회사 또는 제3자의 저작권, 상표권, 특허권 등의 지식재산권, 명예권, 프라이버시권, 기타 법령상 또는 계약상의 권리를 침해하는 행위.
8.3 회사 또는 제3자를 사칭, ID 도용, 비밀번호 도용 등의 행위 또는 의도적으로 허위 정보를 유포하는 행위.
8.4 다른 고객으로 위장 혹은 동의 없이 장치를 등록하고 모바일 ID을 발급 하는 행위.
8.5 당사가 정한 방법 외의 방법으로 본 서비스의 이용권을 현금, 재물 기타 경제적 이익과 교환하는 행위.
8.6 본 서비스가 미리 정한 이용 목적과 다른 목적으로 본 서비스를 이용하는 행위.
8.7 타인의 개인정보, 등록 정보, 이용 이력 정보 등을 불법으로 수집, 공개 또는 제공하는 행위.
8.8 본 서비스의 서버와 네트워크 시스템에 지장을 주는 행위, BOT, 치팅 툴, 기타 기술적인 수단을 이용하여 서비스를 불법으로 조작하는 행위, 본 서비스의 장애를 의도적으로 이용하는 행위, 기타 당사의 본 서비스 운영 또는 다른 고객의 본 서비스 이용을 방해하거나 이에 지장을 주는 행위.
8.9 상기 8.1부터 8.8까지의 어느 하나에 해당되는 행위를 지원 또는 조장하는 행위.
8.10 기타 공공질서 및 미풍양속을 위반하거나 불법적, 부당한 행위 및 관계법령에 위배되는 행위.

''';
    const articleNineText = '''

9.1 고객은 고객 자신의 책임 하에 본 서비스를 이용해야 하며, 본 서비스에서 이루어진 모든 행위 및 그 결과에 대해서 일체의 책임을 져야 합니다.
9.2 회사는 고객이 본 약관에 위반되는 형태로 본 서비스를 이용하고 있다고 인정한 경우, 회사에서 필요하고 적절하다고 판단한 조치를 취하겠습니다. 단, 회사는 이러한 위반 행위를 방지 또는 시정할 의무를 갖지 않습니다.
9.3 본 서비스 이용에 기인하여(회사가 이러한 이용으로 인해 클레임을 제3자로부터 받은 경우를 포함함)회사가 직접적 혹은 간접적으로 어떤 손해(변호사 비용 부담을 포함함)를 입었을 경우, 고객은 회사의 요구에 따라 즉시 이를 보상해야 합니다.

''';
    const articleTenText = '''

10.1 사이트 관리자는 사이트 관리자가 관리하는 개인정보를 관리할 책임이 있습니다. 사이트 관리자는 개인정보에 대한 사이트 관리자의 부적절한 관리로 인해 발생하는 모든 위반, 침해 또는 손해에 대해 전적으로 책임을 집니다. 
10.2 사이트 관리자는 본 서비스를 책임감있게 관리하고 본 서비스 또는 발견된 개인정보의 보안에 영향을 미치는 문제가 있는 경우 즉시 회사에 알려야 합니다. 
10.3 사이트 관리자는 (i)10.1항 위반, (ii) 사이트 관리자의 고의나 과실로 인한 고객 또는 제3자의 법적 조치, (iii) 회사 귀책에 의하지 않은 현지 법률 위반으로 인해 발생한 모든 종류 및 성격의 손실, 비용, 책임, 청구, 손해 및 비용으로부터 회사를 보호, 방어 및 면책해야 합니다. 

''';
    const articleElevenText = '''

본 약관에 명시된 경우를 제외하고 회사는 어떠한 명시적 또는 묵시적 보증도 하지 않으며, 비침해성, 상품성, 특정 목적에의 적합성 또는 거래 관행에서 비롯된 모든 묵시적 보증을 포함한 모든 보증을 명시적으로 부인합니다.  


''';
    const articleTwelveText = '''

12.1 어떠한 경우에도 회사는 본 약관에서 비롯된 또는 관련된 사용 손실, 업무 중단, 데이터 손실 또는 이익 손실을 포함한 간접적, 결과적, 부수적, 특수적 또는 징벌적 손해에 대하여 책임지지 않습니다. 어떠한 경우에도 본 계약에 따른 회사의 총 책임은 이전 12개월동안 고객이 지불한 총 수수료를 초과하지 않습니다.  
12.2 회사가 본 약관의 의무를 위반하는 경우 고객의 유일한 구제책은 서비스 이용을 중단하고 지불한 비용에 대하여 비례환불을 받는 것입니다. 
''';
    const articleThirteenText = '''

회사는 고객의 실제 또는 의심되는 본 서비스의 무단사용 및/또는 본 약관 계약 위반의 경우를 포함하여 언제든지 본 약관 계약을 해지하거나 본 서비스에 대한 고객의 접근을 중단할 수 있습니다. 그러한 경우, 고객은 회사가 고객에 대해 책임을 지지 않으며 관련 법률에서 허용하는 범위 내에서 고객이 이미 지불한 비용을 환불하지 않는다는 데 동의합니다. 고객은 언제든지 본 약관 계약을 해지할 수 있습니다. 고객 계정을 해지하는 방법을 알아보려면 제14조 제2항의 방법으로 연락하시기 바랍니다.
''';
    const articleFourteenText = '''

14.1 본 서비스와 관련해 회사가 고객에게 연락할 경우 회사가 운영하는 웹사이트 내의 적절한 위치에 게시하거나 기타 회사가 적절하다고 판단하는 방법으로 합니다.
14.2 본 서비스와 관련해 고객이 회사에 연락할 경우 회사가 운영하는 웹사이트 내의 적절한 위치에 있는 고객 문의 페이지를 이용하거나 회사가 지정하는 방법으로 합니다. 
''';
    const articleFifteenText = '''

본 약관은 한국어를 정본으로 하며, 대한 민국 법을 준거법으로 합니다. 본 서비스에 기인 또는 관련하여 고객과 당사 간에 발생한 분쟁에 대해서는 회사가 지정한 대한 민국 소재 법원을 제1심 전속적 합의 관할 법원으로 합니다.

''';

    const titleOne = '1. 정의';
    const titleTwo = '2. 약관 동의';
    const titleThree = '3. 약관 외 준칙';
    const titleFour = '4. 계정';
    const titleFive = '5. 프라이버시';
    const titleSix = '6. 서비스 제공';
    const titleSeven = '7. 본 서비스';
    const titleEight = '8. 금지 사항';
    const titleNine = '9. 고객의 책임';
    const titleTen = '10. 사이트 관리자의 책임';
    const titleEleven = '11. 회사의 면책조항';
    const titleTwelve = '12. 책임 및 구제수단의 제한';
    const titleThirteen = '13. 해지';
    const titleFourteen = '14. 연락 방법';
    const titleFifteen = '15. 준거법과 재판 관할';

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

    Widget _buildTermsArticleTwelve() {
      return AppText.text(articleTwelveText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleThirteen() {
      return AppText.text(articleThirteenText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleFourteen() {
      return AppText.text(articleFourteenText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsArticleFifteen() {
      return AppText.text(articleFifteenText,
          maxLines: 100, textAlign: TextAlign.left);
    }

    Widget _buildTermsTitle(String title) {
      return AppText.text(title,
          style: AppTextStyle.bold_22, textAlign: TextAlign.left);
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
            _buildTermsTitle(titleTwo),
            _buildTermsArticleTwo(),
            _buildTermsTitle(titleThree),
            _buildTermsArticleThree(),
            _buildTermsTitle(titleFour),
            _buildTermsArticleFour(),
            _buildTermsTitle(titleFive),
            _buildTermsArticleFive(),
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
            _buildTermsTitle(titleTwelve),
            _buildTermsArticleTwelve(),
            _buildTermsTitle(titleThirteen),
            _buildTermsArticleThirteen(),
            _buildTermsTitle(titleFourteen),
            _buildTermsArticleFourteen(),
            _buildTermsTitle(titleFifteen),
            _buildTermsArticleFifteen(),
          ],
        ),
      );
    }

    return BaseLayout(
        isWithWillPopScope: true,
        willpopCallback: () => true,
        hasForm: false,
        appBar: appBarContents(context,
            text: tr('end_user_license_agreement_terms'),
            elevation: 5,
            isUseActionIcon: true),
        child: _buildContents());
  }
}
