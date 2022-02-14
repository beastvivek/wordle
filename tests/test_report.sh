TEST_RESULTS=()
TEST_DESCRIPTIONS=()
EXPECTED_RESULTS=()
ACTUAL_RESULTS=()
PASS_SIGN="\033[0;32m✔\033[0m"
FAIL_SIGN="\033[0;31m✗\033[0m"

function test_heading() {
    local function_name=$1
    local bold="\033[1m"
    local normal="\033[0m"
    echo
    echo -e "${bold}${function_name}${normal}"
}

function assert_expectation() {
	local expected=$1
	local actual=$2
	local test_description=$3
	local test_result=$FAIL_SIGN
	local index

	if [[ "$actual" == "$expected" ]]
	then
		test_result=$PASS_SIGN
	fi

	index=${#TEST_RESULTS[@]}
	TEST_RESULTS[$index]="$test_result"
	TEST_DESCRIPTIONS[$index]="$test_description"
	EXPECTED_RESULTS[$index]="$expected"
	ACTUAL_RESULTS[$index]="$actual"

	echo -e "\t$test_result ${test_description}"
}

function display_test_report() {
	local total_tests=${#TEST_RESULTS[@]}
	local failed_tests=0
	for result in ${TEST_RESULTS[@]}
	do
		if [[ "$result" == "$FAIL_SIGN" ]]
		then
			failed_tests=$(( $failed_tests + 1 ))
		fi
	done
	echo -e "\nFailed tests: ${failed_tests}/${total_tests}"
}

function display_failed_tests() {
	local index=0

	while [[ $index -le ${#TEST_RESULTS[@]} ]]
	do
		if [[ "${TEST_RESULTS[$index]}" == "$FAIL_SIGN" ]]
		then
			echo -e "\n"
			echo -e "${TEST_RESULTS[$index]} ${TEST_DESCRIPTIONS[$index]}"
			echo -e "Expected : \n${EXPECTED_RESULTS[$index]}"
			echo -e "Actual : \n${ACTUAL_RESULTS[$index]}"
		fi
		index=$(( $index + 1 ))
	done
}
