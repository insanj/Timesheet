<?php

// Timesheet PHP API
// Created 10/1/2017 by @insanj.
// Copyright 2017 (c) Julian Weiss
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
    	$this->exec('CREATE TABLE IF NOT EXISTS friends (id INTEGER PRIMARY KEY AUTOINCREMENT, sender_user_id INTEGER, receiver_user_id TIMESTAMP, accepted INT DEFAULT 0, created TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
    }
}

?>