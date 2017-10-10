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

// ---
// database setup, function definitions
// ---
class TimesheetDatabase extends SQLite3 {
    function __construct() {
        $this->open('timesheet.db');
        $this->busyTimeout(10000);

    	$this->exec('CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(250), email varchar(250), password varchar(250), salt TEXT, created TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
    	$this->exec('CREATE TABLE IF NOT EXISTS logs (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, time_in TIMESTAMP, time_out TIMESTAMP, notes TEXT, created TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
    }
}

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

		$result = $database->query("SELECT id,name,email,created FROM users WHERE email = '$escapedEmail' AND password = '$hashedPassword'");
		if (!$result) {
			$database->close();
			return "Incorrect password";
		}

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

function editUserEmail($user_email, $user_password, $user_new_email) {
	if ($database = new TimesheetDatabase()) { 
		$user_id = authenticateForUserID($user_email, $user_password);
		$success = $database->exec("UPDATE users SET email='$user_new_email' WHERE id=$user_id");
		$database->close();
		unset($database);

		return authenticate($user_new_email, $user_password);
	} else {
		return "Unable to connect to database";
	}
}

function editUserPassword($user_email, $user_password, $user_new_password) {
	if ($database = new TimesheetDatabase()) { 
		$user_id = authenticateForUserID($user_email, $user_password);

		$escapedPassword = $database->escapeString($user_new_password);
		$salt = bin2hex(mcrypt_create_iv(32, MCRYPT_DEV_URANDOM));
		$saltedPassword = $escapedPassword . $salt;
		$hashedPassword = hash('sha256', $saltedPassword);

		$success = $database->exec("UPDATE users SET password='$hashedPassword',salt='$salt' WHERE id=$user_id");
		$database->close();
		unset($database);

		return authenticate($user_email, $user_new_password);
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

// --
// log functions
// --
function getLogsFromDatabase($user_id) {
	if ($database = new TimesheetDatabase()) { 
		$result_array = array();
		$result = $database->query("SELECT * FROM logs WHERE user_id = '$user_id' ORDER BY time_out DESC");
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

function addLog($user_id, $time_in, $time_out, $notes) {
	if ($database = new TimesheetDatabase()) { 
		$success = $database->exec("INSERT INTO logs (user_id, time_in, time_out, notes) VALUES ('$user_id', '$time_in', '$time_out', '$notes')");
		$database->close();
		unset($database);

		return getLogsFromDatabase($user_id);
	}

	else {
		return "Failed to add new timesheet log into database";
	}
}

function editLog($user_id, $log_id, $time_in, $time_out, $notes) {
	if ($database = new TimesheetDatabase()) { 
		$success = $database->exec("UPDATE logs SET time_in='$time_in', time_out='$time_out', notes='$notes' WHERE id=$log_id");
		$database->close();
		unset($database);

		return getLogsFromDatabase($user_id);
	}

	else {
		return "Failed to edit timesheet log in database";
	}
}

function deleteLog($user_id, $log_id) {
	if ($database = new TimesheetDatabase()) { 
		$success = $database->exec("DELETE FROM logs WHERE id=$log_id");
		$database->close();
		unset($database);

		return getLogsFromDatabase($user_id);
	}

	else {
		return "Failed to delete timesheet log in database";
	}
}

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

else {
	echo "Unrecognized request type";
}

?>
