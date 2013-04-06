# Pcoder

Pcoder submits local file to AtCoder.
http://atcoder.jp/

## Installation

    $ gem install pcoder

## Naming file rules

    [Contest sub domain]_[task].[expansion]

### Example

Task: http://practice.contest.atcoder.jp/tasks/practice_1

    practice_1.c
    practice_1.cc
    practice_1.cpp
    practice_1.java
    practice_1.pl
    practice_1.php
    practice_1.rb
    practice_1.py
    practice_1.hs

Task: http://arc013.contest.atcoder.jp/tasks/arc013_3

    arc013_3.c
    arc013_3.cc
    arc013_3.cpp
    arc013_3.java
    arc013_3.pl
    arc013_3.php
    arc013_3.rb
    arc013_3.py
    arc013_3.hs

## Usage

    $ pcoder [file...]
    Username:  # Enter Your AtCoder ID.
    Password:  # Enter Your AtCoder Password.
    Successfully uploaded.

## Help

    pcoder [file...]
    -t                  Set contest task name. Example: [ --t practice_1 ]
    --proxy             Set proxy host. Example: [ --proxy proxy.example.com:8080 ]
    -h --help           Display Help.
