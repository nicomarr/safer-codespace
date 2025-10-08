# Code Style Preferences

This document outlines the coding style preferences for this project, based on the fastai coding style with specific modifications.

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

**IMPORTANT - Interactive Collaboration:**
- **For complex tasks and debugging**: Work in small batches and **STOP after each major step** to wait for user feedback before proceeding
- **For simple, isolated tasks**: You may complete multiple steps at once if the task is straightforward and has no dependencies
- When in doubt about task complexity, err on the side of waiting for feedback

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
- Balance conciseness with readability
- One line should implement one complete idea
- Optimize for performance and clarity
- Code is read far more often than it is written

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

### Immediate Testing Philosophy
Testing should be integrated naturally into the development process, not as a separate phase:

**1. Test Immediately After Implementation**
- When you implement a function, use it right away in the next cell to verify it works
- Show concrete examples of the function in action
- This creates living documentation and catches issues immediately

**2. Use Assertions Liberally**
- Add `assert` statements throughout the code where assumptions should hold
- Assertions catch bugs immediately at the point of failure
- They serve as executable documentation of invariants
- Examples:
  ```python
  assert len(data) > 0, "Dataset cannot be empty"
  assert 0 <= probability <= 1, f"Probability must be in [0,1], got {probability}"
  ```

**3. Debug and Verbose Parameters**
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

**4. Print Statements for Development**
- Print statements are valuable tools during development
- Show intermediate results, shapes, statistics
- Help build intuition about data and algorithm behavior
- Can be removed or controlled via verbose flags once code stabilizes

**5. No pytest or unittest**
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

### Testing Example in Notebook
```python
# Cell 1: Implementation
def normalize_scores(scores: list[float], verbose: bool = False) -> list[float]:
    """Normalize scores to [0, 1] range.

    Args:
        scores: Raw scores to normalize.
        verbose: If True, print normalization details.

    Returns:
        Normalized scores in [0, 1] range.
    """
    assert len(scores) > 0, "Scores list cannot be empty"

    min_score = min(scores)
    max_score = max(scores)
    range_score = max_score - min_score

    assert range_score >= 0, "Invalid score range"

    if verbose:
        print(f"Score range: [{min_score}, {max_score}]")

    # Handle edge case: all scores are the same
    if range_score == 0:
        return [0.5] * len(scores)

    normalized = [(s - min_score) / range_score for s in scores]

    if verbose:
        print(f"Normalized sample: {normalized[:5]}")

    return normalized

# Cell 2: Immediate testing and demonstration
test_scores = [10, 20, 30, 40, 50]
result = normalize_scores(test_scores, verbose=True)
print(f"Input: {test_scores}")
print(f"Output: {result}")
assert all(0 <= x <= 1 for x in result), "All scores should be in [0, 1]"
assert result[0] == 0.0 and result[-1] == 1.0, "Min should map to 0, max to 1"
print("✓ All checks passed!")
```

## Algorithmic Principles
- Optimize for performance and readability
- Use lazy data structures when appropriate
- Prefer numpy/pytorch broadcasting over loops
- Include references to paper equations when implementing from research
- Validate implementations empirically through immediate testing

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
