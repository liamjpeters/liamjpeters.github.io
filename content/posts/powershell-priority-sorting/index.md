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
# Unsorted list of fruits (🥑 are fruit - who knew?)
$items = @(
    'Cherry'
    'Blueberry'
    'Apple'
    'Apricot'
    'Orange'
    'Avocado'
    'Banana'
)

$items | Sort-Object {
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

```txt {linenos=false}
Banana
Blueberry
Orange
Apple
Apricot
Avocado
Cherry
```

We get the above sorted list; where Banana and Blueberry come first, followed by 
Orange, then everything else sorted alphabetically.

Here's what's happening: we start with an unsorted list of fruit and pipe them 
to `Sort-Object`. We provide two script blocks that each define a sorting 
property.

The magic ✨ in those script blocks is that they create custom sorting rules 
on-the-fly. Instead of being limited to existing object properties, you can 
define your own. This technique is called **Calculated Properties**.

## Calculated Properties

**Calculated Properties** are a neat feature that let you create custom
properties on-the-fly without touching the original object. While they're super
handy for sorting, you'll find this same pattern in other places too - [you've
probably used it in `Select-Object`](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object#example-12-create-calculated-properties-for-each-inputobject) 
already.

Our fruit example used the shorthand syntax (just script blocks), but 
there's a more complete hashtable approach that gives you finer-grained control. 
With hashtables, you use `Expression` and `Descending` keys to define exactly 
how each sort should work - including the ability to mix sort directions.

## Real-World Application

Consider a practical IT scenario: you need to perform operations across Active 
Directory domain controllers in different regions. You want to prioritize by 
geographic proximity - London first, then Manchester, then Edinburgh, with 
other regional offices last:

```powershell
# Get all domain controllers from Active Directory
$Domain = Get-ADDomain -Identity 'contoso.co.uk'
$DomainControllers = $Domain.ReplicaDirectoryServers

# Sample domain controllers that might be returned:
@(
    'BRI-DC01.contoso.co.uk'  # Bristol
    'LON-DC01.contoso.co.uk'  # London
    'MAN-DC01.contoso.co.uk'  # Manchester
    'LEE-DC01.contoso.co.uk'  # Leeds
    'BRI-DC02.contoso.co.uk'  # Bristol
    'LON-DC02.contoso.co.uk'  # London
    'BIR-DC01.contoso.co.uk'  # Birmingham
    'BIR-DC02.contoso.co.uk'  # Birmingham
    'BIR-DC03.contoso.co.uk'  # Birmingham
    'EDI-DC01.contoso.co.uk'  # Edinburgh
)
```

### Geographic Priority Sort

Here's how to automatically prioritize them by region:

```powershell
$DomainControllers | Sort-Object {
    switch($_) {
        {$_ -like 'LON*'} { 0; break }  # London gets priority
        {$_ -like 'MAN*'} { 1; break }  # Manchester second
        {$_ -like 'EDI*'} { 2; break }  # Edinburgh third
        default { 3 }                   # Everything else last
    }
}, { $_ }  # Then alphabetically within each region
```

```txt {linenos=false}
LON-DC01.contoso.co.uk
LON-DC02.contoso.co.uk
MAN-DC01.contoso.co.uk
EDI-DC01.contoso.co.uk
BIR-DC01.contoso.co.uk
BIR-DC02.contoso.co.uk
BIR-DC03.contoso.co.uk
BRI-DC01.contoso.co.uk
BRI-DC02.contoso.co.uk
LEE-DC01.contoso.co.uk
```

Notice how London DCs (LON-\*) appear first, followed by Manchester (MAN-\*), 
then Edinburgh (EDI-\*), with all others last - exactly matching our priority 
numbers 0, 1, 2, 3.

### Mixed Sort Directions

The hashtable syntax lets you control the sorting direction for each criterion. 
For example, you might want regions sorted by priority (ascending), but server 
names within each region sorted in reverse alphabetical order (descending):

```powershell
$DomainControllers | Sort-Object @{
    Expression = {
        switch($_) {
            {$_ -like 'LON*'} { 0; break }
            {$_ -like 'MAN*'} { 1; break }
            {$_ -like 'EDI*'} { 2; break }
            default { 3 }
        }
    }
    Descending = $false  # Regions in priority order (ascending)
}, @{
    Expression = { $_ }
    Descending = $true   # Server names in reverse alphabetical order
}
```

```txt {linenos=false}
LON-DC02.contoso.co.uk
LON-DC01.contoso.co.uk
MAN-DC01.contoso.co.uk
EDI-DC01.contoso.co.uk
LEE-DC01.contoso.co.uk
BRI-DC02.contoso.co.uk
BRI-DC01.contoso.co.uk
BIR-DC03.contoso.co.uk
BIR-DC02.contoso.co.uk
BIR-DC01.contoso.co.uk
```

## 🥡 Key Takeaways

- **Calculated Properties appear in key cmdlets** - The same pattern works in 
  `Select-Object`, `Format-Table`, `Group-Object`, and `Measure-Object` too 
  (though some use different keys like `Label` and `Expression`)
- **Script blocks create dynamic properties** - You can create sorting criteria
  on the fly rather than being limited to existing object properties
- **Multiple sort keys give you control** - Combine priority logic with 
  secondary sorting for sophisticated, predictable results
- **Numeric priorities beat complex logic** - Using 0, 1, 2... is cleaner and 
  more maintainable than nested conditions
- **Hashtable syntax unlocks mixed sorting** - Control ascending/descending 
  direction independently for each sort criterion

## 📖 Reading List

- [`Sort-Object`'s Hashtable Syntax](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/sort-object?example-5-use-a-hash-table-to-sort-properties-in-ascending-and-descending-order) - The main reference page with examples of hashtable syntax

- [Sorting Objects Guide](https://learn.microsoft.com/en-us/powershell/scripting/samples/sorting-objects) - Practical examples including the hashtable approach with Expression and Descending keys

- [Selecting Parts of Objects](https://learn.microsoft.com/en-us/powershell/scripting/samples/selecting-parts-of-objects--select-object-) - Shows practical examples with Label and Expression hashtables

- [`Select-Object`'s Calculated Properties](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object#example-12-create-calculated-properties-for-each-inputobject) - Shows Example 12 with calculated properties using Name/Label and Expression