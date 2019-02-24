using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Security;
using System.Net;
using WinSCP;
using Newtonsoft.Json;


namespace PsScp {


    public enum Algorithm {
        SHA256,
        MD5
    }

    [Cmdlet(VerbsCommon.Get, "Fingerprint")]
    [OutputType(typeof(String))]
    public class GetFingerprintCmdlet : AuthenticationCmdlet
    {

        [Parameter( Mandatory = true, ValueFromPipelineByPropertyName = true )]
        public Algorithm Algorithm { get; set; }
        protected override void ProcessRecord() {
            base.ProcessRecord();

            string algorithm;
            switch (Algorithm) {
                case Algorithm.MD5:
                    algorithm = "MD5";
                    break;
                case Algorithm.SHA256:
                    algorithm = "SHA-256";
                    break;
                default:
                    throw new NotImplementedException(string.Format("Algorithm {0} is not implemented", Algorithm));
            }

            var session = new Session();
            var fingerprint = session.ScanFingerprint(Options, algorithm);

            WriteObject(fingerprint);
        }
    }
}
