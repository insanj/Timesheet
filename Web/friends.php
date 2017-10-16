<?php

include_once 'database.php';
include_once 'users.php';

// Timesheet PHP API
// Created 10/1/2017 by @insanj.
// Copyright 2017 (c) Julian Weiss
//
// --
// friend functions
// --
function getPendingFriendRequestsForUser($user_id) {
	if ($database = new TimesheetDatabase()) { 
		$result_array = array();
		$result = $database->query("SELECT * FROM friends WHERE accepted = 0 AND (sender_user_id = '$user_id' OR receiver_user_id = '$user_id') ORDER BY created DESC");
		while ($row = $result->fetchArray()) {
		    $result_array[] = $row;

		    $sender_user_id = $row['sender_user_id'];
		    $row["sender_user"] = userForId($sender_user_id);

		    $receiver_user_id = $row['receiver_user_id'];
		    $row["receiver_user"] = userForId($receiver_user_id);
		}

		$database->close();
		unset($database);
		return json_encode($result_array);
	} else {
		return "Failed to get pending requests from database";
	}
}

function createFriendRequestFromUserToUser($user_id, $friend_user_id) {
	if ($database = new TimesheetDatabase()) {
		$result = $database->query("SELECT * FROM friends WHERE (sender_user_id = '$user_id' AND receiver_user_id = '$friend_user_id') OR (receiver_user_id = '$friend_user_id' AND sender_user_id = '$user_id')");
		if ($result) {
			echo "Friend request already exists";
			return;
		}

		$success = $database->exec("INSERT INTO friends (sender_user_id, receiver_user_id) VALUES ('$user_id', '$friend_user_id')");
		$database->close();
		unset($database);

		return getPendingFriendRequestsForUser($user_id);
	}

	else {
		return "Failed to create request in database";
	}
}

function acceptFriendRequestFromUserToUser($user_id, $friend_user_id) {
	if ($database = new TimesheetDatabase()) { 
		$success = $database->exec("UPDATE friends SET accepted=1 WHERE (sender_user_id = '$user_id' AND receiver_user_id = '$friend_user_id') OR (receiver_user_id = '$user_id' AND sender_user_id = '$friend_user_id')'");
		$database->close();
		unset($database);

		return getPendingFriendRequestsForUser($user_id);
	}

	else {
		return "Failed to accept request database";
	}
}

function deleteFriendRequestFromUserToUser($user_id, $friend_user_id) {
	if ($database = new TimesheetDatabase()) { 
		$success = $database->exec("DELETE FROM friends WHERE (sender_user_id = '$user_id' AND receiver_user_id = '$friend_user_id') OR (receiver_user_id = '$user_id' AND sender_user_id = '$friend_user_id')'");
		$database->close();
		unset($database);

		return getPendingFriendRequestsForUser($user_id);
	}

	else {
		return "Failed to delete timesheet log in database";
	}
}

function getAvailableUsersForFriendRequests($user_id) {
	if ($database = new TimesheetDatabase()) { 
		$result = $database->query("SELECT id,name,email,created FROM users");
		$result_array = array();
		while ($row = $result->fetchArray()) {
		    $result_array[] = $row;
		}

		$database->close();
		unset($database);

		return json_encode($result_array);
	} else {
		return "Unable to connect to database";
	}
}

function getLogsFromFriend($user_id, $friend_user_id) { // TODO: more security
	if ($database = new TimesheetDatabase()) { 
		$securityResult = $database->query("SELECT * FROM friends WHERE accepted = 1 AND (sender_user_id = '$user_id' AND receiver_user_id = '$friend_user_id') OR (receiver_user_id = '$user_id' AND sender_user_id = '$friend_user_id')");
		if (!$securityResult) {
			echo "You need to be friends to get the Timesheet for another user";
			return;
		}

		$result_array = array();
		$result = $database->query("SELECT * FROM logs WHERE user_id = '$friend_user_id' ORDER BY time_out DESC");
		while ($row = $result->fetchArray()) {
		    $result_array[] = $row;
		}

		$database->close();
		unset($database);
		return json_encode($result_array);
	} else {
		return "Failed to get timesheet log entries from database";
	}
}

?>