# TrailMakingTest


## Settings

### username

  The username can be adjusted by modifying the contents of the `username.txt`
  file. All logfiles are named using the current username as a suffix (for
  example, with the username Bill, results appear in the `results_Bill.csv`
  file. Additionally, the username appears as an entry in each row of the
  results.

  When the file `username.txt` is not present, the username falls back to the
  default value `""` (a literal empty string).

### random seed

  Repeatable tests can be created by manually specifying a seed value for the
  random number generator used to select target locations. A seed can be
  specified in the file `randomSeed.txt` in a valid numeric, integer format
  (i.e, all digits, no decimal point, no spaces).

  The seed value is assigned a default value (the current system time in
  milliseconds) when:
    - the file `randomSeed` does not exist
    - the file `randomSeed` does not contain a valid numeric, integer format
