using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Security;
using System.Net;
using WinSCP;
using Newtonsoft.Json;

namespace PsScp
{
    [Cmdlet(VerbsCommunications.Connect, "Server")]
    [OutputType(typeof(Session))]
    public class ConnectServerCmdlet : AuthenticationCmdlet
    {
        public ConnectServerCmdlet() : base() {}
        protected override void ProcessRecord()
        {
            base.ProcessRecord();

            var session = new Session();
            session.Open(Options);

            WriteObject(session);
        }
    }
}
