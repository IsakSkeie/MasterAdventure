using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NationalInstruments;
using NationalInstruments.NetworkVariable;
using NationalInstruments.NetworkVariable.WindowsForms;
using NationalInstruments.Visa;
using NationalInstruments.DAQmx;

namespace Control_System
{
    class OPC
    {
        //OPC connection
        private NetworkVariableWriter<double> _writer;
        private NetworkVariableWriter<double> _writerPower;
        private const string Loaction = @"\\localhost\SCADA\Sensor";
        private const string LoactionPower = @"\\localhost\SCADA\Power";

        public void ConnectOPC()
        {
            _writer = new NetworkVariableWriter<double>(Loaction);
            _writer.Connect();

            _writerPower = new NetworkVariableWriter<double>(LoactionPower);
            _writerPower.Connect();
        }

        public void SendData(double value1,double value2)
        {
            _writer.WriteValue(value1);
            _writerPower.WriteValue(value2);
        }
    }
}
