# Ferocia Take Home Code Exercise - README

_Steven McPhillips <steven.mcphillips@gmail.com>, July 2025_


## The task

We are a company that creates banking software. We’d like you to build a very simple [term deposit](https://moneysmart.gov.au/saving/term-deposits) calculator.

### Input

A term deposit calculator takes as inputs:

- Start deposit amount (e.g. $10,000)
- Interest rate (e.g. 1.10%)
- Investment term (e.g. 3 years)
- Interest paid (monthly, quarterly, annually, at maturity)

### Output

A term deposit calculator as output:

Final balance (e.g. $10,330 on the above inputs, interest paid at maturity)

### Non-functional requirements

- CLI is fine, although of course if you want to make a simple UI because you think that best demonstrates your skills, please do. We won’t give points to a beautiful UI so ask you to please spend your time on the code and not CSS if you do decide to create a UI.
- We want you to spend at most 2 hours on this as we need a conversation starter and not a fully pro application. Refer to the guide below for what we are looking for, and as long as your solution attempts to address each of these points you should consider yourself done. Please don’t include setup (of computer/environment) time in the 2 hours, we all know how that can blow out.
- Any language is fine, and we recommend you choose your strongest language.
- Please submit using a link to a Github repository. Public is fine, but if this could cause issues for you then you can make it a private repo and we will give you a couple of usernames to invite. If this is also not possible then please let us know and we’ll provide an alternative.
- **At no point should you use an AI coding tool to assist with this challenge. If we think you have done so we will reject your submission.**

### Notes on input and testing

- You can check your outputs using this [calculator](https://www.bendigobank.com.au/calculators/deposit-and-savings/). 
- You can assume that all proceeds are reinvested into the term deposit for its duration.
- There are all kinds of compound interest equations out there. The ones that take year and month as arguments tend to be a lot more confusing than those that just take a single time input (e.g. month OR year, not both).

### Notes on exercise evaluation

- Usability - can we work out how to install and run it?
- Testing - have you written tests and do they pass?
- Functionality - does the program work as expected?
- Application design - is there clear separation of concerns?
- Simplicity - can we understand your code and how you’ve structured it?
- Feedback - how have you handled errors and let the user know?
- Code fluency - how proficient are you at the technologies you’ve chosen?
- Good habits - do you create small, frequent commits with descriptive messages?

## The submission

I've chosen Ruby for this exercise: it's been a while since I've written Ruby regularly, but I have more experience overall than more recent languages (Python, Golang, Java), and feel sufficiently comfortable in doing so.

I've selected [asdf](https://github.com/asdf-vm/asdf) for Ruby version management - it's similar to [rbenv](https://github.com/rbenv/rbenv) but caters for other languages as well. I've developed against MRI Ruby 3.3.8.

### Update

My initial submission was based on work directly commited to main. This update merges an alternate reality by way of a redo, or do-over: I've gone back to the MVP milestone and started again. See https://github.com/smcphill/fuzzy-guide/pull/4 for more.

### Installation

```bash
git clone <the-project>
cd <the-project>
bundle install
```

### Usage via Makefile

- `make test`: run full test suite (unit + integration)
- `make integration-test`: run integration test suite
- `make lint`: run rubocop
- `make fix-lint`: run rubocop in autocorrect mode
- `make ci`: runs quieter variants of `make test && make lint`
- `make show-help`: displays usage information for the supplied term deposit calculator

### Direct usage

Usage is always displayed

```bash
$ ./bin/ferociacalc -h
Usage: ferociacalc <initial> <rate_pa> <term_in_months> <compounding_frequency_per_year>
Where:
<initial>
	initial deposit in $ e.g. 1000 for $1000
<rate_pa>
	percentage p.a. e.g. 3.5 for 3.5%
<term_in_months>
	months for the deposit term e.g. 12 for 1 year
<compounding_frequency_per_year>
	one of [monthly, quarterly, annually, maturity]

Exiting (check usage)
```

Illustrative output:

```bash
$ ./bin/ferociacalc 1000 3.5 12 monthly
Usage: ferociacalc <initial> <rate_pa> <term_in_months> <compounding_frequency_per_year>
Where:
<initial>
	initial deposit in $ e.g. 1000 for $1000
<rate_pa>
	percentage p.a. e.g. 3.5 for 3.5%
<term_in_months>
	months for the deposit term e.g. 12 for 1 year
<compounding_frequency_per_year>
	one of [monthly, quarterly, annually, maturity]

Given:
Initial deposit =$1000.00;
Interest rate =3.5% per annum;
Deposit term =12 months;
Frequency =monthly times per annum (at maturity, there are 0 times per annum).)

    Final balance: $1036.00
    Total interest earned:  $36.00
```

#### Running tests

```bash
bundle exec rspec -f d
```

Integration tests can be run specifically:

```bash
bundle exec rspec -f d ./spec/ferociacalc_integration_test_spec.rb
```

### Other documents

- The planned [approach](./docs/approach.md) and a log of realised progress
- The (evolving) [application design](./docs/north_star.md)

### Final thoughts

Some final thoughts to be committed at the end of work.

I've gone over my allotted time by ~30 minutes, and all told it's been a very enjoyable and novel experience as I haven't been given a "do this and get back once it's done" task for many years, but it feels good recalling how to do the thing...

There's a lot of refactoring to be done:

- Calculator inputs are probably their own class of domain object: there's a lot of functionality stuffed into those hashes
  - there's good test coverage so refactoring can be done with confidence
- CLI is parser, runner and presenter. Definitely overloaded
  - there's _not_ good test coverage here, but the runner is covered and the presenter is covered by the integration test (option parsing is done by optparse so maybe lack of coverage isn't so bad... hmm)

(These are areas I got to late, and the result isn't always mature)

OptionParser / optarse is a bit unwieldy but it has nice type coercion, and hooks for decent feedback.

All told, I'm reasonably happy with Functionality, Usability, Feedback, and Application Design.

There are definitely some non-Simplistic and non-Fluent aspects to parts of my submission. Testing is good in some areas, absent in others (where there is a lack of Simplicity).

I'm out of practice employing Good habits, but the muscle memory is returning.
