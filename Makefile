# Test configuration for the Gigafaucet app

# Run all tests
test:
	flutter test

# Run unit tests only
test-unit:
	flutter test test/unit/

# Run widget tests only
test-widget:
	flutter test test/widget/

# Run integration tests only
test-integration:
	flutter test integration_test/

# Run tests with coverage
test-coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html

# Run tests and open coverage report
test-coverage-open: test-coverage
	open coverage/html/index.html

# Clean test artifacts
test-clean:
	flutter clean
	rm -rf coverage/

# Test specific file
test-file:
	flutter test $(FILE)

# Run tests in watch mode (requires flutter_test_runner)
test-watch:
	flutter test --watch

# Run tests with verbose output
test-verbose:
	flutter test --verbose

.PHONY: test test-unit test-widget test-integration test-coverage test-coverage-open test-clean test-file test-watch test-verbose