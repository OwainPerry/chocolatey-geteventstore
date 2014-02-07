using System;
using System.Configuration;
using System.Diagnostics;
using System.Net;
using System.Text;

namespace EventStoreService
{
    public class EventStoreServiceConfiguration : ConfigurationSection
    {
        [ConfigurationProperty("", IsDefaultCollection = true, IsKey = false, IsRequired = true)]
        public ServiceInstanceCollection Instances
        {
            get { return (ServiceInstanceCollection) this[""]; }
            set { this[""] = value; }
        }
    }

    public class ServiceInstanceCollection : ConfigurationElementCollection
    {
        protected override string ElementName
        {
            get { return "instance"; }
        }

        public override ConfigurationElementCollectionType CollectionType
        {
            get { return ConfigurationElementCollectionType.BasicMap; }
        }


        public ServiceInstance this[int index]
        {
            get { return BaseGet(index) as ServiceInstance; }
        }

        protected override ConfigurationElement CreateNewElement()
        {
            return new ServiceInstance();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((ServiceInstance) element).Name;
        }

        protected override bool IsElementName(string elementName)
        {
            return !String.IsNullOrEmpty(elementName) && elementName == ElementName;
        }
    }

    public class ServiceInstance : ConfigurationElement
    {
        [ConfigurationProperty("name", IsRequired = true)]
        public string Name
        {
            get { return (string) this["name"]; }
            set { this["name"] = value; }
        }

        [ConfigurationProperty("tcpPort", IsRequired = true)]
        public int TcpPort
        {
            get { return (int) this["tcpPort"]; }
            set { this["tcpPort"] = value; }
        }

        [ConfigurationProperty("httpPort", IsRequired = true)]
        public int HttpPort
        {
            get { return (int) this["httpPort"]; }
            set { this["httpPort"] = value; }
        }

        [ConfigurationProperty("dbPath", IsRequired = true)]
        public string DbPath
        {
            get { return (string) this["dbPath"]; }
            set { this["dbPath"] = value; }
        }

        public ProcessStartInfo GetProcessStartInfo(string file, IPAddress address)
        {
            var arguments = GetProcessArguments(address);

            return new ProcessStartInfo(file, arguments)
            {
                UseShellExecute = false
            };
        }

        private string GetProcessArguments(IPAddress address)
        {
            if (address == null) throw new ArgumentNullException("address");
            var sb = new StringBuilder();
            sb.AppendFormat("--ip {0} ", address);
            sb.AppendFormat("--tcp-port {0} ", TcpPort);
            sb.AppendFormat("--http-port {0} ", HttpPort);
            sb.AppendFormat("--db {0}", DbPath);
            return sb.ToString();
        }
    }
}