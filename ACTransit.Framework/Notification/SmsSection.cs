using System;
using System.Configuration;

//https://docs.microsoft.com/en-us/dotnet/api/system.configuration.configurationpropertyattribute?view=netframework-4.8

namespace ACTransit.Framework.Notification
{
    public class SmsSection : ConfigurationSection
    {
        [ConfigurationPropertyAttribute("name", IsRequired = true, IsKey = true)]
        public string Name
        {
            get { return (string)this["name"]; }
            set { this["name"] = value; }
        }

        [ConfigurationPropertyAttribute("provider", IsRequired = true)]
        public string Provider
        {
            get { return (string)this["provider"]; }
            set { this["provider"] = value; }
        }


        [ConfigurationProperty("sid")]
        public string AccountSId
        {
            get { return (string)this["sid"]; }
            set { this["sid"] = value; }
        }

        [ConfigurationProperty("token")]
        public string AuthToken
        {
            get { return (string)this["token"]; }
            set { this["token"] = value; }
        }

        [ConfigurationProperty("numbers", IsDefaultCollection = false)]
        public NumbersCollecton Numbers
        {
            get { return (NumbersCollecton)this["numbers"]; }
            set { this["numbers"] = value; }

        }

        [ConfigurationProperty("baseUrl")]
        public string BaseUrl
        {
            get { return (string)this["baseUrl"]; }
            set { this["baseUrl"] = value; }
        }

        [ConfigurationProperty("requestUrl")]
        public string RequestUrl
        {
            get { return (string)this["requestUrl"]; }
            set { this["requestUrl"] = value; }
        }

        [ConfigurationProperty("active", DefaultValue = true)]
        public bool Active
        {
            get { return (bool)this["active"]; }
            set { this["active"] = value; }
        }


        public static SmsSection Read(string sectionName)
        {
            // Get the application configuration file.
            Configuration config =
                ConfigurationManager.OpenExeConfiguration(
                    ConfigurationUserLevel.None);

            Console.WriteLine($"Config Path: {config.FilePath}");

            // Read and display the custom section.
            SmsSection customSection =
                config.GetSection(sectionName) as SmsSection;
            Console.WriteLine($"Name: {customSection?.Name}");
            Console.WriteLine($"Provider: {customSection?.Provider}");
            return customSection;
        }

        public static void CreateSection(string sectionName)
        {
            SmsSection customSection = new SmsSection();

            // Get the current configuration file.
            Configuration config =
                ConfigurationManager.OpenExeConfiguration(
                    ConfigurationUserLevel.None);

            // Add the custom section to the application
            // configuration file.
            if (config.Sections[sectionName] == null)
            {
                config.Sections.Add(sectionName, customSection);
            }


            // Save the application configuration file.
            customSection.SectionInformation.ForceSave = true;
            config.Save(ConfigurationSaveMode.Modified);

        }

    }

    public class NumbersCollecton : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new NumberElement();
        }

        protected override ConfigurationElement CreateNewElement(string elementName)
        {
            return new NumberElement(elementName);
        }


        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((NumberElement)element).Number;
        }


        public NumberElement this[int index]
        {
            get
            {
                return (NumberElement)BaseGet(index);
            }
            set
            {
                if (BaseGet(index) != null)
                {
                    BaseRemoveAt(index);
                }
                BaseAdd(index, value);
            }
        }
    }

    public class NumberElement : ConfigurationElement
    {
        public NumberElement(String number, String countryCoe)
        {
            Number = number;
            CountryCode = countryCoe;
        }
        public NumberElement(String number)
        {
            Number = number;
        }
        public NumberElement() { }

        [ConfigurationProperty("number", IsRequired = true, IsKey = true)]
        public string Number
        {
            get
            {
                return (string)this["number"];
            }
            set
            {
                this["number"] = value;
            }
        }
        [ConfigurationProperty("countryCode", IsRequired = true)]
        public string CountryCode
        {
            get
            {
                return (string)this["countryCode"];
            }
            set
            {
                this["countryCode"] = value;
            }
        }
        [ConfigurationProperty("active", DefaultValue = true)]
        public bool Active
        {
            get { return (bool)this["active"]; }
            set { this["active"] = value; }
        }
        public override string ToString()
        {
            return $"{CountryCode}{Number}";
        }

    }
}
