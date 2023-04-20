using System;
using NationalInstruments.Visa;
using NationalInstruments.DAQmx;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Control_System
{
    internal class DAQ
    {

        NationalInstruments.DAQmx.Task analogInTask = new NationalInstruments.DAQmx.Task();
        NationalInstruments.DAQmx.Task analogOutTask = new NationalInstruments.DAQmx.Task();
        AIChannel aiChannel;
        AOChannel aoChannel;
        AnalogSingleChannelReader reader;
        AnalogSingleChannelWriter writer;

        public DAQ()
        {
            try
            {
                aiChannel = analogInTask.AIChannels.CreateVoltageChannel(
                    "dev3/ai0",
                    "aiChannel",
                    AITerminalConfiguration.Differential,
                    0,
                    10,
                    AIVoltageUnits.Volts
                    );

                aoChannel = analogOutTask.AOChannels.CreateVoltageChannel(
                    "dev3/ao0",
                    "aiChannel",
                    0,
                    5,
                    AOVoltageUnits.Volts
                    );

                reader = new AnalogSingleChannelReader(analogInTask.Stream);
                writer = new AnalogSingleChannelWriter(analogOutTask.Stream);

            }
            catch { MessageBox.Show("It could not find the DAQ"); }
        }

        public double ReadTemp()
        {
            double analogDataIn = reader.ReadSingleSample();

            return analogDataIn * 7.5 + 12.5;
        }

        public void SendU(double u)
        {
            writer.WriteSingleSample(true, u);
        }
    }
}
