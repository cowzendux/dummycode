# dummycode

SPSS Python Extension function to automatically create dummy codes

This function takes a categorical variable (which can be coded as either a numeric or a string variable) and creates a set of dummy codes that can represent that variable in a regression. The highest value is used as a reference group. The names of the dummy codes have the first four characters of the original variable, followed by an underscore, followed by a number. The function also assigns variable and value labels to the dummy codes so they can be interpreted more easily.

This and other SPSS Python Extension functions can be found at http://www.stat-help.com/python.html

## Usage
**dummycode(variable)**
* "variable" is the name of the categorical varaible to be dummy coded.

## Example
**dummycode("race")**
* Assuming race was coded ("White", "Black", "Hispanic", "Other"), the function would create a set of 3 dummy codes (race_1, race_2, race_3) with the following values.
  * race_1 has a value of 1 if race = "Black", but has a value of 0 otherwise
  * race_2 has a value of 1 if race = "Hispanic", but has a value of 0 otherwise
  * race_3 has a value of 1 if race = "Other", but has a value of 0 otherwise
