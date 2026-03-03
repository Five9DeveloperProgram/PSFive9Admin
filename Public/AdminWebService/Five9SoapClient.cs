using System;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Reflection;
using System.Xml;

namespace PSFive9Admin
{
    /// <summary>
    /// Five9 SOAP client wrapper that uses dynamic proxy for PowerShell 7+ compatibility
    /// </summary>
    public class Five9SoapClient : IDisposable
    {
        private object _channel;
        private object _factory;
        private Type _channelType;
        
        public string Five9DomainName { get; set; }
        public string Five9DomainId { get; set; }
        public string Version { get; set; }
        public string DataCenter { get; set; }
        
        public object Channel => _channel;
        
        public Five9SoapClient(string endpointUrl, string username, string password, int timeoutMilliseconds = 1000000)
        {
            // Configure BasicHttpBinding with Transport security for HTTPS
            var binding = new BasicHttpBinding(BasicHttpSecurityMode.Transport);
            binding.Security.Transport.ClientCredentialType = HttpClientCredentialType.Basic;
            binding.MaxReceivedMessageSize = 50 * 1024 * 1024; // 50 MB
            binding.SendTimeout = TimeSpan.FromMilliseconds(timeoutMilliseconds);
            binding.ReceiveTimeout = TimeSpan.FromMilliseconds(timeoutMilliseconds);
            binding.OpenTimeout = TimeSpan.FromMilliseconds(timeoutMilliseconds);
            binding.CloseTimeout = TimeSpan.FromMilliseconds(timeoutMilliseconds);
            
            // Increase reader quotas for large responses
            binding.ReaderQuotas.MaxDepth = 64;
            binding.ReaderQuotas.MaxStringContentLength = int.MaxValue;
            binding.ReaderQuotas.MaxArrayLength = int.MaxValue;
            binding.ReaderQuotas.MaxBytesPerRead = int.MaxValue;
            binding.ReaderQuotas.MaxNameTableCharCount = int.MaxValue;
            
            var endpoint = new EndpointAddress(endpointUrl);
            
            // Create ChannelFactory for IMetadataExchange to dynamically generate client
            // This is a workaround since we can't use New-WebServiceProxy in PS7
            var factoryType = typeof(ChannelFactory<>).MakeGenericType(typeof(IRequestChannel));
            _factory = Activator.CreateInstance(factoryType, binding, endpoint);
            
            // Set credentials using reflection
            var credentialsProp = factoryType.GetProperty("Credentials");
            var credentials = credentialsProp.GetValue(_factory);
            var userNameProp = credentials.GetType().GetProperty("UserName");
            var userName = userNameProp.GetValue(credentials);
            userName.GetType().GetProperty("UserName").SetValue(userName, username);
            userName.GetType().GetProperty("Password").SetValue(userName, password);
            
            // Create channel
            var createChannelMethod = factoryType.GetMethod("CreateChannel", Type.EmptyTypes);
            _channel = createChannelMethod.Invoke(_factory, null);
            _channelType = _channel.GetType();
        }
        
        /// <summary>
        /// Invokes a method on the SOAP service dynamically
        /// </summary>
        public object InvokeMethod(string methodName, params object[] parameters)
        {
            // Create message
            var message = Message.CreateMessage(
                MessageVersion.Soap11,
                $"http://service.admin.ws.five9.com/{methodName}",
                new BodyWriter(methodName, parameters));
            
            // Send request
            var requestMethod = _channelType.GetMethod("Request", new[] { typeof(Message) });
            var response = (Message)requestMethod.Invoke(_channel, new object[] { message });
            
            // Read response
            using (XmlDictionaryReader reader = response.GetReaderAtBodyContents())
            {
                reader.ReadToFollowing(methodName + "Response");
                return ReadResponseValue(reader);
            }
        }
        
        private object ReadResponseValue(XmlDictionaryReader reader)
        {
            // Simple implementation - expand as needed
            if (reader.IsEmptyElement)
            {
                return null;
            }
            
            return reader.ReadElementContentAsString();
        }
        
        public void Dispose()
        {
            try
            {
                if (_channel != null)
                {
                    var closeMethod = _channelType.GetMethod("Close", Type.EmptyTypes);
                    closeMethod?.Invoke(_channel, null);
                }
                
                if (_factory != null)
                {
                    var closeMethod = _factory.GetType().GetMethod("Close", Type.EmptyTypes);
                    closeMethod?.Invoke(_factory, null);
                }
            }
            catch
            {
                // Suppress disposal errors
            }
        }
    }
    
    // Custom body writer for SOAP messages
    internal class BodyWriter : System.ServiceModel.Channels.BodyWriter
    {
        private string _methodName;
        private object[] _parameters;
        
        public BodyWriter(string methodName, object[] parameters) : base(true)
        {
            _methodName = methodName;
            _parameters = parameters;
        }
        
        protected override void OnWriteBodyContents(XmlDictionaryWriter writer)
        {
            writer.WriteStartElement(_methodName, "http://service.admin.ws.five9.com/");
            
            // Write parameters
            if (_parameters != null)
            {
                for (int i = 0; i < _parameters.Length; i++)
                {
                    writer.WriteElementString($"arg{i}", _parameters[i]?.ToString() ?? "");
                }
            }
            
            writer.WriteEndElement();
        }
    }
}
