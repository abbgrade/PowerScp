using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using WinSCP;

namespace PsScp
{
    [Cmdlet(VerbsDiagnostic.Test,"NewSessionCmdlet")]
    [OutputType(typeof(Session))]
    public class NewSessionCmdletCommand : PSCmdlet
    {
        [Parameter(
            Position = 0,
            ValueFromPipelineByPropertyName = true)]
        [ValidateSet("Sftp", "Scp", "Ftp", "Webdav", "S3")]
        public string Protocol { get; set; } = "Sftp";

        [Parameter(
            Mandatory = true,
            Position = 1,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public int FavoriteNumber { get; set; }

        // This method gets called once for each cmdlet in the pipeline when the pipeline starts executing
        protected override void BeginProcessing()
        {
            WriteVerbose("Begin!");
        }

        // This method will be called for each input received from the pipeline to this cmdlet; if no input is received, this method is not called
        protected override void ProcessRecord()
        {
            var session = new Session();
            session.Open(new SessionOptions { 
                Protocol = Protocol
            });

            WriteObject(session);
        }

        // This method will be called once at the end of pipeline execution; if no input is received, this method is not called
        protected override void EndProcessing()
        {
            WriteVerbose("End!");
        }
    }
}
