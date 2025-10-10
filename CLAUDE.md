# Development Philosophy and Coding Standards

This document outlines our approach to software development: combining literate programming, test-driven development, MVP-first methodology, and exploratory programming in Jupyter notebooks—along with specific code style preferences.

Based on the fastai coding style with significant extensions for modern development practices.

## Philosophical Foundations

### Literate Programming
This project embraces **Literate Programming**, a paradigm introduced by Donald Knuth where programs are written as literature meant to be read by humans first. The core principle:

> "Let us change our traditional attitude to the construction of programs: Instead of imagining that our main task is to instruct a computer what to do, let us concentrate rather on explaining to human beings what we want a computer to do." — Donald Knuth

Code should tell a story. Write programs that explain your logic in natural language (through docstrings and comments), with code woven throughout as the executable specification of your ideas.

### The Zen of Python
We embrace the wisdom of Tim Peters' "Zen of Python" (PEP 20):

```
Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

Key takeaways for our code:
- **Readability counts** — Our naming conventions and documentation requirements directly support this
- **Explicit is better than implicit** — Type hints and clear naming make intentions obvious
- **Simple is better than complex** — Inspired by fastai: brevity facilitates reasoning
- **If the implementation is hard to explain, it's a bad idea** — Code should be self-explanatory with proper documentation

### Polya's Problem-Solving Strategy
When approaching any programming problem or implementation task, follow **George Polya's four-step problem-solving process**:

#### 1. Understand the Problem
- **Read the problem carefully**: Ensure you understand all the terms and the problem's requirements
- **Identify what is given and what needs to be found**: Distinguish between the known and unknown variables
- **Restate the problem in your own words**: This helps clarify the problem and ensures you have grasped the main idea
- **Draw a diagram using Mermaid syntax if necessary**: Visual aids can make complex problems more manageable and understandable.
- Ask clarifying questions if anything is unclear

#### 2. Devise a Plan
- **Think of possible strategies**: Consider various approaches, such as:
  - Working backwards from the desired result
  - Looking for patterns in the data or requirements
  - Breaking the problem into smaller, manageable parts
  - Simplifying the problem to solve a special case first
  - Using analogies to similar problems
- **Choose the most promising strategy**: Select the method that seems most likely to lead to a solution
- **Relate the problem to similar problems**: Use insights from previously solved problems that are similar in nature
- Consider data structures, algorithms, and design patterns that might apply

#### 3. Carry Out the Plan
- **Implement the chosen strategy**: Apply the steps of your plan systematically
- **Be thorough and patient**: Carefully execute each step without rushing
- **Keep track of your work**: Document each part of the process through:
  - Clear variable names that reflect their purpose
  - Comments explaining non-obvious decisions
  - Docstrings describing function behavior
  - Print statements or verbose flags for debugging
- **Test as you go**: Verify each component works before moving to the next
- If the plan isn't working, don't be afraid to try a different approach

#### 4. Look Back
- **Review the solution**: Check the results to ensure they make sense and the problem is fully solved
- **Test edge cases**: Verify the solution handles boundary conditions and unusual inputs
- **Reflect on the process**: Consider what worked well and what didn't, which helps improve future problem-solving skills
- **Refactor if needed**: Improve code clarity, performance, or structure based on what you learned
- **Generalize the solution**: Think about how the strategy could be applied to other problems
- **Document insights**: Add comments or documentation about why this approach was chosen

This systematic approach aligns perfectly with literate programming: you're documenting your thought process as you solve the problem, making it easier for others (and future you) to understand not just *what* the code does, but *why* it was written this way.

### Additional Principles

#### Code Quality and Readability
- Balance conciseness with readability
- One line should implement one complete idea
- Code is read far more often than it is written
- Optimize for performance and clarity

#### Algorithmic Implementation
- Optimize for both performance and readability
- Use lazy data structures when appropriate
- Prefer numpy/pytorch broadcasting over loops when working with arrays
- Include references to paper equations when implementing from research
- Validate implementations empirically through immediate testing

## Development Methodology

### MVP-First Approach: The 6-8 Step Rule

**Core Principle:** If you cannot reach a functional Minimum Viable Product (MVP) within 6-8 implementation steps, the scope must be narrowed.

#### What is an MVP?
An MVP is the simplest version of a feature that:
- **Solves the core problem** — Addresses the fundamental user need
- **Can be demonstrated and validated** — Produces tangible, testable output
- **Provides value to the user** — Works end-to-end, even if basic
- **Serves as a foundation for iteration** — Can be enhanced incrementally

#### The 6-8 Step Guideline
Each development task should be achievable in 6-8 discrete steps where each step is:
- **Testable**: Can be validated independently
- **Demonstrable**: Produces observable output
- **Incremental**: Adds clear value to previous step
- **Simple**: Focused on one clear objective

#### When Scope is Too Large
If you find yourself needing more than 8 steps:
1. **Re-examine requirements**: What is the absolute core functionality?
2. **Remove nice-to-haves**: Strip down to essential features only
3. **Defer complexity**: Save advanced features for iteration 2
4. **Split into phases**: Define MVP Phase 1, then plan Phase 2

#### Example: Building a Data Pipeline
❌ **Too Broad** (15+ steps):
- Load data from multiple sources (CSV, JSON, API, database)
- Clean, validate, and transform data with complex rules
- Feature engineering with ML preprocessing
- Store in database with versioning and metadata
- Create interactive dashboard with visualizations
- Add real-time monitoring and alerting
- Implement automatic error recovery and retry logic

✅ **MVP** (6 steps):
1. Load data from single CSV file
2. Basic validation (check for nulls, correct types)
3. Simple transformation (normalize one column)
4. Save to output CSV
5. Print summary statistics
6. Validate output format with assertions

**Then iterate in subsequent phases:**
- Phase 2: Add more data sources
- Phase 3: Add ML preprocessing
- Phase 4: Add database storage
- Phase 5: Add visualization dashboard

### Incremental Development: Small Batches, Continuous Validation

**Principle:** Always work in the simplest way possible. Build incrementally, validate each step.

#### The Small Batch Workflow
1. **Implement the simplest version first**
   - Hard-code before parameterizing
   - Single case before general case
   - Console output before fancy UI
   - Concrete example before abstraction

2. **Validate immediately**
   - Print intermediate values
   - Check outputs manually or with assertions
   - Run the code to see actual results
   - Ensure each step works before moving on

3. **Iterate to add complexity**
   - Add one parameter at a time
   - Extend to handle more cases gradually
   - Refactor and improve incrementally
   - Never add multiple features simultaneously

#### Example: Progressive Enhancement
```python
# Step 1: Simplest version (hard-coded, concrete)
data = [1, 2, 3, 4, 5]
result = [x * 2 for x in data]
print(result)  # Validate: [2, 4, 6, 8, 10] ✓

# Step 2: Make it a function
def double_values(data: list[int]) -> list[int]:
    """Double all values in a list."""
    return [x * 2 for x in data]

assert double_values([1, 2, 3]) == [2, 4, 6]  # Validate ✓

# Step 3: Generalize to any multiplier
def multiply_values(data: list[int], multiplier: int) -> list[int]:
    """Multiply all values by a given multiplier."""
    return [x * multiplier for x in data]

assert multiply_values([1, 2, 3], 3) == [3, 6, 9]  # Validate ✓

# Step 4: Add type flexibility for floats
def multiply_values(data: list[float], multiplier: float) -> list[float]:
    """Multiply all values by a given multiplier.
    
    Args:
        data: List of numbers to multiply.
        multiplier: Factor to multiply by.
        
    Returns:
        List with all values multiplied.
    """
    return [x * multiplier for x in data]

assert multiply_values([1.5, 2.5], 2.0) == [3.0, 5.0]  # Validate ✓
```

**Key Insight:** Each step is complete, testable, and adds value. Never skip validation between steps.

### Interactive Collaboration

**IMPORTANT - The 6-8 Step Rule:**
- Each task should be achievable in **6-8 discrete steps maximum**
- If more steps are needed, **STOP and propose scope reduction**
- Each step should be validated before proceeding to the next
- Present options for narrowing scope to fit within the guideline

**For complex tasks and debugging:**
- Work in small batches and **STOP after each major step** to wait for user feedback
- Present what you've accomplished, validate it works, then ask before continuing
- Never implement more than 2-3 steps ahead without validation
- Show progress incrementally so issues are caught early

**For simple, isolated tasks:**
- You may complete multiple steps at once if the task is:
  - Straightforward with no dependencies
  - Has crystal clear requirements
  - Total scope is under 6 steps
  - No ambiguity about the approach

**When in doubt:**
- Err on the side of waiting for feedback
- Ask if scope should be narrowed
- Propose MVP version first
- Break large tasks into smaller phases

## Python-Specific Preferences

### Type Hints
- **Always use type hints** for function parameters and return values
- Use modern Python type hint syntax (e.g., `list[str]` instead of `List[str]` when possible)
- Include type hints for class attributes

### Documentation
- **Always use Google-style docstrings** for all functions, classes, and methods
- Include:
  - Brief description of purpose
  - Args section with type and description
  - Returns section with type and description
  - Raises section if applicable
  - Examples section when helpful

### Comments
- **Use inline comments liberally** for optimal readability
- Explain the "why" behind non-obvious code decisions
- Comment complex algorithms or business logic
- Exception: Do not add comments if explicitly instructed not to

## Naming Conventions

### General Philosophy
- **Human readable names are required** - prioritize clarity over brevity
- **No single-letter variable names** (except in very limited contexts like loop counters in trivial loops)
- **No abbreviations unless the code becomes too verbose**
- When verbosity becomes an issue, use well-known domain-specific abbreviations

### Specific Guidelines
- Use descriptive names: `image_tensor` instead of `img` or `x`
- Use descriptive names: `index` instead of `i` (unless in a trivial loop)
- Use descriptive names: `object` or specific type name instead of `o`
- Use `key` and `value` instead of `k` and `v`
- Follow standard Python casing:
  - `CamelCase` for classes
  - `snake_case` for functions, methods, and variables
  - `UPPER_CASE` for constants

### Examples
```python
# Preferred
def apply_lighting_transformation(brightness: float, contrast: float) -> Callable:
    """Apply lighting transformation with specified parameters.

    Args:
        brightness: Brightness adjustment factor.
        contrast: Contrast adjustment factor.

    Returns:
        A callable that applies the lighting transformation.
    """
    return lambda image: lighting(image, brightness, contrast)

# Avoid (too terse)
def det_lighting(b, c): return lambda x: lighting(x, b, c)
```

## Code Layout

### Width and Formatting
- Maximum 160 characters per line
- Use ternary operators for concise conditionals
- Align related statements for readability when appropriate

### Example Formatting
```python
# Aligned conditional statements (when it improves readability)
if self.store.stretch_direction == 0:
    transformed = stretch_cv(image, self.store.stretch, 0)
else:
    transformed = stretch_cv(image, 0, self.store.stretch)

# Compact initialization (when variables are related)
self.size, self.denorm, self.norm, self.size_y = size, denorm, normalizer, size_y
```

## Development Environment

### Jupyter Notebooks as Primary Tool
**Jupyter notebooks are our primary development environment.** They perfectly align with literate programming principles by combining:
- Narrative explanations in markdown cells
- Executable code in code cells
- Immediate visual feedback and outputs
- Exploratory, iterative development workflow

All code should be designed to work naturally in notebook environments, supporting interactive development and data analysis.

## Testing and Validation

### Testing Approaches
Testing should be integrated naturally into the development process, not as a separate phase. We support two complementary approaches depending on context:

#### Approach 1: Test-Driven Development (TDD)
**Recommended for:** New features with clear requirements, refactoring existing code, building reusable functions.

Write tests BEFORE implementation following the **Red-Green-Refactor** cycle:

1. **Red**: Write a failing test/example that defines the desired behavior
2. **Green**: Implement the minimum code necessary to make the test pass
3. **Refactor**: Clean up and improve the code while keeping tests passing

**TDD in Notebooks:**
```python
# Cell 1: Define expected behavior with test cases (RED - this will fail)
def test_normalize_scores():
    """Test cases defined BEFORE implementation."""
    # Test normal case
    result = normalize_scores([10, 20, 30])
    assert result == [0.0, 0.5, 1.0], "Should normalize to [0,1] range"
    
    # Test edge case: all equal values
    result = normalize_scores([5, 5, 5])
    assert all(x == 0.5 for x in result), "Equal values should map to 0.5"
    
    # Test edge case: negative values
    result = normalize_scores([-10, 0, 10])
    assert result == [0.0, 0.5, 1.0], "Should work with negative values"

# Running this cell will fail since normalize_scores doesn't exist yet ❌

# Cell 2: NOW implement the function to satisfy the tests (GREEN)
def normalize_scores(scores: list[float]) -> list[float]:
    """Normalize scores to [0, 1] range.
    
    Args:
        scores: List of numeric scores to normalize.
        
    Returns:
        Normalized scores where min maps to 0 and max maps to 1.
    """
    min_score = min(scores)
    max_score = max(scores)
    range_score = max_score - min_score
    
    # Handle edge case: all scores are the same
    if range_score == 0:
        return [0.5] * len(scores)
    
    return [(s - min_score) / range_score for s in scores]

# Cell 3: Run the tests (should pass now) ✓
test_normalize_scores()
print("✓ All tests passed!")

# Cell 4: Refactor if needed (REFACTOR)
# The code is already clean, but we could add type hints, docstrings, etc.
```

**Benefits of TDD:**
- Forces you to think about requirements and edge cases upfront
- Ensures code is testable by design
- Provides immediate feedback when something breaks
- Creates executable documentation of expected behavior
- Catches bugs at the point of introduction

#### Approach 2: Immediate Testing After Implementation
**Recommended for:** Exploratory work, data analysis, unclear requirements, prototyping.

- Implement function based on intuition and domain knowledge
- Test immediately in the next cell to verify it works
- Add assertions to validate assumptions
- Use verbose flags and print statements for debugging
- Iterate based on observed behavior

**Choose TDD when:**
- Requirements are clear and well-defined
- Building new features or utilities
- Refactoring existing code
- Creating reusable components

**Choose immediate testing when:**
- Exploring data or algorithms
- Prototyping with unclear requirements
- Debugging complex issues
- Learning new libraries or techniques

### Core Testing Principles

**1. Use Assertions Liberally**
- Add `assert` statements throughout the code where assumptions should hold
- Assertions catch bugs immediately at the point of failure
- They serve as executable documentation of invariants
- Examples:
  ```python
  assert len(data) > 0, "Dataset cannot be empty"
  assert 0 <= probability <= 1, f"Probability must be in [0,1], got {probability}"
  ```

**2. Debug and Verbose Parameters**
- Include optional `debug=False` or `verbose=False` parameters in functions
- When enabled, print intermediate values and state
- This makes debugging interactive and transparent
- Example:
  ```python
  def process_data(data: list[float], verbose: bool = False) -> list[float]:
      """Process the input data.

      Args:
          data: Input data to process.
          verbose: If True, print intermediate steps for debugging.

      Returns:
          Processed data.
      """
      if verbose:
          print(f"Processing {len(data)} items")

      result = [x * 2 for x in data]

      if verbose:
          print(f"Result sample: {result[:5]}")

      return result
  ```

**3. Print Statements for Development**
- Print statements are valuable tools during development
- Show intermediate results, shapes, statistics
- Help build intuition about data and algorithm behavior
- Can be removed or controlled via verbose flags once code stabilizes

**4. No pytest or unittest**
- Formal testing frameworks like pytest and unittest are **not used**
- They are impractical for:
  - Literate programming workflows
  - Exploratory programming in notebooks
  - Interactive data analysis
- Instead, rely on:
  - Immediate execution and validation in notebook cells
  - Assertions for invariants
  - Examples that demonstrate correctness
  - Visual inspection of outputs

### Example: Immediate Testing in Notebook
```python
# Cell 1: Implementation with assertions and verbose option
def calculate_statistics(data: list[float], verbose: bool = False) -> dict[str, float]:
    """Calculate basic statistics for a dataset.

    Args:
        data: List of numeric values.
        verbose: If True, print intermediate calculations.

    Returns:
        Dictionary with mean, median, and std deviation.
    """
    assert len(data) > 0, "Data cannot be empty"
    
    sorted_data = sorted(data)
    mean = sum(data) / len(data)
    median = sorted_data[len(data) // 2]
    variance = sum((x - mean) ** 2 for x in data) / len(data)
    std_dev = variance ** 0.5
    
    if verbose:
        print(f"Dataset size: {len(data)}")
        print(f"Range: [{min(data)}, {max(data)}]")
    
    return {"mean": mean, "median": median, "std_dev": std_dev}

# Cell 2: Immediate testing and demonstration
test_data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
stats = calculate_statistics(test_data, verbose=True)
print(f"Statistics: {stats}")
assert stats["mean"] == 5.5, "Mean should be 5.5"
assert stats["median"] == 6, "Median should be 6"
print("✓ All checks passed!")
```

## Git Workflow

### Commit Messages: Conventional Commits
**Always use the Conventional Commits specification** for commit messages. This provides a standardized, readable commit history.

#### Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Types
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (whitespace, formatting, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement
- **test**: Adding or modifying tests
- **chore**: Changes to build process, dependencies, or auxiliary tools
- **ci**: Changes to CI configuration files and scripts

#### Examples
```
feat: add normalize_scores function with verbose mode

fix: handle edge case when all scores are identical

docs: add testing philosophy to CLAUDE.md

refactor: improve variable naming in data processing pipeline

chore: update numpy to 2.0.0
```

#### Rules
- Use lowercase for type and description
- Keep description concise (50 chars or less preferred)
- Use imperative mood ("add" not "added" or "adds")
- Include body for non-obvious changes
- Reference issues in footer when applicable

### Branch Management

**Use `git switch` exclusively for branch operations:**

- **Switch to existing branch**: `git switch branch-name`
- **Create and switch to new branch**: `git switch -c new-branch-name`
- **Create new branch from specific commit**: `git switch -c new-branch-name commit-hash`

**NEVER use destructive Git commands:**
- **FORBIDDEN:** `git checkout` - Can overwrite files
- **FORBIDDEN:** `git branch -D` - Deletes branches
- **FORBIDDEN:** `git reset --hard` - Loses uncommitted changes
- **FORBIDDEN:** `git clean -fd` - Deletes untracked files
- **FORBIDDEN:** Any command that can delete branches, logs, or data

**All deletion operations must be performed manually by the user.**

### Git Best Practices
- Keep commits small and focused on a single change
- Write clear, descriptive commit messages following Conventional Commits
- Use `git switch` for all branch switching and creation
- Never force push to main/master branches
- Create feature branches for new work

## Additional Guidelines
- Use latest stable Python and library versions
- Focus on clear, self-documenting code supplemented with comments and docstrings
- Include external document links for complex algorithms
- Avoid automatic formatters that conflict with these preferences
- Keep PRs small and discuss complex changes before implementation
- **Never use emojis** in code, documentation, or any written content unless explicitly requested by the user

## When to Override
These preferences should be followed by default. Override them only when:
- Explicitly instructed to omit type hints, docstrings, or comments
- Working with existing code that uses a different style (match the existing style)
- Performance-critical code where verbosity impacts readability (use judgment)
