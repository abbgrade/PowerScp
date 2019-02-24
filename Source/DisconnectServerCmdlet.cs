using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Security;
using System.Net;
using WinSCP;
using Newtonsoft.Json;

namespace PsScp
{
    [Cmdlet(VerbsCommunications.Disconnect, "Server")]
    public class DisconnectServerCmdlet : PSCmdlet
    {

        [Parameter( Mandatory = true, ValueFromPipeline = true )]
        public Session Session { get; set; }

        protected override void ProcessRecord()
        {
            Session.Close();
            WriteVerbose("Connection closed.");
        }
    }
}
