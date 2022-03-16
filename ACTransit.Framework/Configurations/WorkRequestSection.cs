using System.Configuration;

namespace ACTransit.Framework.Configurations
{
    public class WorkRequestSection : ConfigurationSection
    {
        [ConfigurationProperty("", IsRequired = true, IsDefaultCollection = true)]
        public WorkRequestParametersSection Instances
        {
            get { return (WorkRequestParametersSection)this[""]; }
            set { this[""] = value; }
        }

    }
    public class WorkRequestParametersSection : ConfigurationElementCollection
    {
        protected override ConfigurationElement CreateNewElement()
        {
            return new WorkRequestParameter();
        }

        protected override ConfigurationElement CreateNewElement(string elementName)
        {
            return new WorkRequestParameter(elementName);
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((WorkRequestParameter)element).Name;
        }


        //public WorkRequestParameter this[int index]
        //{
        //    get
        //    {
        //        return (WorkRequestParameter)BaseGet(index);
        //    }
        //    set
        //    {
        //        if (BaseGet(index) != null)
        //        {
        //            BaseRemoveAt(index);
        //        }
        //        BaseAdd(index, value);
        //    }
        //}

        public WorkRequestParameter this[string name] => (WorkRequestParameter)BaseGet(name);
    }
    public class WorkRequestParameter : ConfigurationElement
    {
        public WorkRequestParameter() { }

        public WorkRequestParameter(string name) { this.Name = name; }

        public WorkRequestParameter(string name, string classification) : this(name) { this.Classification = classification; }

        [ConfigurationPropertyAttribute("name", IsRequired = true, IsKey = true)]
        public string Name
        {
            get { return (string)this["name"]; }
            set { this["name"] = value; }
        }

        [ConfigurationPropertyAttribute("classification", IsRequired = true)]
        public string Classification
        {
            get { return (string)this["classification"]; }
            set { this["classification"] = value; }
        }

        [ConfigurationProperty("includeRequestType", IsRequired = true)]
        public bool IncludeRequestType
        {
            get { return (bool)this["includeRequestType"]; }
            set { this["includeRequestType"] = value; }
        }

        [ConfigurationProperty("requestType")]
        public string RequestType
        {
            get { return (string)this["requestType"]; }
            set { this["requestType"] = value; }
        }

        [ConfigurationProperty("description")]
        public string Description
        {
            get { return (string)this["description"]; }
            set { this["description"] = value; }
        }


    }
}
