using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Net;

namespace EventStoreService
{
    public class EventStoreService
    {
        private readonly List<Process> _processes;
        private readonly IPAddress _address;
        private readonly ServiceInstanceCollection _instances;

        public EventStoreService(IPAddress address, ServiceInstanceCollection instances)
        {
            _address = address;
            _instances = instances;
            _processes = new List<Process>();
        }

        public void Start()
        {
            string file = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "EventStore.SingleNode.exe");

            foreach (ServiceInstance instance in _instances)
            {
                var info = instance.GetProcessStartInfo(file, _address);
                var process = Process.Start(info);
                process.Exited += (sender, args) => Stop();
                _processes.Add(process);
            }
        }

        public void Stop()
        {
            _processes.ForEach(p =>
            {
                p.Refresh();

                if (p.HasExited) return;

                p.Kill();
                p.WaitForExit();
                p.Dispose();
            });
        }
    }
}