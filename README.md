1. Install `gum`
```bash
brew install gum
```

# Gum Commands Used

- **`gum choose`**: Prompts the user to select from a predefined list (used for selecting the instance class).
- **`gum filter`**: Provides an interactive, type-to-search (fuzzy matching) list selector (used for choosing AWS regions).
- **`gum table`**: Renders structured data beautifully as an ASCII table in the terminal (used to present the final specifications).

# Output of script

```bash
╭────────────────────────────┬─────────────────╮
│ Metric                     │ Specification   │
├────────────────────────────┼─────────────────┤
│ Instance Type              │ t3.nano         │
│ Region                     │ us-east-1       │
│ vCPUs                      │ 2               │
│ Memory                     │ 0.5 GB          │
│ Architecture               │ x86_64          │
│ Network Performance        │ Up to 5 Gigabit │
│ Max ENIs                   │ 2               │
│ IPs per ENI                │ 2               │
│ Hourly Cost (On-Demand)    │ $0.0052         │
│ Monthly Cost (Est. * 730h) │ $3.80           │
╰────────────────────────────┴─────────────────╯
```
