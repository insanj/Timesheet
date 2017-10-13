<?php

include_once 'database.php';

// Timesheet PHP API
// Created 10/1/2017 by @insanj.
// Copyright 2017 (c) Julian Weiss
//
// --
// user functions
// --
function createAccount($user_email, $user_password) {
	if ($database = new TimesheetDatabase()) { 
		$escapedEmail = $database->escapeString($user_email);

		$result = $database->querySingle("SELECT salt FROM users WHERE email = '$escapedEmail'");
		if ($result) {
			$database->close();
			return "User already found in database with that email";
		}

		$escapedPassword = $database->escapeString($user_password);

		$salt = bin2hex(mcrypt_create_iv(32, MCRYPT_DEV_URANDOM));
		$saltedPassword =  $escapedPassword . $salt;
		$hashedPassword = hash('sha256', $saltedPassword);

		$result = $database->query("INSERT INTO users (email, password, salt) VALUES ('$escapedEmail', '$hashedPassword', '$salt')");
		$database->close();
		unset($database);

		return authenticate($user_email, $user_password);
	} else {
		return "Failed to get timesheet log entries from database";
	}
}

function authenticate($user_email, $user_password) {
	if ($database = new TimesheetDatabase()) { 
		$escapedEmail = $database->escapeString($user_email);

		$result = $database->querySingle("SELECT salt FROM users WHERE email = '$escapedEmail'");
		if (!$result) {
			$database->close();
			return "No user found in database with that email";
		}

		$salt = $result;

		$escapedPassword = $database->escapeString($user_password);
		$saltedPassword =  $escapedPassword . $salt;

		$hashedPassword = hash('sha256', $saltedPassword);

		$userResult = $database->query("SELECT id,name,email,created FROM users WHERE email = '$escapedEmail' AND password = '$hashedPassword'");
		if (!$userResult) {
			$database->close();
			return "Incorrect password";
		}

		$result_array = array();
		while ($row = $userResult->fetchArray()) {
		    $result_array[] = $row;
		}

		$database->close();
		unset($database);

		if (!$result_array || count($result_array) <= 0) {
			return "Incorrect password, please try again";
		}

		return json_encode($result_array);
	} else {
		return "Unable to connect to database";
	}
}

function authenticateForUserID($user_email, $user_password) {
	if ($database = new TimesheetDatabase()) { 
		$escapedEmail = $database->escapeString($user_email);

		$result = $database->querySingle("SELECT salt FROM users WHERE email = '$escapedEmail'");
		if (!$result) {
			$database->close();
			return "No user found in database with that email";
		}

		$salt = $result;

		$escapedPassword = $database->escapeString($user_password);
		$saltedPassword =  $escapedPassword . $salt;

		$hashedPassword = hash('sha256', $saltedPassword);

		$result = $database->querySingle("SELECT id FROM users WHERE email = '$escapedEmail' AND password = '$hashedPassword'");
		if (!$result) {
			$database->close();
			return "Incorrect password";
		}

		$database->close();
		unset($database);

		return $result;
	} else {
		return "Unable to connect to database";
	}
}

function userForEmail($user_email) {
	if ($database = new TimesheetDatabase()) { 
		$result = $database->query("SELECT id,name,email,created FROM users WHERE email='$user_email'");
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

function editUserName($user_email, $user_name) {
	if ($database = new TimesheetDatabase()) { 
		$escapedName = $database->escapeString($user_name);
		$database->exec("UPDATE users SET name='$escapedName' WHERE email='$user_email'");
		$database->close();
		unset($database);

		return userForEmail($user_email);
	} else {
		return "Unable to connect to database";
	}
}

function editPassword($user_email, $new_password) {
	if ($database = new TimesheetDatabase()) { 
		$escapedPassword = $database->escapeString($new_password);

		$salt = bin2hex(mcrypt_create_iv(32, MCRYPT_DEV_URANDOM));
		$saltedPassword =  $escapedPassword . $salt;
		$hashedPassword = hash('sha256', $saltedPassword);

		$database->exec("UPDATE users SET password='$hashedPassword',salt='$salt' WHERE email='$user_email'");
		$database->close();
		unset($database);

		return userForEmail($user_email);
	} else {
		return "Unable to connect to database";
	}
}

function editEmail($user_email, $new_email) {
	if ($database = new TimesheetDatabase()) { 
		$database->exec("UPDATE users SET email='$new_email' WHERE email='$user_email'");
		$database->close();
		unset($database);

		return userForEmail($new_email);
	} else {
		return "Unable to connect to database";
	}
}

function deleteUser($user_email, $user_password) {
	if ($database = new TimesheetDatabase()) { 
		$user_id = authenticateForUserID($user_email, $user_password);

		$success = $database->exec("DELETE FROM users WHERE id=$user_id");
		$database->close();
		unset($database);

		return $success;
	} else {
		return "Unable to connect to database";
	}
}

?>