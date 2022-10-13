# method
## init

### init.params

{
    'appID': appID,    // long
    'appSign': appSign // String
}

### init.result

{} // void

## uninit

### uninit.params

{} // void

### uninit.result

{} // void

## login

### login.params

{
    'userID': id,     // String 
    'userName': name  // String
}

### login.result

{} // void

## logout

### logout.params

{} // void

### logout.result

{} // void


## sendInvitation

### sendInvitation.params

{
    'inviterName': inviterName, // String 
    'invitees': invitees,       // List<String>  (userid)
    'timeout': timeout,         // int 
    'type': type,               // int 
    'data': data                // String 
}

### sendInvitation.result

{
    'code': code,        // int
    'message': message,  // String
    'callID':callid,     // String
    'errorInvitees':errorInvitees  // List<String>  (userid)
}

## cancelInvitation

### cancelInvitation.params

{
    'invitees': invitees,  // List<String> 
    'data': data           // String 
}


### cancelInvitation.result

{
    'code': code // int
    'message': message // string
    'errorInvitees':errorInvitees // List<String> (userid)
}

## refuseInvitation

### refuseInvitation.params

{
    'inviterID': inviterID, // String inviterID
    'data': data            // String data
}

### refuseInvitation.result

{} // void

## acceptInvitation

### acceptInvitation.params

{
    'inviterID': inviterID,  // String inviterID
    'data': data             // String data
}

### acceptInvitation.result

{} // void

# event

## onCallInvitationReceived
{
  'inviter': ZegoUIKitUser(id: info.inviter, name: info.extendedData.Decode['inviter_name'] as String),
  'type': info.extendedData.Decode['type'] as int,
  'data': info.extendedData.Decode['data'] as String,
}

## onCallInvitationCancelled
{
  'inviter': ZegoUIKitUser(id: info.inviter, name: ''),
  'data': info.extendedData,
}

## onCallInvitationAccepted
{
  'invitee': ZegoUIKitUser(id: info.invitee, name: ''),
  'data': info.extendedData,
}

## onCallInvitationRejected
{
    'invitee': ZegoUIKitUser(id: info.invitee, name: ''),
    'data': info.extendedData,
}

## onCallInvitationTimeout
{
  'inviter': ZegoUIKitUser(id: inviteUserID, name: ''),
  'data': '',
}


## onCallInviteesAnsweredTimeout
{
  'invitees': invitees.map((inviteeID) => ZegoUIKitUser(id: inviteeID, name: '')).toList(),
  'data': '',
}
