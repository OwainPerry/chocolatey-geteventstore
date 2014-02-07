using System;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using Topshelf;

namespace EventStoreService
{
    public class Program
    {
        public static void Main()
        {
            var configuration = (EventStoreServiceConfiguration)ConfigurationManager.GetSection("eventStore");
            var address = GetIPAddress();

            HostFactory.Run(x =>
            {
                x.RunAsLocalSystem();
                x.StartAutomatically();
                x.EnableShutdown();
                x.EnableServiceRecovery(c => c.RestartService(1));

                x.Service<EventStoreService>(s =>
                {
                    s.ConstructUsing(name => new EventStoreService(address, configuration.Instances));
                    s.WhenStarted(tc => tc.Start());
                    s.WhenStopped(tc => tc.Stop());
                });

                x.SetDescription("EventStore Service");
                x.SetDisplayName("EventStore");
                x.SetServiceName("EventStore");
            });

            Console.ReadLine();
        }

        private static IPAddress GetIPAddress()
        {
            string hostName = Dns.GetHostName();
            return Dns.GetHostAddresses(hostName).First(address =>
            {
                if (address.AddressFamily != AddressFamily.InterNetwork)
                    return false;

                return !Equals(address, IPAddress.Loopback);
            });
        }
    }
}