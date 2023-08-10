[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&duration=3000&pause=10&color=C023F7&center=true&vCenter=true&multiline=true&repeat=false&width=435&height=80&lines=Who+is+always+happy+to+testdrive;your+application+%3F;It's+...)](https://git.io/typing-svg)

# The Stuntman

![image](assets/logo.png)

## Table of contents

- [The Stuntman](#the-stuntman)
  - [Table of contents](#table-of-contents)
  - [The module](#the-module)
    - [Requirements](#requirements)
    - [Used nuget packages](#used-nuget-packages)
    - [Compatibility](#compatibility)
    - [Installation](#installation)
    - [Using the module](#using-the-module)
      - [Available cmdlets](#available-cmdlets)
        - [`New-Stuntman`](#new-stuntman)
        - [`Get-Stuntmen`](#get-stuntmen)
        - [`Get-Stuntmen -UserId`](#get-stuntmen--userid)
        - [`New-StuntDataGenerationObject`](#new-stuntdatagenerationobject)
      - [Helpers](#helpers)
        - [Functions](#functions)
        - [Classes](#classes)
        - [Enums](#enums)
  - [Contributing](#contributing)

## The module

### Requirements

- [ ] Either the Windows Terminal or the builtin terminal within VSCode.

> The older _ISE_ and _Console_ are not supported.

### Used nuget packages

- [__Bogus__](https://github.com/bchavez/Bogus)

### Compatibility

_TheStuntman_ uses the _.NET standard_ version of the [___Bogus___](https://github.com/bchavez/Bogus) nuget package. This means that the module is compatible with both _.NET Framework_ and _.NET (.NET Core)_ on any platform. (Windows, MacOs and Linux).

### Installation

1. Download the latest release. https://github.com/JeroenBL/TheStuntman/releases
2. Copy the files to a sensible location
3. Import the module

```powershell
Import-Module 'TheStuntman.psm1'
```

### Using the module

#### Available cmdlets

| Name                     | Description                                          | Version |
| ------------------------ | ---------------------------------------------------- | ------- |
| New-Stuntman         | Creates a new stuntman based on a provided locale. | 0.0.1   |
| Get-Stuntmen         | Retrieves the created stuntman from memory. | 0.0.1   |
| New-StuntDataGenerationObject | Creates a new data object. | 0.0.1   |

##### `New-Stuntman`

Creates a new stuntman.

>:information_source: Created stuntman are _'stored'_ in a list in memory.<br> Use `Get-Stuntmen` to retrieve them. See: [Get-Stuntmen](#get-stuntmen)

```powershell
PS C:\_Data\Github\TheStuntman> New-Stuntman -Locale nl

UserId    : 44450
UserName  : Janna18
Avatar    : https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/521.jpg
FirstName : Janna
LastName  : Vos
FullName  : Janna Vos
Gender    : Female
Address   : @{ZipCode=2588 IU; StreetName=Brittweg 817a; City=Duldermeer; Country=nl; State=Zeeland; Lng=-27,2772;
            Lat=25,649}
Contact   : @{Phone=0696514626; Email=Janna.Vos34@yahoo.com}
Contract  : @{StartDate=23/06/2020 15:39:02; EndDate=26/11/2024 01:43:18; HoursPerWeek=40; Department=Engineering;
            JobTitle=Dynamic Applications Agent; JobArea=Factors; JobType=Orchestrator; CompanyName=Haan - Veen;
            CatchPhrase=Universal methodical capacity; Bs=whiteboard leading-edge models}
```

##### `Get-Stuntmen`

Retrieves all created stuntmen from memory.

```powershell
PS C:\_Data\Github\TheStuntman> Get-Stuntmen

UserId    : 44450
UserName  : Janna18
Avatar    : https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/521.jpg
FirstName : Janna
LastName  : Vos
FullName  : Janna Vos
Gender    : Female
Address   : @{ZipCode=2588 IU; StreetName=Brittweg 817a; City=Duldermeer; Country=nl; State=Zeeland; Lng=-27,2772;
            Lat=25,649}
Contact   : @{Phone=0696514626; Email=Janna.Vos34@yahoo.com}
Contract  : @{StartDate=23/06/2020 15:39:02; EndDate=26/11/2024 01:43:18; HoursPerWeek=40; Department=Engineering;
            JobTitle=Dynamic Applications Agent; JobArea=Factors; JobType=Orchestrator; CompanyName=Haan - Veen;
            CatchPhrase=Universal methodical capacity; Bs=whiteboard leading-edge models}

UserId    : 27259
UserName  : Lyam49
Avatar    : https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/334.jpg
FirstName : Lyam
LastName  : Smits
FullName  : Lyam Smits
Gender    : Male
Address   : @{ZipCode=5643 PQ; StreetName=Thijslaan 022; City=Gaag; Country=nl; State=Limburg; Lng=-59,1646; Lat=-3,1104}
Contact   : @{Phone=9108481826; Email=Lyam.Smits33@gmail.com}
Contract  : @{StartDate=06/12/2022 16:42:10; EndDate=24/03/2026 00:20:57; HoursPerWeek=8; Department=Engineering; JobTitle=Investor Group Manager; JobArea=Mobility; JobType=Officer; CompanyName=Boer - Meer;
            CatchPhrase=Versatile neutral focus group; Bs=enhance mission-critical e-tailers}
```

##### `Get-Stuntmen -UserId`

Retrieve a stuntman by _UserId_ from memory.

```powershell
PS C:\_Data\Github\TheStuntman> Get-Stuntmen -UserId 44450

UserId    : 44450
UserName  : Janna18
Avatar    : https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/521.jpg
FirstName : Janna
LastName  : Vos
FullName  : Janna Vos
Gender    : Female
Address   : @{ZipCode=2588 IU; StreetName=Brittweg 817a; City=Duldermeer; Country=nl; State=Zeeland; Lng=-27,2772;
            Lat=25,649}
Contact   : @{Phone=0696514626; Email=Janna.Vos34@yahoo.com}
Contract  : @{StartDate=23/06/2020 15:39:02; EndDate=26/11/2024 01:43:18; HoursPerWeek=40; Department=Engineering;
            JobTitle=Dynamic Applications Agent; JobArea=Factors; JobType=Orchestrator; CompanyName=Haan - Veen;
            CatchPhrase=Universal methodical capacity; Bs=whiteboard leading-edge models}
```

##### `New-StuntDataGenerationObject`

```powershell
PS C:\_Data\Github\TheStuntman> New-StuntDataGenerationObject -DataSet Internet -GenerationType Ipv6EndPoint

 AddressFamily Address                                  Port
 ------------- -------                                  ----
InterNetworkV6 1167:9e01:dded:3eda:f66a:f19f:eec1:7b7f 18032
```

#### Helpers

##### Functions
| Name                       | Description                             | Version |
| -------------------------- | --------------------------------------- | ------- |
| New-StuntmanContract | Creates a contract for the stuntman | 0.0.1   |

##### Classes

| Name                                | Description                             | Version |
| ----------------------------------- | --------------------------------------- | ------- |
| ArgumentCompletionsSupportedLocales | Argumentcompleter for supported locales | 0.0.1   |


##### Enums
| Name                       | Description                  | Version |
| -------------------------- | ---------------------------- | ------- |
| LoremDataSet               | Enum for LoremDataSet        | 0.0.1   |
| SupportedLocales           | Enum for SupportedLocales    | 0.0.1   |
| InternetDataGenerationType | Enum for Internet data set   | 0.0.1   |
| SystemDataGenerationType   | Enum for System data set     | 0.0.1   |
| Departments                | Enum for Department data set | 0.0.1   |

## Contributing

Find a bug or have an idea! Open an issue or submit a pull request!