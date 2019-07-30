# Global Variables for Bash

**a small library to provide a form of global variables in a bash shell**

The library can be taken from the `scripts` folder, put in your folder with scripts, and dot-source in your scripts.

```bash
. ./.globals.bash
```

The functions provided:

- `global` is used to set a global variable.  It is used like one uses the `export` statement or the `local` statement in a function.

  ```bash
  global MY_VAR="some value"
  ```

  - The variable is set in the current environment.  
  - The variable is exported in the current environment, so it is available in the environments of all future child-shells.
  - The variable is set in the environments of the chain of parent-shells that used `call` to eventually run this script.
  - The variable is exported in the environments of these parent-shells, so it is available in the environments of all future child-shells of these parent-shells.


- `call` is used to execute a script, pickup all global variables set by that script and its `call`-ed child-scripts, and inject these global variables in the current environment.

  ```bash
  call ./my-script
  ```

  - `call` uses `bash` to execute the script
  - The exitcode of the executed script is returned in `$?`
  - A global variable `$LASTEXITCODE` is set to the `$?` value of the last `call`-ed script
  - A global variable `$GLOBALS_INJECT` is reserved to communicate the dynamically created filedescriptor of the inject-stream between calling and called scripts.  This inject-stream is used to send the required information to set global variables, from the called script back to the calling script.  This inject-stream is only open for as long as the called script is running.


## Example

Let's make three scripts

- `test-globals-1.bash` calls `test-globals-2.bash`

  ```bash
  . ./.globals.bash
  
  echo "### test-globals-1.bash"
  echo ""

  call ./test-globals-2.bash

  echo "\$?=$?"
  echo ""

  echo "### test-globals-1.bash"
  echo "\$LASTEXITCODE=$LASTEXITCODE"
  echo "\$MY_VAR=$MY_VAR"
  echo "###"
  echo ""
  ```

- `test-globals-2.bash` calls `test-globals-3.bash`

  ```bash
  . ./.globals.bash
  
  echo "### test-globals-2.bash"
  echo ""

  call ./test-globals-3.bash

  echo "\$?=$?"
  echo ""

  echo "### test-globals-2.bash"
  echo "\$LASTEXITCODE=$LASTEXITCODE"
  echo "\$MY_VAR=$MY_VAR"
  echo "###"
  echo ""

  exit $LASTEXITCODE
  ```

- `test-globals-3.bash` set a global variable

  ```bash
  . ./.globals.bash
  
  echo "### test-globals-3.bash"
  echo ""

  global MY_VAR="some value"

  echo "### test-globals-3.bash"
  echo "\$LASTEXITCODE=$LASTEXITCODE"
  echo "\$MY_VAR=$MY_VAR"
  echo "###"
  echo ""

  exit 42
  ```

Now run

```bash
./test-globals-1.bash
```

The result is:

```bash
### test-globals-1.bash

### test-globals-2.bash

### test-globals-3.bash

### test-globals-3.bash
$LASTEXITCODE=
$MY_VAR=some value
###

$?=42

### test-globals-2.bash
$LASTEXITCODE=42
$MY_VAR=some value
###

$?=42

### test-globals-1.bash
$LASTEXITCODE=42
$MY_VAR=some value
###

```

> :information_source:  
> The scripts folder contains a more elaborate version of the above scripts.

<br>

## For Further Investigation

- use the same techniques to return results to the caller of a script
