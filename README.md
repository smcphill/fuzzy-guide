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

### Installation

```bash
git clone <the-project>
cd <the-project>
bundle install
```

### Usage

Toplevel help is minimal. More detail is provided by calculator-specific help

```bash
./bin/ferociacalc -h
Usage: ferociacalc -c term_deposit [options; -h for help]
    -c, --calculator CALCULATOR      Required CALCULATOR to use (currently, only `term_deposit` is available)
./bin/ferociacalc -c term_deposit -h
...
```

Illustrative output:

```bash
./bin/ferociacalc \
  -c term_deposit \
  -d 10000 \
  -i 1.1 \
  -t 36 \
  -p monthly

Final balance: $10,335
Total interest earned: $335.00
```

#### Running tests

```bash
bundle exec rspec -f d
```

Integration tests can be run specifically:

```bash
bundle exec rspec -f d ./spec/term_deposit_integration_spec.rb
```

### Other documents

- The [approach](./docs/approach.md)
- The (evolving) [application design](./docs/north_star.md)
- Developer [notes](./docs/observations.md) I've made during the exercise
