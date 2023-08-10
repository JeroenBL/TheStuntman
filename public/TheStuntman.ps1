$previouslyCreated = [System.Collections.Generic.List[Object]]::new()

function New-Stuntman {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ArgumentCompletionsSupportedLocales()]
        $Locale
    )

    try {
        $faker = [Bogus.Faker]::new($Locale)
        $random = [Bogus.Randomizer]::new()

        $person = [PSCustomObject]@{
            UserId    = $random.Int(1, 100000)
            UserName = $faker.Person.UserName
            Avatar   = $faker.Person.Avatar
            FirstName = $faker.Person.FirstName
            LastName  = $faker.Person.LastName
            FullName  = $faker.Person.FullName
            Gender    = $faker.Person.Gender.ToString()
            Address = [PSCustomObject]@{
                ZipCode          = $faker.Person.Address.ZipCode
                StreetName       = $faker.Person.Address.Street
                City             = $faker.Person.Address.City
                Country          = $Locale
                State            = $faker.Person.Address.State
                Lng              = $faker.Person.Address.Geo.Lng
                Lat              = $faker.Person.Address.Geo.Lat
            }
            Contact = [PSCustomObject]@{
                Phone = $faker.Person.Phone
                Email = $faker.Person.Email
            }
            Contract = New-StuntmanContract -Faker $faker

        }
        $previouslyCreated.Add($person)
        Write-Output $person
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

function Get-Stuntmen {
    [CmdletBinding()]
    param(
        [Parameter()]
        [Int]
        $UserId
    )
    try {
        if ($UserId){
            $previouslyCreated | Where-Object { $_.UserId -eq $UserId }
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

class ArgumentCompletionsSupportedLocales: System.Management.Automation.ArgumentCompleterAttribute {
    ArgumentCompletionsSupportedLocales() : base({
        [SupportedLocales] | Get-Member -Static -Type Properties | Select-Object -ExpandProperty Name
    }) { }
}

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

function New-StuntmanContract {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Bogus.Faker]
        $Faker
    )

    try {
        [PSCustomObject]@{
            StartDate    = $Faker.Date.Past(5)
            EndDate      = $Faker.Date.Future(5)
            HoursPerWeek = $Faker.PickRandom(8, 16, 20, 32, 40)
            Department   = $Faker.PickRandom([Department]::new())
            JobTitle     = $Faker.Name.JobTitle()
            JobArea      = $Faker.Name.JobArea()
            JobType      = $Faker.Name.JobType()
            CompanyName  = $Faker.Person.Company.Name
            CatchPhrase  = $Faker.Person.Company.CatchPhrase
            Bs           = $Faker.Person.Company.Bs
        }
    } catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
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


