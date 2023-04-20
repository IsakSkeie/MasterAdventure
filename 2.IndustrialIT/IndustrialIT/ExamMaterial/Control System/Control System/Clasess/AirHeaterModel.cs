using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Diagnostics;
using System.Windows.Forms;

namespace Control_System
{
    class AirHeaterModel
    {
        float max = 50;
        float min = 0;
        double K = 3.5;
        int t = 22;
        double Tenv = 21.5;
        double Ts = 0.1;
        int timeDelay = 2;
        List<double> TimeDelay = new List<double>();
        int amount;
        double temp;

        public AirHeaterModel()
        {
            amount = (int)(timeDelay / Ts);
            TimeDelay.Add(Tenv);
            temp = Tenv;
        }

        public double Temperature(double u)
        {
            
            if (TimeDelay.Count >= amount)
            {
                TimeDelay.Add(u * K + Tenv);
                temp = (((TimeDelay.First() - temp) / t) * Ts) + temp;
                TimeDelay.RemoveAt(0);
                if (temp > max) { temp = max; }
                else if (temp < min) { temp = min; }
                else if (temp < Tenv) { temp = Tenv; }
            }
            else
            {
                temp = (((Tenv - temp) / t) * Ts) + temp;
                TimeDelay.Add(u * K + Tenv);
            }
            return temp;
        }
    }
}
