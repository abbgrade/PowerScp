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
    public class ConnectServerCmdlet : PSCmdlet
    {
        [Parameter( Mandatory = true, ValueFromPipelineByPropertyName = true )]
        public string HostName { get; set; }

        [Parameter( Mandatory = true, ValueFromPipelineByPropertyName = true )]
        public string UserName { get; set; }

        [Parameter( Mandatory = true, ValueFromPipelineByPropertyName = true )]
        public SecureString Password { get; set; }


        [Parameter( Mandatory = true, ValueFromPipelineByPropertyName = true, ParameterSetName = "Scp,Fingerprint" )]
        public string Fingerprint { get; set; }

        [Parameter( Mandatory = true, ValueFromPipelineByPropertyName = true, ParameterSetName = "Scp,AnyFingerprint" )]
        public SwitchParameter AnyFingerprint { get; set; }

        // This method gets called once for each cmdlet in the pipeline when the pipeline starts executing
        protected override void BeginProcessing()
        {
            WriteVerbose("Begin!");
        }

        // This method will be called for each input received from the pipeline to this cmdlet; if no input is received, this method is not called
        protected override void ProcessRecord()
        {
            var session = new Session();
            var options = new SessionOptions {
                HostName = HostName,
                UserName = UserName,
                SecurePassword = Password
            };

            switch (this.ParameterSetName) {
                case "Scp,Fingerprint": {
                    options.SshHostKeyFingerprint = Fingerprint;
                    break;
                }
                case "Scp,AnyFingerprint": {
                    options.GiveUpSecurityAndAcceptAnySshHostKey = true;
                    break;
                }
                default:
                    throw new NotImplementedException(String.Format("ParameterSet {0} is not implemented.", ParameterSetName));

            }

            WriteVerbose(string.Format("WinSCP.SessionOptions = {0}", JsonConvert.SerializeObject(options, Formatting.Indented)));

            session.Open(options);

            WriteObject(session);
        }

        // This method will be called once at the end of pipeline execution; if no input is received, this method is not called
        protected override void EndProcessing()
        {
            WriteVerbose("End!");
        }
    }
}
