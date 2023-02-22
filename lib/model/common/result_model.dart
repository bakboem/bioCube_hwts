/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/common/result_model.dart
 * Created Date: 2022-07-06 10:31:40
 * Last Modified: 2023-02-22 22:40:54
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

class ResultModel {
  bool isSuccessful;
  dynamic data;
  String? message;
  String? errorMassage;
  bool? isServerError;
  bool? isNetworkError;
  bool? isShowErrorText;
  ResultModel(this.isSuccessful,
      {this.data,
      this.message,
      this.errorMassage,
      this.isNetworkError,
      this.isShowErrorText,
      this.isServerError});
}
