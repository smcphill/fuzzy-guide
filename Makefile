.PHONY: bundle test test-ci integration-test lint fix-lint ci show-help

bundle:
	bundle install

test:
	bundle exec rspec -f d

test-ci:
	bundle exec rspec

integration-test:
	bundle exec rspec -f d ./spec/ferociacalc_integration_test_spec.rb

lint: 
	bundle exec rubocop

fix-lint:
	bundle exec rubocop -A

ci:
	make test-ci && make lint

show-help:
	./bin/ferociacalc -h
