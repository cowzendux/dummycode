* Encoding: UTF-8.
* Python function to automatically create dummy codes
* Written by Jamie DeCoster

* This program assumes that you're using values in the output (rather than labels),
* or that your output labels are each uniquely associated with a single value

**********
* Version History
**********
* 2011-12-14 created
* 2012-07-06 Fixed an error when a numeric variable had decimals
   Added variable and value labels to dummy codes
   Had dummycodes start numbering at 1
* 2012-09-07 Fixed an error with string variables
* 2019-03-21 Added option to produce all dummy codes (instead of n-1)

set printback=off.
begin program python.
import spss, spssaux

def getVariableIndex(variable):
   	for t in range(spss.GetVariableCount()):
      if (variable.upper() == spss.GetVariableName(t).upper()):
         return(t)

def dummycode(variable, refCode = False):

##########
# Obtain a list of all the possible values
##########

# Use the OMS to pull the values from the frequencies command
   submitstring = """SET Tnumbers=values.

OMS SELECT TABLES
/IF COMMANDs=['Frequencies'] SUBTYPES=['Frequencies']
/DESTINATION FORMAT=OXML XMLWORKSPACE='freq_table'.
FREQUENCIES VARIABLES=%s.
OMSEND.

SET Tnumbers=Labels.""" %(variable)
   spss.Submit(submitstring)
 
   handle='freq_table'
   context="/outputTree"
#get rows that are totals by looking for varName attribute
#use the group element to skip split file category text attributes
   xpath="//group/category[@varName]/@text"
   values=spss.EvaluateXPath(handle,context,xpath)

# If the original variable was numeric, convert the list to numbers

   varnum=getVariableIndex(variable)
   values2 = []
   values3 = []
   if (spss.GetVariableType(varnum) == 0):
      for t in range(len(values)):
         values2.append(int(float(values[t])))
         values3.append(int(float(values[t])))
   else:
      for t in range(len(values)):
         values2.append("'" + values[t] + "'")
         values3.append(values[t])

############
# Create a set of dummy codes
# Uses the first 4 letters of the variable + _ + an integer
# Last category is reference group
############

   stem = variable[0:4] + "_"
   
   ncodes = len(values)-1
   if (refCode == True):
      ncodes = len(values)
   for t in range(ncodes):
      dummyname = stem+str(t+1)
      submitstring = """numeric %s (f8.0).
do if (%s = %s).
+   compute %s = 1.
else.
+   compute %s = 0.
end if.
if (missing(%s)) %s = $sysmis.
variable labels %s 'Dummy code for %s'.
value labels %s 1 '%s = %s' 0 '%s not %s'.""" %(dummyname, variable, values2[t], 
   dummyname, dummyname, variable, dummyname, dummyname, values3[t],
   dummyname, variable, values3[t], variable, values3[t])
      print submitstring
      spss.Submit(submitstring)

   submitstring = "execute."
   print submitstring
   spss.Submit(submitstring)

end program python.
set printback=on.
