
testBuildfiles() {
	local testdir="$(dirname $BASH_SOURCE)"
	local image="test-$(basename $testdir)"
	for version in $VERSIONS; do
		echo $version
		echo "FROM python-runtime:$version" > "$testdir/Dockerfile"
		docker build -q -t "$image" "$testdir" > /dev/null

		local output="$(docker run --rm $image cat /etc/buildfiles)"
		local expected="$(cat $testdir/expected)"
		assertEquals "/etc/buildfiles content not what was expected" \
			"$expected" "$output"
		
		docker rmi "$image" > /dev/null
	done
}
