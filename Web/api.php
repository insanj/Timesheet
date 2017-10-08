<?php

// Timesheet PHP API
// Created 10/1/2017 by @insanj.
// Copyright 2017 (c) Julian Weiss
//
// SETUP:
// - Upload file to remote directory where resources, assets, and scripts are (does not have to be cgi-bin)
// - Set permissions to (at least) 0555; No one should have write access, everyone should have execute access.
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
    	$this->exec('CREATE TABLE IF NOT EXISTS logs (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, time_in TIMESTAMP, time_out TIMESTAMP, notes TEXT, created TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
    }
}

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

// ---
// api
// ---
// check if version exists; this is the bare minimum security, making sure we're on the right version before accessing the API
if (!isset($_GET['v'])) {
	echo 'Unauthorized API request';
	return;
}

$app_version_string = $_GET['v'];
if (doubleval($app_version_string) != 0.1) {
	echo 'Unsupported API version';
	return;
}

if (!isset($_GET['req'])) {
	echo 'Missing required "req" request type parameter';
	return;
}

$request_type = $_GET['req'];
if (strcmp($request_type, 'add') == 0) {
	if (!isset($_GET['user_id']) || !isset($_GET['time_in']) || !isset($_GET['time_out']) || !isset($_GET['notes'])) {
		echo 'Missing required "user_id", "time_in", "time_out", or "notes"  parameter';
		return;
	}

	$user_id = $_GET['user_id'];
	$time_in = $_GET['time_in'];
	$time_out = $_GET['time_out'];
	$notes = $_GET['notes'];

	echo addLog($user_id, $time_in, $time_out, $notes);
}

else if (strcmp($request_type, 'history') == 0) {
    if (!isset($_GET['user_id'])) {
		echo 'Missing required "user_id" parameter';
		return;
	}
	
	$user_id = $_GET['user_id'];

	echo getLogsFromDatabase($user_id);
}

else {
	echo "Unrecognized request type";
}

?>
