
// Created on 18/01/10.


/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 2 of the License.
  
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */


#ifndef _ALERT_MESSAGES_H_
	#define _ALERT_MESSAGES_H_

#define _TEXTCOLOR_ 42/255.0 green:116/255.0 blue:217/255.0 alpha:1.0
#define _REDCOLOR_ 187/255.0 green:25/255.0 blue:25/255.0 alpha:1.0


//Default title for alert messages
#define _TITLE_ @"Spokn"

//Alert messages
#define _NO_CONTACT_DETAILS_MESSAGE_ @"No contact details"
#define _EMPTY_CONTACT_DETAILS_ @"This contact does not have any Number or Email address."
#define _EMPTY_USERNAME_ @"Spokn Id missing"
#define _EMPTY_PASSWORD_ @"Password empty"
#define _EMPTY_USERNAME_MESSAGE_ @"Please provide a valid Spokn ID."
#define _EMPTY_PASSWORD_MESSAGE_ @"Please provide a valid Password."
//#define _USERNAME_NO_WHITESPACE_ @"Spokn Id should not contain blank spaces."
//#define _PASSWORD_NO_WHITESPACE_ @"Password should not contain blank spaces."
//#define _INVALID_NUMBER_ @"Invalid number"
//#define _INVALID_NUMBER_MESSAGE_ @"Please enter a phone number preceded with the country code or a 7 digit Spokn ID to call."
//#define _NO_NUMBER_ @"No number"
//#define _NO_NUMBER_CALL_MESSAGE_ @"Please type a valid number to call."
//#define _NO_NUMBER_VMS_MESSAGE_ @"Please type a valid number to send vms."
#define _SERVER_UNREACHABLE_ @"Spokn service not reachable"
#define _SERVER_UNREACHABLE_MESSAGE_ @"Please check your internet connection and retry."
#define _AUTHENTICATION_FAILED_ @"Please check your Spokn ID and Password."
#define _CONNECTION_FAILED_ @"Unable to connect to the Spokn service."
//#define _EMPTY_FORWARD_NUMBER_ @"Forward number should not be empty"
#define _VMS_ALREADY_PLAYING_ @"VMS is already playing"
#define _INCOMPLETE_VMS_ @"VMS not downloaded yet"
#define _VMS_NOT_FULLY_DOWNLOADED_ @"Do you want to download the VMS now?"
//#define _INVALID_EMAIL_ @"Invalid email"
//#define _INVALID_EMAIL_MESSGAE_ @"Please provide a valid email id."
#define _INVALID_CONTACT_ @"Insufficient details" 
#define _INVALID_CONTACT_MESSAGE_ @"Please provide the name and atleast a number/email."
#define _VMS_SENDING_FAILED_ @"Failed to send VMS"
#define _NO_VMS_PLAY_ @"VMS could not be played"
#define _CLEAR_CALL_LOG_ @"Clear all calls"
#define _DUPLICATE_FORWARD_NUMBER_ @"Duplicate number"
#define _DUPLICATE_FORWARD_NUMBER_MESSAGE_ @"This number has already been used by someone else. Please provide another phone number."
#define _NO_CREDITS_ @"Insufficient credits"
#define _NO_CREDITS_MESSAGE_ @"Your VMS could not be sent because you do not have enough credits. Do you want to recharge now?"
#define _NO_WIFI_ @"WiFi connection not available"
#define _NO_MICROPHONE_ @"No microphone detected"
#define _NO_MICROPHONE_MESSAGE_ @"In order to use Spokn you must use supported earphones with remote and microphone."
#define _USER_OFFLINE_ @"Still connecting to Spokn"
#define _USER_OFFLINE_MESSAGE_ @"Please try after some time."
//#define _NO_NUMBER_IN_CONTACT_ @"No number in contact to call."
#define _CHECK_NETWORK_SETTINGS_ @"Please check your Internet connection and retry."
#define _SIGN_IN_FAILED_ @"Sign-in failed"
//#define _UPGRADE_AVAILABLE_ @"Upgrade Available"
#define _NO_NETWORK_ @"Unable to connect to Spokn"
#define _SIP_LIB_NOT_INIT_ @"Sip library not initialize."
//Alert messages not used in build
#define _CALLING_FAILED_ @"Unable to call the destination number."
#define _CLEAR_VMS_LOG_ @"Are u sure you want to clear vmail?"


//Text in labels and actionsheets
#define _SELECT_NUM_TO_CALL_ @"Select a Number to call"
//#define _NO_NUMBER_TO_CALL_ @"No Number to call"
#define _SELECT_NUM_TO_VMS_ @"Select a number to VMS"
#define _VMS_RECORDING_MSG1_ @"Press record to compose a 20 second long VMS"
#define _VMS_RECORDING_MSG2_ @"Press done to finish recording."
#define _VMS_RECORDING_MSG3_ @"You may send, preview or re-record the VMS now"
#define _RETURN_TO_CALL_ @"Touch to return to the call"



// Button titles
#define _OK_ @"OK"
#define _CANCEL_ @"Cancel"
#define _CLEAR_ @"Clear"
#define _DELETE_VMS_ @"Delete VMS"
#define _DELETE_CONTACT_ @"Delete Contact"
#define _DELETE_CALLLOG_ @"Delete Call log"
#define SIGN_IN_TEXT @"Sign-in"
#define SIGN_OUT_TEXT @"Sign-out"
#define _PLAY_ @"Play"
#define _RECORD_ @"Record"
#define _RERECORD_ @"Rerecord"
#define _STOP_ @"Stop"
#define _FORWARD_ @"Forward"
#define _REPLY_ @"Reply"
#define _SEND_ @"Send"
#define _PREVIEW_ @"Preview"
#define _ALL_ @"All"
#define _MISSED_ @"Missed"
#define _UNDELIVERED_ @"Undelivered"
#define _SPOKN_ @"Spokn"
#define _PHONE_ @"Phone"

//Miscellaneous text
#define _MOBILE_ @"mobile"
#define _HOME_ @"home"
#define _BUSINESS_ @"business"
#define _SPOKN_ID_ @"spokn"
#define _OTHER_ @"Other"
#define _EMAIL_ @"email"



//Status messages
#define _STATUS_CONNECTING_ @"Connecting..."
#define _STATUS_TIMEOUT1_ @"TimeOut"
#define _STATUS_TIMEOUT2_ @"Connection timed out. Please try to sign-in again."
#define _STATUS_OFFLINE_ @"Offline"
#define _STATUS_NO_NETWORK_ @"No Network"
#define _STATUS_NO_WIFI_ @"No wifi available"
#define _STATUS_ONLINE_ @"Online"
#define _STATUS_AUTHENTICATION_FAILED_ @"Authentication failed"
#define _STATUS_NO_ACCESS_ @"No access"


//URLS
#define _URL_SPOKN_ @"http://www.spokn.com"
#define _URL_SIGNUP_ @"http://www.spokn.com/cgi-bin/signup.cgi"
#define _URL_FORGOT_PASS_ @"http://www.spokn.com/services/wm/forgot-password"

//PNG Files
#define _TAB_VMS_PNG_ @"TB-VMS.png"
#define _TAB_MY_SPOKN_PNG_ @"TB-Spokn.png"
#define _TAB_KEYPAD_PNG_ @"Dial.png"
#define _TAB_CALLS_PNG_ @"TB-recent.png"
#define _CALL_MISS_PNG_ @"Call-log-Icons-missed.png"
#define _CALL_IN_PNG_ @"Call-log-Icons-incoming.png"
#define _CALL_OUT_PNG_ @"Call-log-Icons-outgoing.png"
#define _CALL_WATERMARK_PNG_ @"Default.png"
#define _CALL_BLUETOOH_BG_ @"button-bg.png"
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
#define _PLAY_NORMAL_PNG_ @"270x45-play-normal.png"
#define _PLAY_PRESSED_PNG_ @"270x45-play-pressed.png"
#define _RECORD_NORMAL_PNG_ @"5_record_270_45_normal.png"
#define _RECORD_PRESSED_PNG_ @"5_record_270_45_pressed.png"
#define _RERECORD_NORMAL_PNG_ @"5_rerecord_270_45_normal.png"
#define _RERECORD_PRESSED_PNG_ @"5_rerecord_270_45_pressed.png"
#define _ENDCALL_NORMAL_PNG_ @"280x52-end-call-normal.png"
#define _ENDCALL_PRESSED_PNG_ @"280x52-end-call-pressed.png"
#define _HIDE_KEYPAD_NORMAL_PNG_ @"132x52-hide-keypad-normal.png"
#define _HIDE_KEYPAD_PRESSED_PNG_ @"132x52-hide-keypad-pressed.png"
#define _SMALL_ENDCALL_NORMAL_PNG_ @"132x52-end-call-normal.png"
#define _SMALL_ENDCALL_PRESSED_PNG_ @"132x52-end-call-pressed.png"
#define _ANSWER_NORMAL_PNG_ @"132x52-answer-normal.png"
#define _ANSWER_PRESSED_PNG_ @"132x52-answer-pressed.png"
#define _DECLINE_NORMAL_PNG_ @"132x52-decline-normal.png"
#define _DECLINE_PRESSED_PNG_ @"132x52-decline-pressed.png"
#define _DIALPAD_NORMAL_PNG_ @"keypad-normal.png" 
#define _DIALAD_PRESSED_PNG_ @"keypad-pressed.png"
#define _KEYPAD_NORMAL_PNG_ @"grey-keypad.png"  
#define _KEYPAD_PRESSED_PNG_ @"blue-keypad.png"
#define _SEARCHBAR_PNG_ @"pic3.png"
#define _DEL_NORMAL_PNG_ @"6_deleteconfirm_302_45_normal.png"
#define _DEL_PRESSED_PNG_ @"6_deleteconfirm_302_45_pressed.png"
#define _SCREEN_BORDERS_PNG_ @"black1.png"

#define _CALL_SPEAKER_PNG_ @"speaker-wit-text.png"
#define _CALL_KEYPAD_PNG_ @"keypad-wit-text.png"

#define _BLUETOOTH_PANEL_PNG_ @"button-bg.png"
#define _BLUETOOTH_SOURCE_PNG_ @"audio-source.png"
#define _BLUETOOTH_HIDE_PNG_ @"132x52-hide-sources-normal.png"
#define _BLUETOOTH_HIDE_PRESSED_PNG_ @"132x52-hide-sources-pressed.png"
#define _BLUETOOTH_AUDIO_PNG_ @"240x52-buttons-bluetoothaudio-normal.png"
#define _BLUETOOTH_AUDIO_PRESSED_PNG_ @"240x52-buttons-bluetoothaudio-pressed.png"
#define _BLUETOOTH_AUDIO_SPEAKER_PNG_ @"240x52-buttons-bluetoothaudio-speaker-normal.png"
#define _BLUETOOTH_AUDIO_SPEAKER_PRESSED_PNG_ @"240x52-buttons-bluetoothaudio-speaker-pressed.png"
#define _BLUETOOTH_IPHONE_PNG_ @"240x52-buttons-iphone-normal.png"
#define _BLUETOOTH_IPHONE_PRESSED_PNG_ @"240x52-buttons-iphone-pressed.png"
#define _BLUETOOTH_IPHONE_SPEAKER_PNG_ @"240x52-buttons-iphone-speaker-normal.png"
#define _BLUETOOTH_IPHONE_SPEAKER_PRESSED_PNG_ @"240x52-buttons-iphone-speaker-pressed.png"
#define _BLUETOOTH_SPEAKER_PNG_ @"240x52-buttons-speaker-normal.png"
#define _BLUETOOTH_SPEAKER_PRESSED_PNG_ @"240x52-buttons-speaker-pressed.png"
#define _BLUETOOTH_SPEAKER_SPEAKER_PNG_ @"240x52-buttons-speaker-speaker-normal.png"
#define _BLUETOOTH_SPEAKER_SPEAKER_PRESSED_PNG_ @"240x52-buttons-speaker-speaker-pressed.png"

#define PRIVATE_CALL_IMG_PNG  @"Private-Conf-Call.png"
#define PHONE_CALL_IMG_PNG  @"Phone-Icon.png"

#define END_CALL_IMG_PNG  @"End-Conf-Call.png"
#define END_CALL_BIG_IMG_PNG  @"End_big_conf_call.png"

#define DISCOUSURE_CALL_IMG_PNG				  @"Discousure-Indicator.png"	
#define ADD_CALL_PNG @"add-cal-wit-text.png"
#define HOLD_CALL_PNG @"hold-wit-text.png"
#define SWAP_CALL_IMG_PNG  @"Swap-Calls.png"
#define MERGE_CALL_IMG_PNG  @"Merge-Calls.png"


//Sound Files
#define _TONE_FILE_TYPE_ @"wav"
#define _TONE_ONLINE_ @""
#define _TONE_CALL_END_ @""
#define _TONE_PHONE_ @"ringtone"
#define _TONE_FILE_TYPE_C_ "wav"
#define _TONE_PHONE_C_ "ringtone"
#endif
