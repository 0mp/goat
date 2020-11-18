#! /usr/bin/env atf-sh

set_up() {
	# Install goat into the test directory.
	prefix="$PWD/usr"
	make -C "$(atf_get_srcdir)" PREFIX="$prefix" install

	# Prepare environment.
	goat="${prefix}/bin/goat"
	libgoat="${prefix}/share/goat/libgoat.sh"
	export GOAT_PATH="${PWD}/var/db/goat"

	# Set up some directories.
	mkdir -p 1/2/3
}

atf_test_case goat
goat_head() { atf_set "descr" "Test goat(1)"; }
goat_body() {
	set_up

	# Check that goat can create aliases.
	$goat link l1 1
	$goat link l2 1/2
	atf_check test -L ${GOAT_PATH}/l1
	atf_check -o "match:^${PWD}/1$" readlink ${GOAT_PATH}/l1
}

atf_test_case cd
cd_head() { atf_set "descr" "Test the custom cd(1) command"; }
cd_body() {
	set_up
	$goat link l1 1
	$goat link l2 1/2
	$goat link l3 1/2/3

	# Check that libgoat is sourceable.
	atf_check sh -c ". '$libgoat'"

	# Check that standard cd(1) functionalities still work as expected.
	atf_check -o "match:^$PWD$" sh -e <<-EOF
	. "$libgoat"
	cd "$PWD"
	pwd
EOF
	atf_check -e "match:No such file or directory" -s "not-exit:0" sh -e <<-EOF
	. "$libgoat"
	cd nonexistent
	pwd
EOF

	# Check that cd(1) can follow aliases.
	atf_check -o "match:^$PWD/1$" sh -e <<-EOF
	. "$libgoat"
	cd l1
	pwd
EOF

	# Check that "cd -" works.
	atf_check -o "match:^$PWD/1$" sh -e <<-EOF
	. "$libgoat"
	cd l1
	cd l2
	cd -
	pwd
EOF

	# Check that "cd ." works.
	atf_check -o "match:^$PWD/1$" sh -e <<-EOF
	. "$libgoat"
	cd l1
	cd .
	pwd
EOF
	# Check that "cd .." works.
	atf_check -o "match:^$PWD/1$" sh -e <<-EOF
	. "$libgoat"
	cd l2
	cd ..
	pwd
EOF
	# Check that "cd ..." works.
	atf_check -o "match:^$PWD/1$" sh -e <<-EOF
	. "$libgoat"
	cd l3
	cd ...
	pwd
EOF

	# Check that cd(1) prefers directories in $PWD over aliases.
	atf_check -o "match:^$PWD/l1$" sh -e <<-EOF
	. "$libgoat"
	mkdir l1
	cd l1
	pwd
	cd ..
	rmdir l1
EOF

	# Check that if two or more arguments are passed to cd(1), then aliases
	# are not considered.
	atf_check -o "match:^$PWD/l1$" sh -e <<-EOF
	. "$libgoat"
	mkdir l1
	cd -- l1
	pwd
	cd ..
	rmdir l1
EOF
}

atf_init_test_cases()
{
	atf_add_test_case goat
	atf_add_test_case cd
}
