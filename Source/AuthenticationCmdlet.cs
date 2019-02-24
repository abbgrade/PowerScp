using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Security;
using System.Net;
using WinSCP;
using Newtonsoft.Json;

namespace PsScp
{
    public abstract class AuthenticationCmdlet : PSCmdlet
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

        protected SessionOptions Options { get; set; }

        protected override void ProcessRecord()
        {
            Options = new SessionOptions {
                HostName = HostName,
                UserName = UserName,
                SecurePassword = Password
            };

            switch (this.ParameterSetName) {
                case "Scp,Fingerprint": {
                    Options.SshHostKeyFingerprint = Fingerprint;
                    break;
                }
                case "Scp,AnyFingerprint": {
                    Options.GiveUpSecurityAndAcceptAnySshHostKey = true;
                    break;
                }
                default:
                    throw new NotImplementedException(String.Format("ParameterSet {0} is not implemented.", ParameterSetName));

            }

            WriteVerbose(string.Format("WinSCP.SessionOptions = {0}", JsonConvert.SerializeObject(Options, Formatting.Indented)));
        }
    }
}
