(progn
  (shell-command "rm -rf puzzle.md")
  (shell-command "rm -rf input.txt")
  (shell-command "aoc download --year 2022 --day 11 --input-file input.txt")
  (find-file-other-window "day.rb")
  (find-file-other-window "puzzle.md"))

(shell-command "ruby day.rb")
