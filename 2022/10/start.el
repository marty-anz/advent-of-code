;;; start.el --- 2022 10                             -*- lexical-binding: t; -*-

(progn
  (shell-command "aoc download --year 2022 --day 10 --input-file input.txt")
  (find-file-other-window "day.rb")
  (find-file-other-window "puzzle.md"))

(shell-command "ruby day.rb")
