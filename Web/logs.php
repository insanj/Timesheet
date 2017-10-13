<?php

include_once 'database.php';

// Timesheet PHP API
// Created 10/1/2017 by @insanj.
// Copyright 2017 (c) Julian Weiss
//
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

?>