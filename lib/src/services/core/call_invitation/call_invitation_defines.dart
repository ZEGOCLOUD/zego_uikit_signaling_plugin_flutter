// Dart imports:
import 'dart:convert';

class ZegoCallInvitationExtendedData {
  String inviterName = ''; //
  int type = -1; //
  String data = ''; //  custom data by client

  ZegoCallInvitationExtendedData(this.inviterName, this.type, this.data);

  ZegoCallInvitationExtendedData.fromJson(String json) {
    var dict = jsonDecode(json) as Map<String, dynamic>;
    inviterName = dict['inviter_name'] as String;
    type = dict['type'] as int;
    data = dict['data'] as String;
  }

  String toJson() {
    var dict = {
      'inviter_name': inviterName,
      'type': type,
      'data': data,
    };
    return const JsonEncoder().convert(dict);
  }
}
