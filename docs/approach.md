# Approach

Purpose: outlines my overall approach to conducting this challenge.


The provided evaluation notes (I'll consider them "assessment criteria") need to be met: some (i.e. functionality) are iterative, others (i.e. good habits) are ever-present. The former will be prioritised as shown below.

Iterative:

- Functionality
- Usability
- Application design
- Feedback

Ever-present: (Testing; Simplicity; Code fluency; Good habits)


## Plan

To initially optimise for Functionality, I'll establish an MVP to realise a **Calculator** that meets the functional requirements. 

Upon completing the MVP, I should have a clearer idea about the domain concerns. I'll revisit my [north_star.md](North Star) and evolves the design as appropriate.

The next milestone will look at the non-functional requirements, namely a **CLI** interface and corresponding **Parser** to parse user input into domain objects that can be sent to the **Calculator**. Again, I'll revise the [north_star.md](North Star) upon completion.

A milestone to establish **CLI Presenter** that presents **Calculator Results** will be useful to separate concerns


### Review requirements

- functional, non-functional
- authoriative sources (and how to use them)
- initial thoughts on high level domain concerns

### Application design

- [north_star.md](North Star)
- design will be revised iteratively to avoid the temptation to front-load all discovery

#### Initial thoughts on domain concerns

- **User Input** represents the arguments to run a calculation
- **Parser** can parse User Input into domain objects (defined inputs and a Calculator), and provide Feedback on invalid User Input
- **Calculator** uses defined inputs to perform the calculation and generate a **Result**
- **Presenter** knows how to present a Calculator Result
- **Runner** parses User Input using its Parser to call a Calculator, then presents the Result using a Presenter

### MVP

This implementation will be Testable, and a basic bootstrapper can provide some Usability and Feedback.

The main focus will be the **Calculator** and its associated inputs as domain objects

### Review application design

Expect to have greater insight into the Calculator inputs

  - these are constrained (e.g. minimum deposit $1000; payment frequencies)
  - these are typed inputs (e.g. interest rate is percentage p.a.)

### CLI Runner and Parser

Refactor (or throw away) the MVP bootstrapper in favour of a robust Runner and Parser. 

Targeting improvements to Usability, Application design, Feedback (and non-functional requirements)

### Review application design

See if any further objects have fallen out

### CLI Presenter

This is the anticipated functionally complete milestone. 

### Review implementation and design

An opportunity to review the implementation and consider any adjustments / improvements


## Log


### Review requirements

#### Authoritative sources (and how to use them)

Quick investigation of the online calculator shows:

- it has some features (i.e. income stream) we don't require
- it rounds up to the nearest whole dollar
- it imposes some minimal and maximal bounds (i.e. deposit $1_000 - $1_500_000; interest rate 0% - 15%; deposit term 1 - 5 years; payment frequency is a controlled vocab / enum)


#### Functional requirements

Calculator inputs are domain objects: we can benefit from modelling their characteristics:

- inputs have a type (e.g. **dollar** amount, **time-based** frequency)
- inputs have bounds (e.g. deposit $1_000 - $1_500_000, interest 0% - 15%)
- payment frequency has many options, but they can all be represented by months (i.e. quarterly = 3 months; annually = 12)

#### Non-functional requirements

CLI seems the most straightforward way to go, and can eawsily meet Usability and Feedback concerns.

### Application design

Initial thoughts dumped into [North Star](north_star.md)


#### Initial thoughts on domain concerns

- **User Input** represents the arguments to run a calculation
- **Parser** can parse User Input into domain objects (defined inputs and a Calculator), and provide Feedback on invalid User Input
- **Calculator** uses defined inputs to perform the calculation and generate a **Result**
- **Presenter** knows how to present a Calculator Result
- **Runner** parses User Input using its Parser to call a Calculator, then presents the Result using a Presenter

### MVP

MVP established `10bb134`

- tricky to work between different time periods (e.g. 12 months = 1 year)
- the base calculator works in year period (interest is p.a.; compounding frequency is p.a.)
- presenting the required result loses some precision: a presenter can deal with this, and the calculator (and results) can retain precision 

### ~~Review application design~~ Next steps

`git log` indicates ~40 minutes was spent on the MVP. Allowing the same for planing leaves 40 minutes of the 2 hour time limit.

**PIVOT** In the interest of Simplicity and not compromising SRP or Interface Segregation,


- [ ] milestone: rename MVP CLI
  - already knows about the calculator
- [ ] milestone: implement noop Input Parser, Validator and Transformer classes specifically for term deposit calculator.
  - this approach introduces some code coupling, but keeps things simple and upholds SOLID principles
  - Input parsing and transformation take user input and derive calculator input from it (CLI responsibility)
  - Input validation ensures calculator input is valid (formula responsibility)
- [ ] milestone: invalid-usage Parser and accompanying help output
  - the help output can be subsequently used for invalid input, i.e. print_help_and_exit(exit_message: str)
  - do not output a Zero-state result (current MVP behaviour)
- [ ] milestone: fully functional Parser, 
  - accepts: user input 
  - parser: arity, to type
- [ ] milestone: functional Validator
    - expects: parsed input of expected type
    - validator: within bounds
- [ ] milestone: functional Transformer
    - expects: validated, parsed input of expected type
    - transformer from what the UI accepts to what the calculator expects
- [ ] milestone: the calculator outcome can be presented


**RISKS**

- we may not finish extracting a result presenter (likelihood: medium; impact: low)
- we may not finish implementing an input transformer (likelihood: medium; impact: high)
