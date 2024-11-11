
func1()
{
  echo ${A_VAR}
  echo $1
  echo $2
  VARS_ARE_GLOBAL="true"
}

A_VAR="asdsds"
func1 a b
echo ${VARS_ARE_GLOBAL}
