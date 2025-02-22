$previouslyCreated = [System.Collections.Generic.List[Object]]::new()

#region public functions
function New-Stuntman {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ArgumentCompletionsSupportedLocales()]
        $Locale,

        [Parameter()]
        [string]
        $CompanyName = 'Enyoi',

        [Parameter()]
        [int]
        $Amount = 1,

        [Parameter()]
        [Switch]
        $GenerateContracts,

        [Parameter()]
        [int]
        $MaxContractsPerEmployee = 2
    )

    try {
        $persons = [System.Collections.Generic.List[Object]]::new()
        $departmentManagers = @{}

        for ($i = 0; $i -lt $Amount; $i++) {
            $companyName = $CompanyName
            $faker = [Bogus.Faker]::new($Locale)
            $random = [Bogus.Randomizer]::new()
            $contracts = [System.Collections.Generic.List[Object]]::new()
            $firstName = $faker.Person.FirstName
            $lastName = $faker.Person.LastName
            
            if ($Locale -eq 'nl') {
                $prefixes = @('Van', 'De', 'Der', 'Den', 'Du', 'Ten', 'Ter', 'Vanden', 'Van der', 'Van den')
                if ((Get-Random -Minimum 1 -Maximum 6) -eq 1) {
                    $prefix = $prefixes | Get-Random
                } else {
                    $prefix = $null
                }
            }

            $lastName = 'Doe'
        
            $person = [PSCustomObject]@{
                firstName     = $firstName
                lastName      = if ($prefix) { "$prefix $lastName"} else { $lastName }
                fullName      = if ($prefix) { "$firstName $prefix $lastName" } else { "$firstName $lastName" }
                initials      = ("{0}.{1}." -f $firstName[0], $lastName[0])
                employeeId    = "$($random.Int(100000, 999999))"
                prefix        = $prefix
                userName      = ("{0}.{1}" -f $firstName, $lastName).ToLower()
                emailAddress  = ("{0}.{1}@{2}" -f $firstName[0], $lastName, $companyName).ToLower()
                companyName   = $companyName
                contracts     = $contracts
            }

            if ($GenerateContracts) {
                $contractsPerPerson = Get-Random -Minimum 1 -Maximum $MaxContractsPerEmployee

                for ($j = 0; $j -lt $contractsPerPerson; $j++) {
                    $startDate = (Get-Date).AddDays(- (Get-Random -Minimum 0 -Maximum (5 * 365))).AddDays((Get-Random -Minimum 0 -Maximum 14))
                    $endDate = $startDate.AddDays((Get-Random -Minimum 0 -Maximum (5 * 365)))
                    
                    $department = [Department]::GetValues([Department]) | ForEach-Object { $_.ToString() } | Get-Random
                    $manager = $false
                    if (-not $departmentManagers.ContainsKey($department)) {
                        $manager = $true
                        $departmentManagers[$department] = $true
                    }

                    $contract = [PSCustomObject]@{
                        employeeId   = $person.EmployeeId
                        startDate    = $startDate
                        endDate      = $endDate
                        hoursPerWeek = (Get-Random -InputObject @(8, 16, 20, 24, 28, 32, 36, 40))
                        title        = [JobTitle]::GetValues([JobTitle]) | ForEach-Object { $_.ToString() } | Get-Random
                        department   = $department
                        costCenter   = [CostCenter]::GetValues([CostCenter]) | ForEach-Object { $_.ToString() } | Get-Random
                        manager      = $manager
                    }
                    $contracts.Add($contract)
                }
            }
            $persons.Add($person)
            $previouslyCreated.Add($person)
        }
        foreach ($p in $persons){
            Write-Output $p
        }
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}


function Get-Stuntmen {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]
        $EmployeeId
    )
    try {
        if ($EmployeeId){
            Write-Output $previouslyCreated | Where-Object { $_.employeeId -eq $EmployeeId }
        } else {
            $previouslyCreated
        }
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

function New-StuntDataGenerationObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Internet', 'System', 'Lorum')]
        [string]
        $DataSet
    )

    dynamicparam {
        $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()

        switch ($DataSet){
            'Internet'{
                $attributeCollection.Add((New-Object System.Management.Automation.ValidateSetAttribute(([InternetDataGenerationType]::GetValues([InternetDataGenerationType])))))
            }

            'System'{
                $attributeCollection.Add((New-Object System.Management.Automation.ValidateSetAttribute(([SystemDataGenerationType]::GetValues([SystemDataGenerationType])))))
            }

            'Lorum'{
                $attributeCollection.Add((New-Object System.Management.Automation.ValidateSetAttribute(([LoremDataSet]::GetValues([LoremDataSet])))))
            }
        }

        $paramAttributes = [System.Management.Automation.ParameterAttribute]::new()
        $paramAttributes.Mandatory = $true
        $attributeCollection.Add($paramAttributes)

        $param = [System.Management.Automation.RuntimeDefinedParameter]::new(
            "GenerationType",
            [string],
            $attributeCollection
        )
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $paramDictionary.Add("GenerationType", $param)
        return $paramDictionary
    }

    process {
        try {
            switch ($DataSet){
                'Internet'{
                    $faker = [Bogus.DataSets.Internet]::new()
                }

                'System'{
                    $faker = [Bogus.DataSets.System]::new()
                }

                'Lorum'{
                    $faker = [Bogus.DataSets.Lorem]::new()
                }
            }

            $faker.$($PSBoundParameters.GenerationType)()
        } catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
#endregion public functions

#region private functions and helper classes
class ArgumentCompletionsSupportedLocales: System.Management.Automation.ArgumentCompleterAttribute {
    ArgumentCompletionsSupportedLocales() : base({
        [SupportedLocales] | Get-Member -Static -Type Properties | Select-Object -ExpandProperty Name
    }) { }
}
#endregion private functions and helper classes

#region enums
enum LoremDataSet {
    Sentences
}

enum SupportedLocales {
    af_ZA
    ar
    az
    cz
    de
    de_AT
    de_CH
    el
    en
    en_AU
    en_AU_ocker
    en_BORK
    en_CA
    en_GB
    en_IE
    en_IND
    en_NG
    en_US
    en_ZA
    es
    es_MX
    fa
    fi
    fr
    fr_CA
    fr_CH
    ge
    hr
    id_ID
    it
    ja
    ko
    lv
    nb_NO
    ne
    nl
    nl_BE
    pl
    pt_BR
    pt_PT
    ro
    ru
    sk
    sv
    tr
    uk
    vi
    zh_CN
    zh_TW
    zu_ZA
}

enum InternetDataGenerationType {
    Avatar
    Email
    ExampleEmail
    UserName
    UserNameUnicode
    DomainName
    DomainWord
    DomainSuffix
    Ip
    Port
    IpAddress
    IpEndPoint
    Ipv6
    Ipv6Address
    Ipv6EndPoint
    UserAgent
    Mac
    Password
    Color
    Protocol
    Url
    UrlWithPath
    UrlRootedPath
}

enum SystemDataGenerationType {
    FileName
    DirectoryPath
    FilePath
    CommonFileName
    MimeType
    CommonFileType
    CommonFileExt
    FileType
    FileExt
    Semver
    Version
    Exception
    AndroidId
    ApplePushToken
    BlackBerryPin
}

enum Department {
    Engineering
    HR
    RD
    Support
    Legal
    Marketing
    Accounting
    Finance
    IT
    Staffing
    Sales
    Recruitment
    Management
}

enum JobTitle {
    Developer
    Manager
    Consultant
    Engineer
    Analyst
    Architect
    Administrator
    Technician
    Designer
    Coordinator
    Director
    Strategist
    Supervisor
    Specialist
    Officer
    Executive
    Operator
    Planner
    Researcher
    Trainer
    Advisor
    Representative
    Inspector
    Producer
    Controller
    Facilitator
    AnalystSenior
    EngineerSenior
    DeveloperLead
    ConsultantSenior
    ManagerSenior
    EngineerPrincipal
    DirectorIT
    DirectorHR
    DirectorFinance
    DirectorSales
    DirectorMarketing
    ChiefTechnologyOfficer
    ChiefOperatingOfficer
    ChiefFinancialOfficer
    ChiefExecutiveOfficer
}

enum CostCenter {
    CC1001
    CC1002
    CC1003
    CC1004
    CC1005
    CC1006
    CC1007
    CC1008
    CC1009
    CC1010
    CC1011
    CC1012
    CC1013
    CC1014
    CC1015
    CC1016
    CC1017
    CC1018
    CC1019
    CC1020
    CC1021
    CC1022
    CC1023
    CC1024
    CC1025
    CC1026
    CC1027
    CC1028
    CC1029
    CC1030
    CC1031
    CC1032
    CC1033
    CC1034
    CC1035
    CC1036
    CC1037
    CC1038
    CC1039
    CC1040
}
#endregion enums