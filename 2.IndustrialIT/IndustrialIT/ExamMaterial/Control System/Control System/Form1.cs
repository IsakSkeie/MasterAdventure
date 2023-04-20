using NationalInstruments;
using NationalInstruments.NetworkVariable;
using NationalInstruments.NetworkVariable.WindowsForms;
using NationalInstruments.Visa;
using NationalInstruments.DAQmx;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Forms.DataVisualization.Charting;



namespace Control_System
{
    public partial class Form1 : Form
    {
        bool sim = true;
        bool auto = false;
        DAQ daq = new DAQ();
        AirHeaterModel AHM = new AirHeaterModel();
        double temp = 21;
        double U;
        PID pid = new PID();
        float P;
        float I;
        float Setpoint;
        Lowpass LP = new Lowpass();

        OPC opcServer = new OPC();

        List<string> time = new List<string>();
        List<double> temperature = new List<double>();
        List<double> SP = new List<double>();



        public Form1()
        {
            InitializeComponent();
            txtSimualtion.Text = "Simulation ON";
            opcServer.ConnectOPC();
            LP.Create(1.5, 0.5);
            samplingtime.Start();

            chart.ChartAreas[0].AxisX.IntervalType = DateTimeIntervalType.Auto;
            chart.ChartAreas[0].AxisX.LabelStyle.Format = "hh:mm:ss";
            //chart.ChartAreas[0].AxisY.LabelStyle.Format = "°C";
            
        }

        private void samplingtime_Tick(object sender, EventArgs e)
        {
            samplingtime.Stop();
            sampling();
            samplingtime.Start();

        }


        private void GetPI()
        {
            try { P = float.Parse(txtP.Text); }
            catch { P = 0; };
            try { I = float.Parse(txtI.Text); }
            catch { I = 1000000; }
            try { Setpoint = float.Parse(txtSetpoint.Text); }
            catch { Setpoint = 0; }


            U = pid.ClaculateU(P, I, temp, Setpoint, 0.1);
            txtU.Text = U.ToString("0.00") + "v";
        }

        private void sampling()
        {
            if (auto)
            {
                GetPI();
            }
            else
            {
                try { U = float.Parse(txtU.Text); }
                catch { U = 0; }
            }

            mtrVolt.Value = U;

            if (!sim)
            {
                try
                {
                    temp = LP.filtrate(daq.ReadTemp());
                    daq.SendU(U);
                }
                catch { chckSim.AutoCheck = true; }
            }
            else { temp = (AHM.Temperature(U)); }

            opcServer.SendData(temp,U);

            txtTemp.Text = temp.ToString("0.00");
            thrmTemp.Value = temp;

            plot();

        }

        private void plot()
        {
            if(temperature.Count > 240)
            {
                temperature.RemoveAt(0);
                SP.RemoveAt(0);
                time.RemoveAt(0);
            }
            temperature.Add(temp);
            SP.Add(Setpoint);
            time.Add(DateTime.Now.ToString("h:mm:ss tt"));
            chart.Series["Temperature"].Points.DataBindXY(time, temperature);
            chart.Series["Setpoint"].Points.DataBindXY(time, SP);

        }


        //Simulation underneath
        private void chckSim_CheckedChanged(object sender, EventArgs e)
        {
            if (sim) 
            { 
                sim = false;
                txtSimualtion.Text = "Simulation OF";
                tmrDelay.Stop();
                samplingtime.Start();
            }
            else 
            { 
                sim = true;
                txtSimualtion.Text = "Simulation ON";
                tmrDelay.Start();
                samplingtime.Stop();
            }
        }

        private void tmrDelay_Tick(object sender, EventArgs e)
        {
            tmrDelay.Stop();
            sampling();

            tmrDelay.Start();
        }


        private void chckAuto_CheckedChanged(object sender, EventArgs e)
        {
            if (auto)
            {
                auto = false;
            }
            else
            {
                auto = true;
            }
        }

        private void chart_Click(object sender, EventArgs e)
        {

        }
    }
}
