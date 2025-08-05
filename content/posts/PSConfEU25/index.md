---
title: "PSConfEU 2025 Roundup"
date: 2025-08-05T18:00:00+01:00
draft: true
tags: ["PowerShell", "Conference", "Roundup", "PSConfEU"]
featured_image: "hero.png"
ai_generated_image: true
ai_tool: "Google Pixel Studio (Imagen 3)"
ai_prompt: "A purple background with an orange stack of papers representing a video playlist. A play button appears on the top one. All in an illustrated vector art style"
description: "It's that time of year again, PSConfEU (in Malmö Sweden this year) has wrapped up and the session recordings have been released. I've watched a fair few of them and there's lots of good stuff. I've put together 10 that stood out to me."
---

It's that time of the year again, PSConfEU (in Malmö Sweden this year) has
wrapped up and the session recordings have been released. I've watched a fair
few of them and there's lots of good stuff. I've put together 10 that stood out
to me, but the full [playlist is available on YouTube](https://www.youtube.com/playlist?list=PLDCEho7foSoo6tc8iNDSrxp27dG_gtm6g),
I highly recommend checking it out!

## PowerShelling Active Directory - Far and Wide

{{< conference-session 
    videoId="w8iJL9f2gxM" 
    presenters="it-pro-berlin-de" 
    resourceLink="https://github.com/psconfeu/2025/tree/main/Evgenij%20Smirnov/Active%20Directory" 
    resourceText="Active Directory" 
>}}

Working in a Windows Enterprise environment, I work with Active Directory on a
near daily basis. I have used and absused the `ActiveDirectory` module for more
years than I care to admit. I've dipped my toes into `DirectoryServices` in
the past when the module wasn't doing what I wanted, as fast as I wanted. I was
always pretty sure that the module wasn't the most performant way to interact 
with Active Directory, but Evgenij's talk really drives that point home. Plus
my own experiences with the `ActiveDirectory` module and `AD Web Services` as a
whole have been less than stellar.

He has a `Demo` forest, which is smaller and viable for his live demos, as well
as a `Reference` forest made up of:
  - 2 domains
  - 2 domain controllers
  - \> 2 million users
  - \> 2 million groups
  - \> 15 million group memberships
  - NTDS.DIT file size > 45 GB

He shows a comparison of timings for various methods for enumerating all groups,
along with the peak memory when doing so on the `Reference` forest.

| Test                                         	| Demo   	| Reference 	| Peak RAM 	|
|----------------------------------------------	|-------:	|----------:	|----------:|
| AD PowerShell Module                         	|  1.4 s 	|     229 s 	|   2.8 GB 	|
| PSOpenAD                                     	|  1.1 s 	|     372 s 	|   3.7 GB 	|
| System.DirectoryServices.DirectorySearcher   	| 0.52 s 	|      55 s 	|   1.1 GB 	|
| System.DirectoryServices.Protocols   (PS5.1) 	| 0.42 s 	|      40 s 	|   260 MB 	|
| System.DirectoryServices.Protocols   (PS7.5) 	| 0.36 s 	|      43 s 	|   165 MB 	|

The results are impressive, especially the `System.DirectoryServices.Protocols`
method in PowerShell 7. Admittedly the `System.DirectoryServices.Protocols`
method is horrendous to look at, but it is significantly faster and uses a lot
less memory. Certainly something to look into!

## Optimizing Visual Studio Code for PowerShell, 2025 Edition

{{< conference-session 
    videoId="9Nwo_Z_nW2s" 
    presenters="JustinGrote" 
    resourceLink="https://github.com/JustinGrote/PSConfEU2025" 
    resourceText="PSConfEU2025" 
>}}


Justin's talks are always a massive highlight for me. His enthusiasm and
technical confidence are enviable.

He's done a version of this talk 4-5 times already; Justin ❤️ VSCode. He's a
community maintainer for the PowerShell extension for VSCode and he also
recently had some PRs merged into the main PowerShell repo.

I always learn about some new features or settings I can use to make my
development experience better so well worth the longer runtime.

In this talk he goes from a fresh VSCode install to a fully configured
PowerShell development environment. He covers everything you'd want to know from
installing a portable version of VSCode, to diving into settings and recommended
extensions. He also covers some of the new features in the PowerShell extension.

For me, some of the highlights from the talk were:

- Justin's [DotFiles Repo](https://github.com/JustinGrote/dotfiles) - which, 
  among other things, contains his VSCode settings and extensions.
- Justin's [`Microsoft.VSCode_profile.ps1`](https://github.com/JustinGrote/dotfiles/blob/main/dot_config/powershell/Microsoft.VSCode_profile.ps1)
  shows the import of [`EditorServicesCommandSuite`](https://github.com/SeeminglyScience/EditorServicesCommandSuite).
  This is a PowerShell module to assist with editing PowerShell scripts in
  VSCode. If you run the command in Justin's profile, it adds the functions of
  this module as built-in commands in VSCode.
- The [Timeline view](https://code.visualstudio.com/docs/getstarted/userinterface#_timeline-view)
  in VSCode
- Terminal being able to be a seperate Window. Very impressive on a multi-screen
  setup.
- Triggered Breakpoints - allows you to set breakpoints that only trigger when
  another breakpoint is set and triggers.

## What's new in PowerShell Universal v5

{{< conference-session 
    videoId="sGQ7cDrDK7I" 
    presenters="adamdriscoll" 
    resourceLink="https://github.com/psconfeu/2025/tree/main/Adam%20Driscoll/PSU" 
    resourceText="PSU" 
>}}

I use [PowerShellUniversal](https://powershelluniversal.com/) daily and have
been using it since back in the day when it was just UniversalDashboard. In that
time I've seen it add feature after feature and become a more mature and stable
product. Ironman Software (Adam's company) was a major sponsor of this years
conference which was nice to see.

In my day job we're still using the LTS version 4 release, so this talk was a great
overview of what's new in PSU v5. Some of the things that Adam demoed in this
talk which I'm particularly excited for are:

- Cmdlet rearchitecting to use gRPC protocol. It's a much more efficient
  remoting protocol from Google.
- New Blazor Admin Console with improved tooling and reliability.
- Database Support for configuration files such as Roles.

## EverythingFast: Developing Performant Modules

{{< conference-session 
    videoId="eqCF8xB7ChM" 
    presenters="justingrote" 
    resourceLink="https://github.com/JustinGrote/ModuleFast" 
    resourceText="ModuleFast" 
>}}

This talk was the first time I'd seen [`ModuleFast`](https://github.com/JustinGrote/ModuleFast)
in action. It's a module written by Justin that he describes as a "fast and
loose" way to install modules from the PowerShell Gallery. He launches straight
into a demo of installing the `Az` module - notorious for having a large number
of dependencies. The `Az` module can be a lengthy install, frequently taking
over 15 minutes. ModuleFast installs it in 10 seconds. 🤯

Justin then moves onto showing off his WIP module [ExcelFast](https://github.com/JustinGrote/ExcelFast).
A high-performance PowerShell module for importing, exporting, and manipulating
Excel Files. I've used Doug Finke's [ImportExcel](https://github.com/dfinke/ImportExcel)
for years, but it does creak around the edges with large workbooks. It's not
super-actively developed, with the last release being nearly a year ago at time
of writing. Not that I could use the latest release anyway, as it's plagued with
an issue opening large files. This means I have to use version 7.4.2 (released
all the way back in April 2022)! All that is to say, I watched Justin's demo
closely. It handily beat `ImportExcel` in the demos, both in terms of time to
get data, as well as memory footprint. Interestingly Justin showed the Memory
profile using [JetBrains DotMemory](https://www.jetbrains.com/dotmemory/), a 
.NET process memory profiler (PowerShell being just another .NET process).

Justin does dive into how his ModuleFast module works, and I must say that it's
a very interesting watch!

## Confessions of a Screen Scraper

{{< conference-session 
    videoId="EVfgrUGJGQo" 
    presenters="jhoneill" 
    resourceLink="" 
    resourceText="" 
>}}

James' talk is a journey into 'Screen Scraping'; his term for gathering data
from web sources that may not have straightforward APIs or accessible data
formats. He shows how he uses and abuses tools to scrape data from sources such
as Volkswagen, Formula One, Electric Charger locations, as well as his home
electricity usage. He goes through a practical end-to-end example looking at
train time data from the National Rail Website which was neat to see. He uses
Chrome Dev-Tools to see the network requests the website itself is making and I
learned that you can right-click on one of these requests and
`Copy > Copy as PowerShell`. This puts all the code onto your clipboard that
you need to make an identical request; I really do mean everything - cookies,
user-agent, headers - everything.

## Error Handling - A Mystery in Red

{{< conference-session 
    videoId="ZFI8MQJwsa4" 
    presenters="FriedrichWeinmann" 
    resourceLink="https://github.com/FriedrichWeinmann/P2025-PSConfEU-ErrorHandling" 
    resourceText="P2025-PSConfEU-ErrorHandling" 
>}}

I've seen a few of Fred's previous talks and really enjoy his methodical
approach. In this session, he dives into PowerShell error handling; going
through a lot of practical examples to illustrate the differences between
terminating and non-terminating errors. This is something that in the past I
haven't always gotten right. Fred advocates for good error hygiene and the use
of `try/catch` blocks to handle errors effectively - which I very much agree
with.

Something I've learned from this session is that passing an `-ErrorAction` to a
cmdlet sets the `$ErrorActionPreference` variable within the scope of that
cmdlet. He demonstrated it with the below code.

```powershell
function Get-Preference {
	[CmdletBinding()]
	param ()
    $ErrorActionPreference
}
Get-Preference
Get-Preference -ErrorAction Stop
Get-Preference -ErrorAction Ignore
```

```txt {linenos=false}
Continue
Stop
Ignore
```

We see from the output that the `$ErrorActionPreference` variable is different
within the functions scope depending on the `-ErrorAction` parameter passed to
it.

## Hardcore Git-Fu!

{{< conference-session 
    videoId="pk13M19V4Vw" 
    presenters="bjompen" 
    resourceLink="https://github.com/psconfeu/2025/tree/main/Bj%C3%B6rn%20Sundling/Hardcore%20GitFU" 
    resourceText="Hardcore GitFU" 
>}}

Git has become the defacto standard for version control and it's something I use
every day. Beyond the usual git flow (add, commit, push, pull) I have to say
that my Git-Fu is weak! Björn starts the session off by explain the difference
between the 'plumbing' and the 'porcelain' commands in git (which is a fun
metaphor baked right into git e.g. `git status --porcelain`). The plumbing
being the infrastructure behind the scenes and the porcelain being the nice,
user facing interaction surface. You don't need to use the plumbing directly,
but it's helpful to have an appreciation for what it does for you when you use
the porcelain!

Some commands and concepts discussed are:

- `git stash` which temporarily stashes away/shelves local changes.
- `git add --patch` or `git add -p` which enables you to more granularly stage
  'hunks' of changes (1 or more lines) from a file, rather than adding the whole
  file.
- Merge conflicts
- Rewriting history

## Designing Commands for the PowerShell Pipeline

{{< conference-session 
    videoId="Q19n1ST7K0Q" 
    presenters="FriedrichWeinmann" 
    resourceLink="https://github.com/FriedrichWeinmann/P2025-PSConfEU-FunctionsForPipeline" 
    resourceText="P2025-PSConfEU-FunctionsForPipeline" 
>}}

The PowerShell pipeline is a keystone feature of PowerShell. It's incredibly
powerful but it's often overlooked in functions and cmdlets. I'm definitely
guilty of writing more classical functions that don't fully utilise the
pipeline.

Fred walks through what the pipeline is and how it works with some incredibly
clear examples. One of which shows how the ordering of the pipeline works. I was
blown away by it, but he unfortunately hasn't shared the code. Skip to
[4:42 in the recording](https://www.youtube.com/watch?v=Q19n1ST7K0Q&t=282s)
to see his in action. I've recreated something similar below (for a version with
the fancy coloured text see [this gist](https://gist.github.com/liamjpeters/5f7c60f8ed9d5ba908323e91d19c5e3b#file-show-pipeline-ps1)).

```powershell
function Show-Pipeline {
    [CmdletBinding()]
    param (
        [ValidateSet('First','Second','Third')]
        [Parameter(Mandatory, Position = 0)]
        [string]
        $Name,
        [Parameter(ValueFromPipeline)]
        [string]
        $InputObject
    )
    begin {
        $NumTabs = switch ($Name) {
            'First' {2}
            'Second' {1}
            'Third' {2}
            default { [System.ConsoleColor]'black' }
        }
        Write-Host "[Begin]`t`t[$Name]"
    }
    process {
        Write-Host "[Process]`t[$Name]$("`t"*$NumTabs)Processing $InputObject"
        Write-Output -InputObject $InputObject
    }
    end {
        Write-Host "[End]`t`t[$Name]$("`t"*$NumTabs)Ending"
    }
    clean {
        Write-Host "[Clean]`t`t[$Name]$("`t"*$NumTabs)Cleaning Up"
    }
}

'A','B','C' | Show-Pipeline First | Show-Pipeline Second | Show-Pipeline Third
```

```txt {linenos=false}
[Begin]         [First]
[Begin]         [Second]
[Begin]         [Third]
[Process]       [First]         Processing A
[Process]       [Second]        Processing A
[Process]       [Third]         Processing A
A
[Process]       [First]         Processing B
[Process]       [Second]        Processing B
[Process]       [Third]         Processing B
B
[Process]       [First]         Processing C
[Process]       [Second]        Processing C
[Process]       [Third]         Processing C
C
[End]           [First]         Ending
[End]           [Second]        Ending
[End]           [Third]         Ending
[Clean]         [First]         Cleaning Up
[Clean]         [Second]        Cleaning Up
[Clean]         [Third]         Cleaning Up
```


We can see that all of the `begin` blocks execute first. Then the first object,
`A`, makes it's way down the pipeline and each `process` block is executed in 
turn. After everything is processed we see the `end` and `clean` blocks run.

The `clean` block will execute even if an error occurs and the function is
terminated early - so it's the ideal place to do any resource cleanup. Let's add
an error to our process block and see this in action.

```powershell
process {
    if ($InputObject -eq 'B') {
        throw "Error!"
    }
    Write-Host "[Process]`t[$Name]$("`t"*$NumTabs)Processing $InputObject"
    Write-Output -InputObject $InputObject
}
```
```txt {linenos=false}
[Begin]         [First]
[Begin]         [Second]
[Begin]         [Third]
[Process]       [First]         Processing A
[Process]       [Second]        Processing A
[Process]       [Third]         Processing A
A
[Clean]         [First]         Cleaning
[Clean]         [Second]        Cleaning
[Clean]         [Third]         Cleaning
Exception: untitled:Untitled-1:23:13
Line |
  23 |              throw "Error!"
     |              ~~~~~~~~~~~~~~
     | Error!
```

Notice how `A` makes it all the way down the pipeline. The processing of `B`
creates the error and terminates execution, but those `clean` blocks still get
called!

Hopefully that whets your appetite; the session is chock full of excellent and
easy to digest examples like this that help build an understanding of what's
going on.

## Creating My First C# Module: Lessons Learned

{{< conference-session 
    videoId="uFrTJIAEuS0" 
    presenters="trackd" 
    resourceLink="https://github.com/psconfeu/2025/tree/main/Andree%20Renneus/Creating_My_First_C_Module" 
    resourceText="Creating_My_First_C_Module" 
>}}

I have *some* experience with C# binary modules, having landed a handful of PRs 
([including a new rule](https://github.com/PowerShell/PSScriptAnalyzer/commit/b0383ee52b45dfd6fbb78aba363e6cb3e1ebc8fe))
into [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer). I know
just about enough to be dangerous. I have, however, never written one from
scratch myself. This talk covers everything from: prototyping in PowerShell,
writing the Cmdlets themselves, scaffolding and structure, and considerations.
It also helpfully goes over using VSCode for development, rather than having to
rely on Visual Studio (and the bloat that comes with it).

The talks uses Andree's experience developing his module [Sixel](https://github.com/trackd/Sixel)
to guide us through the end-to-end dev process. Sixel allows you to display
images in the terminal, which is pretty wild. A fun little module to play around
with. Have you really lived if you've not had your face in a terminal window?

## Teach yourself Pester

{{< conference-session 
    videoId="yCrcfdWoJBQ" 
    presenters="SQLDBAWithABeard,powershellpr0mpt" 
    resourceLink="" 
    resourceText="" 
>}}

Rob and Robert make a great presenter pairing. While it's a shame that
Jakub, the Pester maintainer, wasn't able to give the presentation himself as
planned, Rob stepped in and did a great job. This really is a wonderful follow
along session where the two Robs go through the basics of Pester and their
methodology when it comes to testing. The session is fun and engaging and I was
actually fairly surprised that nearly 2 hours had gone by! My one key takeaway
from the talk is to always test both the explicit, but also implicit assumptions
that you're making in your code.