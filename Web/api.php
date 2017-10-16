<?php

// Timesheet PHP API
// Created 10/1/2017 by @insanj.
// Copyright 2017 (c) Julian Weiss
//
// SETUP:
// - Upload file to remote directory where resources, assets, and scripts are (does not have to be cgi-bin)
// - Set permissions to (at least) 0555; No one should have write access, everyone should have execute access.
// - Watch for the timesheet.db file, this should also have permissions so only User can read (ex: 0600)
// - Test by loading a query in a web browser, this should work without any other tool needed for GET requests.
//
// CURRENT VERSION:
// 0.1
//

include 'users.php';
include 'logs.php';
include 'friends.php';

// ---
// api
// ---
// check if version exists; this is the bare minimum security, making sure we're on the right version before accessing the API
if (!isset($_POST['v'])) {
	echo 'Unauthorized API request';
	return;
}

$app_version_string = $_POST['v'];
if (doubleval($app_version_string) != 0.1) {
	echo 'Unsupported API version';
	return;
}

if (!isset($_POST['req'])) {
	echo 'Missing required "req" request type parameter';
	return;
}

// TODO: replace with token system?
if (!isset($_POST['email']) || !isset($_POST['password'])) {
	echo 'Unauthenticated API request, "email" or "password" parameter not given';
	return;
}

$user_email = $_POST['email'];
$user_password = $_POST['password'];

$request_type = $_POST['req'];

if (strcmp($request_type, 'register') == 0) {
	echo createAccount($user_email, $user_password);
	return;
}

else if (strcmp($request_type, 'login') == 0) {
	echo authenticate($user_email, $user_password);
	return;
}

$authenticated_user = authenticateForUserID($user_email, $user_password);

if (!$authenticated_user) {
	echo "Unable to log in, try again with a different email and password combination";
	return;
}

// $user_json = json_decode($authenticated_user);
$user_id = $authenticated_user;
if (!$user_id) {
	echo "Logged in, but unable to perform actions for user";
	return;
}

// from here on out, we can assume authenticated user...
if (strcmp($request_type, 'add') == 0) {
	if (!isset($_POST['time_in']) || !isset($_POST['time_out']) || !isset($_POST['notes'])) {
		echo 'Missing required "time_in", "time_out", or "notes"  parameter';
		return;
	}

	$time_in = $_POST['time_in'];
	$time_out = $_POST['time_out'];
	$notes = $_POST['notes'];

	echo addLog($user_id, $time_in, $time_out, $notes);
}

else if (strcmp($request_type, 'history') == 0) {
	echo getLogsFromDatabase($user_id);
}

else if (strcmp($request_type, 'edit') == 0) {
	if (!isset($_POST['log_id']) || !isset($_POST['time_in']) || !isset($_POST['time_out']) || !isset($_POST['notes'])) {
		echo 'Missing required "log_id", "time_in", "time_out", or "notes"  parameter';
		return;
	}

	$log_id = $_POST['log_id'];
	$time_in = $_POST['time_in'];
	$time_out = $_POST['time_out'];
	$notes = $_POST['notes'];

	echo editLog($user_id, $log_id, $time_in, $time_out, $notes);
}

else if (strcmp($request_type, 'delete') == 0) {
	if (!isset($_POST['log_id'])) {
		echo 'Missing required "log_id"  parameter';
		return;
	}

	$log_id = $_POST['log_id'];

	echo deleteLog($user_id, $log_id);
}

else if (strcmp($request_type, 'editUserName') == 0) {
	if (!isset($_POST['user_name'])) {
		echo 'Missing required "user_name" parameter';
		return;
	}

	$user_name = $_POST['user_name'];

	echo editUserName($user_email, $user_name);
}

else if (strcmp($request_type, 'editEmail') == 0) {
	if (!isset($_POST['new_email'])) {
		echo 'Missing required "new_email" parameter';
		return;
	}

	$new_email = $_POST['new_email'];

	echo editEmail($user_email, $new_email);
}

else if (strcmp($request_type, 'editPassword') == 0) {
	if (!isset($_POST['new_password'])) {
		echo 'Missing required "new_password" parameter';
		return;
	}

	$password = $_POST['new_password'];

	echo editPassword($user_email, $password);
}

else if (strcmp($request_type, 'friendRequestsForUser') == 0) {
	echo getPendingFriendRequestsForUser($user_id);
}

else if (strcmp($request_type, 'createFriendRequest') == 0) {
	if (!isset($_POST['friend_user_id'])) {
		echo 'Missing required "friend_user_id" parameter';
		return;
	}

	$friend_user_id = $_POST['friend_user_id'];

	echo createFriendRequestFromUserToUser($user_id, $friend_user_id);
}

else if (strcmp($request_type, 'acceptFriendRequest') == 0) {
	if (!isset($_POST['friend_user_id'])) {
		echo 'Missing required "friend_user_id" parameter';
		return;
	}

	$friend_user_id = $_POST['friend_user_id'];

	echo acceptFriendRequestFromUserToUser($user_id, $friend_user_id);
}

else if (strcmp($request_type, 'deleteFriendRequest') == 0) {
	if (!isset($_POST['friend_user_id'])) {
		echo 'Missing required "friend_user_id" parameter';
		return;
	}

	$receiver_user_id = $_POST['friend_user_id'];

	echo deleteFriendRequestFromUserToUser($user_id, $friend_user_id);
}

else if (strcmp($request_type, 'getAvailableUsers') == 0) {
	echo getAvailableUsersForFriendRequests($user_id);
}

else if (strcmp($request_type, 'getLogsFromFriend') == 0) {
	if (!isset($_POST['friend_user_id'])) {
		echo 'Missing required "friend_user_id" parameter';
		return;
	}

	$friend_user_id = $_POST['friend_user_id'];

	echo getLogsFromFriend($user_id, $friend_user_id);
}

else {
	echo "Unrecognized request type";
}

?>