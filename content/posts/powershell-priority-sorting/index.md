---
title: "PowerShell Priority Sorting: A Multi-Key Approach"
date: 2025-07-31T18:30:00+01:00
draft: false
tags: ["PowerShell", "Sorting", "Best Practices", "Scripting", "Calculated Properties", "Sort-Object", "Automation"]
featured_image: "hero.png"
ai_generated_image: true
ai_tool: "Google Pixel Studio (Imagen 3)"
ai_prompt: "A simple stack of brightly coloured boxes. The stack goes from large to small. The background is darker and simple with some small visual elements."
description: "Explore PowerShell's calculated properties feature to create custom sorting logic with Sort-Object. This approach lets you combine multiple sorting criteria and control priority ordering beyond simple alphabetical or numerical sorting."
---

When working with data in PowerShell, you'll often need sorting that goes beyond 
simple alphabetical or numerical ordering. This post explores how to use 
**multiple sort keys** with calculated properties to implement sophisticated 
priority-based sorting.

## The Problem

Imagine you have a mixed list of items and you need to prioritize them in a
specific order:

- Certain items should appear first
- Other items should have medium priority
- Everything else comes last

Within each priority group, you still want consistent ordering (such as
alphabetical).

## The Solution

Here's the technique in action with a simple example. 

```powershell
# Unsorted list of fruits (🥑 are fruits - who knew?)
$Items = @(
    'Cherry'
    'Blueberry'
    'Apple'
    'Apricot'
    'Orange'
    'Avocado'
    'Banana'
)

$Items | Sort-Object {
    if ($_ -like 'B*') {
        # B-items get highest priority
        0 
    } elseif ($_ -like 'O*') {
        # O-items get second priority  
        1
    } else {
        # Everything else gets lowest priority
        2
    }
},{
    # Then sort alphabetically within each group
    $_
}
```

We get the below sorted list; where Banana and Blueberry come first, followed by 
Orange, then everything else sorted alphabetically.

```shell {linenos=false}
Banana
Blueberry
Orange
Apple
Apricot
Avocado
Cherry
```

Here's what's happening: we start with an unsorted list of fruits and pipe them 
to `Sort-Object`, providing two script blocks that each define a sorting 
property.

The magic ✨ is in those script blocks - they let you create sorting criteria 
on-the-fly rather than being stuck with whatever properties your objects 
already have. This technique is called **Calculated Properties**.

## Calculated Properties

**Calculated Properties** are a neat PowerShell feature that let you create 
custom properties on-the-fly without touching the original object. While 
they're super handy for sorting, you'll find this same pattern in other places 
too - [you've probably used it in `Select-Object`](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object#example-12-create-calculated-properties-for-each-inputobject) 
already.

Our fruit example above used the shorthand syntax (just script blocks), but 
there's also a more explicit hashtable approach that gives you finer control. 
With hashtables, you use `Expression` and `Descending` keys to define exactly 
how each sort should work.

Here's what our fruit example looks like with the full syntax:

```powershell
# Unsorted list of fruits
$Items = @(
    'Cherry'
    'Blueberry'
    'Apple'
    'Apricot'
    'Orange'
    'Avocado'
    'Banana'
)

$Items | Sort-Object @{
    Expression = {
        if ($_ -like 'B*') {
            # B-items get highest priority
            0 
        } elseif ($_ -like 'O*') {
            # O-items get second priority  
            1
        } else {
            # Everything else gets lowest priority
            2
        }
    }
    Descending = $false
},@{
    # Then sort alphabetically within each group
    Expression = { $_ }
    Descending = $false
}
```

## Real-World Application

Consider a practical scenario: managing some operation across different 
environments for a long list of servers. Your naming convention *should* be
`{Environment}-{5-digit-number}`, but we live in the real world where things 
get messy. (Because when has a naming convention ever survived contact with 
reality? 🤷‍♂️)

```powershell
$Servers = @(
    'PRD-9487'   # Only 4 digits
    'DC-00001'
    'DC-A2003'   # Has a leading 'A'
    'PRD-00123'
    'STG-00001'
    'STG-000020' # Has 6 digits
    'DEV-00001'
    'PRD-10785'
    'DC-02013'
    'DEV-00002'
    'PRD-00829'
    'EXC-02016'
    'SQL-12233'
)
```

You need to establish an execution order for operations across these servers. 
Rather than manually maintaining lists that become outdated as servers are 
provisioned and decommissioned, you can use multi-key sorting to establish 
consistent, automatic prioritization.

### Identifier Sort

Being good IT professionals, we'll prioritize development environments 
for testing, then staging, then production, before addressing other 
infrastructure servers.

We define our calculated property based on the server name prefix:

```powershell
$Servers | Sort-Object {
    switch -Regex ($_) {
        '^DEV-' { 0; break }
        '^STG-' { 1; break }
        '^PRD-' { 2; break }
        default { 3 }
    }
}, { $_ }
```

> **Note:** We've used a `switch` and `regex` in this `scriptblock`, there's
> nothing special about the `if` statement in the earlier examples.

This produces our expected result:

```shell {linenos=false}
DEV-00001
DEV-00002
STG-00001
STG-000020
PRD-00123
PRD-00829
PRD-10785
PRD-9487
DC-00001
DC-02013
DC-A2003
EXC-02016
SQL-12233
```

### Number Cleanup

The next challenge addresses inconsistent naming conventions. Notice that 
`PRD-9487` appears after `PRD-10785` because we're sorting alphanumerically 
rather than numerically. (Computers are very literal about these things! 📝)

To address this, we'll extract the numeric portion after the dash and convert it 
to an integer for proper numerical sorting:

```powershell
$Servers | Sort-Object {
    switch -Regex ($_) {
        '^DEV-' { 0; break }
        '^STG-' { 1; break }
        '^PRD-' { 2; break }
        default { 3 }
    }
},
{ $_ -replace '.*?-.*?(\d+)', '$1' -as [int] }
```

> **Regex Note:** It starts by matching any characters (`.*?`) using non-greedy 
> matching (the `?` makes it stop as soon as possible) until it hits a dash
> (`-`). Then it continues matching any characters after the dash (`.*?`) until
> it finds a group of consecutive digits (`\d+`), which it captures in
> parentheses. The key insight is that the non-greedy matching lets it skip over
> unwanted characters - so for `DC-A2003`, it matches `"DC-"`, then skips the
> `"A"`, and captures `"2003"` in the parentheses group that you can extract
> with `$1`.

This gives us sorting by identifier first, then by numeric value in ascending 
order.

### Number Sorting

Using the hashtable syntax, we can control the sorting direction for each 
calculated property:

```powershell
$Servers | Sort-Object @{
    Expression = {
        switch -Regex ($_) {
            '^DEV-' { 0; break }
            '^STG-' { 1; break }
            '^PRD-' { 2; break }
            default { 3 }
        }
    }
    Descending = $false
}, @{
    Expression = {
        $_ -replace '.*?-.*?(\d+)', '$1' -as [int]
    }
    Descending = $true
}
```

This produces our final result: servers sorted first by environment priority 
(development, staging, production), then by server number in descending order 
within each environment:

```shell {linenos=false}
DEV-00002
DEV-00001
STG-000020
STG-00001
PRD-10785
PRD-9487
PRD-00829
PRD-00123
SQL-12233
EXC-02016
DC-02013
DC-A2003
DC-00001
```

This approach provides considerable flexibility for complex sorting requirements. 
🎯

## 🥡 Key Takeaways

- **Calculated Properties appear in key cmdlets** - The same hashtable pattern 
  (`Expression`/`Descending`) works in `Select-Object`, `Format-Table`, 
  `Group-Object`, and `Measure-Object` too
- **Script blocks = dynamic properties** - You can create sorting criteria on 
  the fly rather than being limited to existing object properties
- **Multiple sort keys give you control** - Combine priority logic with 
  secondary sorting for sophisticated, predictable results
- **Numeric priorities beat complex logic** - Using 0, 1, 2... is cleaner and 
  more maintainable than nested conditions
- **Hashtable syntax unlocks mixed sorting** - Control ascending/descending 
  direction independently for each sort criterion

This approach transforms messy manual sorting tasks into consistent, automated 
solutions that adapt as your data changes.

## 📖 Reading List

- [`Sort-Object`'s Hashtable Syntax](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/sort-object?example-5-use-a-hash-table-to-sort-properties-in-ascending-and-descending-order) - The main reference page with examples of hashtable syntax

- [Sorting Objects Guide](https://learn.microsoft.com/en-us/powershell/scripting/samples/sorting-objects) - Practical examples including the hashtable approach with Expression and Descending keys

- [Selecting Parts of Objects](https://learn.microsoft.com/en-us/powershell/scripting/samples/selecting-parts-of-objects--select-object-) - Shows practical examples with Label and Expression hashtables

- [`Select-Object`'s Calculated Properties](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object#example-12-create-calculated-properties-for-each-inputobject) - Shows Example 12 with calculated properties using Name/Label and Expression