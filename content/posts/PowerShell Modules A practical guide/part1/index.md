---
title: "Your First PowerShell Function: The Essential Building Block"
date: 2025-07-25T10:00:00-00:00
draft: false
tags: ["PowerShell", "Module Development","Best Practices","Tutorial","TextUtils"]
featured_image: "hero.jpg"
ai_generated_image: true
ai_tool: "Google Pixel Studio (Imagen 3)"
ai_prompt: "A series of stylised, glowing building blocks, neatly stacked. Behind them a coding window and a cursor. The overall tone should be clean and modern. Colours should lean towards PowerShell's blue and purple and be bright"
description: "The journey to building robust, shareable PowerShell modules begins with a fundamental concept: the PowerShell function. Functions are the heart of any well-structured script, allowing you to encapsulate reusable logic."
series: "powershell-modules"
series_part: 1
---

Welcome to the first article in our series on building PowerShell modules! If
you've ever found yourself copying and pasting the same lines of PowerShell code
repeatedly, or if your scripts are getting long and difficult to manage, you're
in the right place.

The journey to building robust, shareable PowerShell modules begins with a
fundamental concept: the PowerShell function. Functions are the heart of any
well-structured script, allowing you to encapsulate reusable logic.

## Why Functions?

You might be thinking, *"My scripts work just fine as they are."* And they might!
But as your automation tasks grow, so does the complexity. Functions address
several key challenges:

- **Reusability**: Write code once, use it many times. No more copy-pasting code
  blocks.

- **Readability**: Breaking down large scripts into smaller, named functions
  makes your code much easier to understand, both for you and for others. Think
  about future you!

- **Maintainability**: If you need to fix a bug or add a feature, you only need
  to change the code in one place (the function definition), rather than every
  instance where that logic is used.

- **Organization**: Functions provide a logical structure, grouping related
  operations together.

Think of functions as mini-programs within your script. Each one has a specific
job, input, and output.

## The Basic Anatomy of a PowerShell Function

At its simplest, a PowerShell function looks like this:

```PowerShell
function My-Function {
    # Your code goes here
    Write-Host "Hello from My-Function!"
}
```

To use this function, you simply call its name, just like you would with any
built-in PowerShell cmdlet:

```PowerShell
My-Function
```

```txt {linenos=false}
Hello from My-Function!
```

## Adding Parameters: Making Functions Dynamic

Most useful functions need to accept input. This is where parameters come in.
You define parameters using the `param()` block:

```PowerShell
function Say-Hello {
    param(
        [string]
        $Name # This declares a string parameter called 'Name'
    )
    Write-Host "Hello, $Name!"
}
```

Now, you can provide input when you call the function:

```PowerShell
Say-Hello -Name "Alice"
```

```txt {linenos=false}
Hello, Alice!
```

## Advanced Parameter Attributes

For more powerful functions, you'll often see `[CmdletBinding()]` and 
`[Parameter()]` attributes. We'll dive deeper into these in future articles, but
for now here's a sneak peek at how they can give you control over how your
function is used and help make them behave more like native PowerShell cmdlets.

```PowerShell
function Get-Greeting {
    [CmdletBinding()]
    param(
        # The name of the person to greet.
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name,

        # Specify the language for the greeting.
        [Parameter()]
        [ValidateSet('English', 'Spanish', 'French')]
        [string]
        $Language = 'English'
    )

    switch ($Language) {
        'English' {
            Write-Host "Hello, $Name!"
        }
        'Spanish' {
            Write-Host "¡Hola, $Name!"
        }
        'French' {
            Write-Host "Bonjour, $Name!"
        }
        default { 
            Write-Host "Hello, $Name! (Language not supported)"
        }
    }
}
```

### Default Values

We gave a default of `'English'` for the `Language` parameter, meaning that if
we don't specify it, we get the English Greeting by default.

```PowerShell
Get-Greeting -Name 'Charlie'
```

```txt {linenos=false}
Hello, Charlie!
```
### Mandatory Parameters
Because we marked `Name` as mandatory, PowerShell will prompt us to enter a
value for it if we don't supply one. This is true even if a default has been
defined.

This means that default values for mandatory parameters don't make a lot of
sense!

```PowerShell
Get-Greeting
```

```txt {linenos=false}
cmdlet Get-Greeting at command pipeline position 1
Supply values for the following parameters:
Name: █
```

### Positional Parameters

Because we specified `Position = 0`, `'David'` works without the `-Name`
parameter being explicitly used.

Because `'David'` is the first value supplied that isn't associated with a named
parameter, PowerShell treats it as the value for the `-Name` parameter.

```PowerShell
Get-Greeting 'David' -Language 'Spanish' 
```

```txt {linenos=false}
¡Hola, David!
```
### Parameter Validation

We decorated our `Language` parameter with an attribute called
`[ValidateSet(...)]`. This tells PowerShell exactly which values are valid for
this parameter. If you try to use a value not in the set, PowerShell will
throw an error.

```PowerShell
Get-Greeting -Name 'Eve' -Language 'Klingon'
```

```no-highlight {linenos=false}
Get-Greeting: Cannot validate argument on parameter 'Language'. The argument
"Klingon" does not belong to the set "English,Spanish,French" specified by the
ValidateSet attribute. Supply an argument that is in the set and then try the
command again.
```

## Building TextUtils: Our First Function

Throughout this series, we'll be building a simple module called 
`TextUtils`. This module will house various functions for manipulating
text.

We'll work on our very first function which will take a string as input and 
output its reverse.

### Naming

The very first decision we need to make is what to call this function? 
PowerShell, helpfully, has a clear and very opinionated pattern for naming
functions; `Verb-Noun`.

We want to `Reverse` a `String`, so the best name is surely `Reverse-String`,
right? 😅 Not quite...

For discoverability and consistency, PowerShell defines a set of "Approved
Verbs". We can run the `Get-Verb` cmdlet to see the list of these approved
verbs. You can read more about approved verbs on the [Microsoft Learn docs](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands#verb-naming-recommendations).

`Reverse` is not an approved verb so we're going to go instead with
`ConvertTo-ReversedString`. The name is incredibly descriptive and there's
absolutely no ambiguity about what's going to happen when it's
used. `ConvertTo-` is used when transforming data into a different format or
representation; exactly what we're doing.

### Prototyping

Let's start with how we reverse a string. Like with anything, there's always
many ways to achieve the same thing.

The general gist of all the methods you may see online is to:

- Treat the string as an array of characters
- Iterate through that array of characters - end first
- Join the array of characters back into a string

A first pass at this could use a `[StringBuilder]`, which is [a fast, memory
efficient way](https://powershell.one/tricks/performance/strings#:~:text=By%20using%20a%20StringBuilder%20instead,seconds%20%2D%20more%20than%20500x%20faster!)
to manipulate strings:

```PowerShell
# The string we want to reverse
$original = "hello"

# Create a new StringBuilder
$builder = [System.Text.StringBuilder]::new()

# Loop through the string backwards
for ($i = $original.Length - 1; $i -ge 0; $i--) {
    # Append the i-th character to the StringBuilder, suppressing output
    [void] $builder.Append($original[$i])
}

# Build the StringBuilder into a, you guessed it, string!
$reversed = $builder.ToString()
```

This would, for long strings, be pretty performant. For smaller strings, however
there's a bit of overhead with using a `[StringBuilder]`. Let's look at a
simpler way.

```PowerShell
$original = "hello"
$reversed = -join $string[($original.Length-1)..0]
```

Great. Don't worry too much if the code above looks a little confusing. It's
doing exactly what we did before, just using some PowerShell magic to make it
just a line or two. We'll dive more deeply into some of those syntax tricks in
future posts.

### Wrapping up

We can now build our `ConvertTo-ReversedString` function.

```PowerShell
function ConvertTo-ReversedString {
    [CmdletBinding()]
    param(
        # The string to be reversed
        [Parameter(Mandatory, Position = 0)]
        [string]
        $String
    )
    process {
        # The core logic to reverse the string
        -join $String[($String.Length-1)..0]
    }
}
```

Notice the process block. While not strictly necessary for simple functions,
it's good practice for functions that might process pipeline input, ensuring the
code runs for each object piped to it.

Save this code into a .ps1 file called `ConvertTo-ReversedString.ps1` and
run it. The function is now defined in your current PowerShell session.

You can call it like:

```PowerShell
ConvertTo-ReversedString -String "powershell"
```

```txt {linenos=false}
llehsrewop
```

and

```PowerShell
ConvertTo-ReversedString "module"
```

```txt {linenos=false}
eludom
```

Congratulations! You've just written your first PowerShell function that is
reusable and accepts input. This is *the* foundational step towards building
powerful and shareable modules.

## 🥡 Key Takeaways

- **Functions are Reusable building blocks** - Write once, use everywhere. No more 
  copy-pasting the same code across multiple scripts
- **Parameters make functions dynamic** - Use `param()` blocks to accept input 
  and make your functions flexible for different scenarios
- **Follow PowerShell conventions** - Use approved verbs (`Get`, `Set`, `New`, 
  `Convert`) to make your functions consistent and discoverable
- **Start with `[CmdletBinding()]`** - Even simple functions benefit from this 
  attribute, preparing them for advanced features later

Functions are your gateway to organized, maintainable PowerShell code. Master 
them, and you're well on your way to building professional modules.

## 📖 Reading List

- [About Functions](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions) - Microsoft's comprehensive guide to PowerShell functions, covering everything from basic syntax to advanced features

- [About Functions Advanced Parameters](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters) - Deep dive into parameter attributes, validation, and making your functions behave like cmdlets

- [PowerShell Approved Verbs](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands) - The official list of approved verbs to use in your function names for consistency

- [About Scopes](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes) - Understanding how PowerShell handles variable scope, including function scope

- [PowerShell Best Practices and Style Guide](https://github.com/PoshCode/PowerShellPracticeAndStyle) - Community-driven style guide for writing clean, readable PowerShell code

- [Building PowerShell Functions - Best Practices](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/09-functions) - Part of Microsoft's PowerShell 101 series, focusing on function best practices

In the next article, we'll take this function and build on it, packaging it into
a .psm1 file, creating the bare bones of our `TextUtils` module.