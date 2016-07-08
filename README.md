# TrailMakingTest


## Description

  Completing the Trail Making Test involves creating a 'trail' with the mouse
  cursor by acquiring (i.e., hovering over or clicking, depending on the mode) a
  series of targets in order. During the test, two separate trails are
  presented:

  - __Trail A:__ 25 targets ordered with ascending numbers (1, 2, 3, 4, ...)
  - __Trail B:__ 25 targets ordered with alternating number/letter pairs (1, 'A', 2, 'B', 3, 'C', ...)

  The objective of the test is to create each trail as quickly and accurately as
  possible. A timer begins _after_ the first target is acquired in each trail,
  and stops once the final target is acquired. Errors occur when an incorrect
  target is acquired. The details of how errors are counted is discussed in the
  section __Errors__ below.

  There are 2 different testing modes in this version of the Trail Making Test:
  _Hover_ and _Click and Drag_. The differences between these modes is discussed
  below.

### Hover Mode

  In _Hover_ mode, targets are acquired by simply hovering over the target with
  the mouse cursor. The current 'trail' follows the mouse as it moves across the
  screen. When an error occurs, the participant must return to the last
  successfully acquired target before continuing.

### Click and Drag Mode

  In _Click and Drag_ mode, targets can only be acquired when the __left mouse
  button__ is depressed (i.e., clicked and held down). To start the trail, the
  participant must click within the boundaries of the first target. The trail
  will follow the mouse cursor as long as the __left mouse button__ is
  depressed. If the __left mouse button__ is released at any point throughout
  the trail, the participant must return to and click within the last
  successfully acquired target before continuing.


## Errors

  Errors occur when the incorrect 'next' target is acquired. For example, moving
  directly from target 1 to target 3 results in an error. When an error occurs
  the participant must return to the last successfully acquired target before
  continuing. Any subsequent acquistion of incorrect targets before returning to
  the last successfully acquired target will result in further errors. 

  Additionally, in the _Click and Drag_ mode, if the participant releases the
  __left mouse button__ at any point during the trail, they must return to the
  last successfully acquired target. However, this is __NOT__ counted as an
  error.


## Settings

### username

  The username can be adjusted by modifying the contents of the `username.txt`
  file. All logfiles are named using the current username as a suffix (for
  example, with the username Bill, results appear in the `results_Bill.csv`
  file. Additionally, the username appears as an entry in each row of the
  results.

  When the file `username.txt` is not present, the username falls back to the
  default value `""` (a literal empty string) in an attempt to allow testing to
  continue. However, the username (displayed in the lower-left corner of the
  screen) will be displayed in __RED__ to alert the participant of the absence
  of a username.

### random seed

  Repeatable tests can be created by manually specifying a seed value for the
  random number generator used to select target locations. A seed can be
  specified in the file `randomSeed.txt` in a valid numeric, integer format
  (i.e, all digits, no decimal point, no spaces).

  The seed value is assigned a default value (the current system time in
  milliseconds) when:

  - the file `randomSeed.txt` does not exist
  - the file `randomSeed.txt` does not contain a valid numeric, integer format
