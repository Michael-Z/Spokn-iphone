/*
 *  alertmessages.h
 *  spokn
 *
 *  Created by Rishi Saxena on 18/01/10.
 *  Copyright 2010 Geodesic Ltd. All rights reserved.
 *
 */


#ifndef _ALERT_MESSAGES_H_
	#define _ALERT_MESSAGES_H_

#define _TEXTCOLOR_ 42/255.0 green:116/255.0 blue:217/255.0 alpha:1.0
#define _REDCOLOR_ 187/255.0 green:25/255.0 blue:25/255.0 alpha:1.0
#define SIGN_IN_TEXT @"Sign-in"
#define _EMPTY_CONTACT_DETAILS_ @"This contact does not have any Number or Email address."
#define _EMPTY_USERNAME_ @"User name cannot be empty"
#define _EMPTY_PASSWORD_ @"Password cannot be empty"
#define _USERNAME_NO_WHITESPACE_ @"User name should not contain white space"
#define _PASSWORD_NO_WHITESPACE_ @"Password should not contain white space"
#define _INVALID_NUMBER_ @"Please enter a valid number."
#define _NOT_ONLINE_ @"User not online"
#define _NO_NETWORK_ @"No Network"
#define _ENTER_NUMEBR_ @"Please enter the number."
#define _SERVER_UNREACHABLE_ @"Server not reachable"
#define _AUTHENTICATION_FAILED_ @"Check Spokn ID and Password"
#define _NO_AVAILABLE_NETWORK_ @"Network is not available"
#define _CONNECTION_FAILED_ @"Unable to connect server."
#define _EMPTY_FORWARD_NUMBER_ @"Forward number should not be empty"
#define _VMS_ALREADY_PLAYING @"Vms is already playing"
#define _VMS_NOT_FULLY_DOWNLOADED @"This can be due to slow Internet access.\r\nDo you want to try downloading now?"
#define _CLEAR_VMS_LOG_ @"Are u sure you want to clear vmail?"
#define _INVALID_EMAIL_ @"Invalid email address"
#define _CONTACT_DELETE_ @"Are you sure you want to delete contact?"
#define _INVALID_CONTACT_ @"Contact Name/Number cannot be blank."
#define _DELETE_CALL_LOG_ @"Are you sure you want to delete calllog?"
#define _VMS_SENT_ @"VMS sent successfuly."
#define _VMS_SENDING_FAILED_ @"VMS sending failed"
#define _VMS_RECORDING_MSG1_ @"Press record to compose a 20 second long VMS"
#define _VMS_RECORDING_MSG2_ @"Press done to finish recording."
#define _VMS_RECORDING_MSG3_ @"You may send, preview or re-record the VMS now"
#define _EMPTY_NUMBER_ @"Number field should not be empty."
//#define _DELETE_VMS_ @"Are you sure you want to delete this voice mail?"
#define _NO_VMS_PLAY_ @" can not play vms"
#define _CLEAR_CALL_LOG_ @"Clear all calls"
#define _DUPLICATE_FORWARD_NUMBER_ @"The number you provided for call forwarding has already been used by someone else.Please provide another number and try again."
#define _NO_CREDITS_ @"Your VMS could not be sent because you do not have enough credit. Please recharge & try again."
#define _NO_WIFI_ @"Wi-Fi not available"
#define _NO_MICROPHONE_ @"No Microphone Available"
#define _USER_OFFLINE_ @"User not online"
#define _NO_NUMBER_IN_CONTACT_ @"no number in contact"
#define _SELECT_NUM_TO_CALL_ @"Select a Number to call"
#define _NO_NUMBER_TO_CALL_ @"No Number to call"


#define _CALLING_FAILED_ @"Unable to call the destination number."
#define _RETURN_TO_CALL_ @"Touch to return to call"
#define _TITLE_ @"Spokn"
#define _OK_ @"OK"
#define _CANCEL_ @"Cancel"
#define _DELETE_VMS_ @"Delete VMS"
#define _DELETE_CONTACT_ @"Delete Contact"
#define _DELETE_CALLLOG_ @"Delete Calllog"

#define _DELETE_ @"Delete"
#define _MOBILE_ @"mobile"
#define _HOME_ @"home"
#define _BUSINESS_ @"business"
#define _SPOKN_ID_ @"Spokn ID"
#define _OTHER_ @"Other"
#define _EMAIL_ @"email"
#define _ALL_ @"All"
#define _MISSED_ @"Missed"
#define _UNDELIVERED_ @"Undelivered"
#define _PLAY_ @"Play"
#define _RECORD_ @"Record"
#define _RERECORD_ @"Rerecord"
#define _STOP_ @"Stop"
#define _FORWARD_ @"Forward"
#define _REPLY_ @"Reply"
#define _SEND_ @"Send"
#define _PREVIEW_ @"Preview"
#define _STATUS_CONNECTING_ @"Connecting..."
#define _STATUS_OFFLINE_ @"Offline"
#define _STATUS_NO_NETWORK_ @"No Network"
#define _STATUS_NO_WIFI_ @"No wifi available"
#define _STATUS_ONLINE_ @"Online"
#define _STATUS_AUTHENTICATION_FAILED_ @"Authentication failed"
#define _STATUS_NO_ACCESS_ @"no access"


//URLS
#define _URL_SPOKN_ @"http://www.spokn.com"
#define _URL_SIGNUP_ @"http://www.spokn.com/cgi-bin/signup.cgi"
#define _URL_FORGOT_PASS_ @"http://www.spokn.com/services/wm/forgot-password"

//PNG Files
#define _TAB_VMS_PNG_ @"TB-VMS.png"
#define _TAB_MY_SPOKN_PNG_ @"TB-Spokn.png"
#define _TAB_KEYPAD_PNG_ @"Dial.png"

#define _CALL_MISS_PNG_ @"Call-log-Icons-missed.png"
#define _CALL_IN_PNG_ @"Call-log-Icons-incoming.png"
#define _CALL_OUT_PNG_ @"Call-log-Icons-outgoing.png"
#define _CALL_WATERMARK_PNG_ @"Default.png"

#define _VMS_OUT_ACTIVE_PNG_ @"vms_out_Active.png"
#define _VMS_OUT_DELIVERED_PNG_ @"vm_icons_outgoing_delivered.png"
#define _VMS_OUT_UNDELIVERED_PNG_ @"vm_icons_outgoing_undelivered.png"
#define _VMS_IN_NEW_PNG_ @"vm_icons_incoming_new.png"
#define _VMS_IN_READ_PNG_ @"vm_icons_incoming_read.png"
#define _VMS_OUT_NEWHIGH_PNG_ @"vmail_out_newHigh.png"

#define _SPOKN_STATUS_PNG_ @"AS-status"
#define _SPOKN_CREDITS_PNG_ @"AS-credits"
#define _SPOKN_FORWARD_PNG_ @"AS-callforward"
#define _SPOKN_FORWARD_TO_PNG_ @"AS-forward-to"
#define _SPOKN_LOGO_PNG_ @"AS-spokn"

#define _VMS_PROGRESS_LEFT_PNG_ @"vmsprogressleft.png"
#define _VMS_PROGRESS_RIGHT_PNG_ @""
#define _TAB_DEL_NORMAL_PNG_ @"3_delete_50_30_normal.png"
#define _TAB_DEL_PRESSED_PNG_ @"3_delete_50_30_pressed.png"
#define _DONE_NORMAL_PNG_ @"5_done_270_45_normal.png"
#define _DONE_PRESSED_PNG_ @"5_done_270_45_pressed.png"
#define _PLAY_NORMAL_PNG_ @"5_play_270_45_normal.png"
#define _PLAY_PRESSED_PNG_ @"5_play_270_45_pressed.png"
#define _RECORD_NORMAL_PNG_ @"5_record_270_45_normal.png"
#define _RECORD_PRESSED_PNG_ @"5_record_270_45_pressed.png"
#define _RERECORD_NORMAL_PNG_ @"5_rerecord_270_45_normal.png"
#define _RERECORD_PRESSED_PNG_ @"5_rerecord_270_45_pressed.png"
#define _ENDCALL_NORMAL_PNG_ @"2_endcall_270_45_normal.png"
#define _ENDCALL_PRESSED_PNG_ @"2_endcall_270_45_pressed.png"
#define _HIDE_KEYPAD_NORMAL_PNG_ @"2_hidekeypad_125_45_normal.png"
#define _HIDE_KEYPAD_PRESSED_PNG_ @"2_hidekeypad_125_45_pressed.png"
#define _SMALL_ENDCALL_NORMAL_PNG_ @"2_endcall_125_45_normal.png"
#define _SMALL_ENDCALL_PRESSED_PNG_ @"2_endcall_125_45_pressed.png"
#define _ANSWER_NORMAL_PNG_ @"1_answer_125_45_normal.png"
#define _ANSWER_PRESSED_PNG_ @"1_answer_125_45_pressed.png"
#define _DECLINE_NORMAL_PNG_ @"1_decline_125_45_normal.png"
#define _DECLINE_PRESSED_PNG_ @"1_decline_125_45_pressed.png"
#define _DIALPAD_NORMAL_PNG_ @"keypad-normal.png" 
#define _DIALAD_PRESSED_PNG_ @"keypad-pressed.png"
#define _KEYPAD_NORMAL_PNG_ @"grey-keypad.png"  
#define _KEYPAD_PRESSED_PNG_ @"blue-keypad.png"
#define _SEARCHBAR_PNG_ @"pic3.png"
#define _DEL_NORMAL_PNG_ @"6_deleteconfirm_302_45_normal.png"
#define _DEL_PRESSED_PNG_ @"6_deleteconfirm_302_45_pressed.png"

//Sound Files
#define _TONE_FILE_TYPE_ @"caf"
#define _TONE_ONLINE_ @"gling"
#define _TONE_CALL_END_ @"doorbell"
#define _TONE_PHONE_ @"phone"

#endif
