# TrailMakingTest

__make sure that all related Excel result files are closed during test runs.
Microsoft Office products lock access to files while they are running,
inhibiting the ability of the Trail Making Test to save results__


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
  the last successfully acquired target will result in further errors. However,
  passing through any previously successfully acquired targets does __NOT__
  count as an error.

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


## Output

  Several `.csv` files (i.e., files which are viewable in a spreadsheet program
  such as Microsoft Excel) are generated after completing a Trail Making Test.
  These files are all found within a folder named `logging`, which will be
  automatically generated after the first Trail Making Test run. The logging
  folder contains 3 sub-folders, which will be discussed in detail in the
  following sections. Additionally, results for each user (specified by the
  contents of `username.txt`) will be written to a separate file, differentiated
  by appending the filename with the current username. After running several
  Trail Making Tests with both users Alice and Bob, the `logging` folder will
  resemble the following hierarchy:

    logging
    |
    |-- results
    |  |
    |  |-- results_Alice.csv
    |  |-- results_Bob.csv
    |
    |-- errors
    |  |
    |  |-- errors_Alice.csv
    |  |-- errors_Bob.csv
    |
    |-- rawData
       |
       |-- rawData_Alice.csv
       |-- rawData_Bob.csv


### results

  This folder contains a 'summary' of what we think will be the most useful
  information gathered during each test run. Each row of these files contains the
  following fields:

  - __TOD__: "Time of Day" that test occurred. Represented in 'epoch' format (i.e.,
    milliseconds since 12:00am, Jan. 1st, 1970)
  - __username__: The name of the user conducting the test. Specified in
    `username.txt`
  - __seed__: The numeric value used to 'initialize' the random sequence of
    numbers used to generate target locations. Explicitly setting this number in
    `randomSeed.txt` will create a repeatable version of this test.
  - __Trial #__: A numeric value distinguishing runs for a particular user
    (increments from 1)
  - __Trail A/B Time__: Time required to complete the given trail
  - __Trail A/B Errors__: Number of errors which occurred for the given trail 
  - __Trail A/B Average Time Between Targets__: Calculated by dividing the total
    time by the number of targets
  - __Trail A/B Standard Deviation Between Targets__: Standard deviation of the
    above mentioned average
  - __Trail A/B Path Length__: The 'shortest path' (i.e., straight line) distance
    of a path through all targets. This value can be used to 'normalize' test
    times.

### errors

  This folder contains a description of every error that occurred during test
  runs. Each row of these files contains the following fields:

  - __TOD__: "Time of Day" at which error occurred. Represented in 'epoch' format (i.e.,
    milliseconds since 12:00am, Jan. 1st, 1970)
  - __username__: The name of the user conducting the test. Specified in
    `username.txt`
  - __Trial #__: Test run during which the error occurred. Can be used to
    'match-up' with the corresponding results.csv file.
  - __Trail__: Whether the error occurred on Trail A or B.
  - __Expected Target__: The target that was supposed to be acquired.
  - __Acquired Target__: The target that was actually acquired (resulting in the
    error).

### rawData

  This folder contains the raw timing, error, and distance-between-target
  information which can be used for further data analysis. Each row of these
  files contains the following fields:

  - __TOD__: "Time of Day" at which test occurred. Represented in 'epoch' format
    (i.e., milliseconds since 12:00am, Jan. 1st, 1970)
  - __username__: The name of the user conducting the test. Specified in
    `username.txt`
  - __Trial #__: A numeric value distinguishing runs for a particular user
    (increments from 1)
  - __Trail__: Whether the row represents data collected from Trail A or B.
  - __Time X__: (24 columns) Represents the time required to travel from target
    X to target X+1 (ex: Time 2 represents the time to travel from target 2 to
    target 3)
  - __Errors X__: (24 columns) Represents the number of errors which occurred
    during travel from target X to target X+1 (ex: Errors 2 represents the
    number of errors which occurred during travel from target 2 to target 3)
  - __Distance X__: (24 columns) Represents the 'shortest path' (i.e., straight
    line) distance between target X to target X+1 (ex: Distance 2 represents the
    distance between target 2 and target 3)
