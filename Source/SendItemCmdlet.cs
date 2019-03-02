using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Security;
using System.Net;
using WinSCP;
using Newtonsoft.Json;

namespace PsScp
{
    [Cmdlet(VerbsCommunications.Send, "Item")]
    public class CopyItemCmdlet : PSCmdlet
    {

        [Parameter( Mandatory = true )]
        public Session Session { get; set; }

        [Parameter( Mandatory = true, ValueFromPipelineByPropertyName = true )]
        public string Path { get; set; }

        [Parameter( Mandatory = true )]
        public string Destination { get; set; }

        [Parameter( Mandatory = false )]
        public SwitchParameter RemoveSource { get; set; } = false;

        protected override void ProcessRecord()
        {
            TransferOperationResult result = Session.PutFiles(
                localPath: Path,
                remotePath: Destination,
                remove: RemoveSource);
            result.Check();
        }
    }
}
