# Git Repository System - Starter Code

## Development Scenario

Your teammate has been working on a simplified Git-like repository system but just left for a two-week vacation. They’ve implemented the **core functionality across three classes** — `Author`, `Commit`, and `Repository`. The code runs, but there are no tests yet.

Your manager wants to keep the project moving while your teammate is away, so they’ve asked you to write **comprehensive tests for all the existing code**. This will provide a solid testing foundation and help catch issues before your teammate returns to expand the system.

The current implementation covers the minimum Git-style operations: creating commits, moving between branches, and keeping a simple commit history. Future work will add more realism (e.g., file trees, rebasing, merging), but for now the focus is on **testing what already exists**.

## Classes

This is a teaching/learning tool. **It is not how real Git works.** Real Git uses object databases, trees, and more complex algorithms. Here, the design is intentionally minimal.

### Author

- Represents a developer who makes commits  
- Validates that name and email are provided and that the email is correctly formatted  

### Commit

- Represents a single commit  
- Tracks:
    - a unique **12-character SHA-1–based ID**  
    - commit message  
    - author  
    - timestamp  
    - parent commit (or `nil` for the first commit)  
- Validates commit data on creation  

### Repository

- Represents a Git repository  
- Starts with a single branch, **`main`**  
- Can create new branches (each branch points to a commit)  
- Can check out (switch) between branches  
- Can create new commits on the current branch  
- Stores and looks up commits by ID  
- Provides a simple log of commit history by following parent pointers  

## Notes

- Commits **do not store file changes** in this version — only metadata and parent links.  
- Authors **do not track their commits** directly. Commits hold a reference to their `Author`.  
- Branches are represented as names pointing to the latest commit ID.  
- The system enforces only the most basic validations.  

Your task: **write tests that confirm all validations, attributes, and repository operations behave as expected.**
